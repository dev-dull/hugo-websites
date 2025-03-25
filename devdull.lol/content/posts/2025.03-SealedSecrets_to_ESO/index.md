---
title: 'SealedSecrets to ExternalSecrets: A Tale of Credential Migration, Maintenance, and Rotation'
date: 2025-03-06T17:00:00-08:00
draft: false
showHeadingAnchors: true
showReadingTime: true
showDate: true
---

## Why did we migrate?

The company I worked for had been a long time user of Bitnami's SealedSecrets. SealedSecrets comes with a lot of great advantages, with one of the main ones being that you don't need any special considerations when committing code to your repository. The secret is "sealed" (encrypted), so any credentials can be directly committed to the repository without any significant concerns of an account being compromised. However, new policies at the company concerning credential rotation were being implemented which highlighted some very significant pain points around with using SealedSecrets, the largest two among them being the workflow to add a secret, and the visibility into where the same credential has been used in multiple places.


## Pain points with using SealedSecrets
### Pain Point: The workflow
The team was split on if the workflow for SealedSecrets was really all that bad. The proponents would acknowledge that there was a few steps involved, but felt it wasn't all that complicated. The naysayers had complaints around getting a copy of the signing cert to use it locally. To quote my colleague at the time:

> You had to either be connected to the cluster to create them, or you had to download a copy of the signing cert locally.
>                                                                    -- Robbie, 2025-03-06


### Pain Point: The visibility
The larger issue that everyone could agree on was that it could be tough to know when credentials were repeated. For example, a dedicated account was used for pulling Docker images from a private, locally hosted repository. Let's call this account `dockerPullSvcAcct`. The `dockerPullSvcAcct` account was also used for pulling Helm charts from the same repository, but without having the experience of creating both credentials, it would be impossible to know that the two encrypted strings below represented only slight formatting variations on the same username and password combination.

```
"AgBP3MYSb1...>SNIP<...S7EJ2K3A=="
"AgAzHy+nyT...>SNIP<...d+IRyACU+4"
```

This made credential rotation a painful, all-hands event that required downtime. Because Robbie put it so succinctly, I'll quote him again:

> ...without unsealing all of them, you had no idea what content they stored and/or if they held the same data. You basically had to write a script to ensure you successfully updated all SealedSecrets that contained the same data.
>                                                                    -- Robbie, 2025-03-06

## A new challenger approaches: Enter, External Secrets
The team had a very old ticket in the backlog to test the viability of External Secrets Operator. So old, in fact, the ticket referred to it as, "kubernetes-external-secrets" and linked to an archived repository. But with the upcoming changes to credential rotation requirements, and the promise that ExternalSecrets held, it was past time to blow the dust off the ticket, update it with a link to the [new repository](https://github.com/external-secrets/external-secrets), a link to [the documentation](https://external-secrets.io/latest/), and test the viability.

### Installation and setup
The installation was straightforward. Largely, I was able to follow the [Getting started](https://external-secrets.io/latest/introduction/getting-started/) guide and got ESO and its CRDs installed without any difficulty. However, when attempting to connect the cluster to our existing Vault instance, I quickly stumbled on the function of the various CRDs that were installed. I learn best by listening, seeing, and doing, so I had skipped over a lot of the introductory materials in the documentation. Luckily, [DigitalOcean had done a live stream on the basics of External Secrets Operator](https://www.youtube.com/watch?v=EW25WpErCmA) which filled in a lot of the knowledge gaps I had inflicted on myself. The video is rather old at this point, but from an implementation standpoint, is still relevant and accurate (as of 2025-03-06), and with a little bit of jumping forward and backward in the video (20:03 through 23:22), it can really help you break down how the `ExternalSecret` configuration correlates to the structure of a secret inside of Vault which is something that the documentation lacks.

TIP: When issuing commands to inspect an `ExternalSecret` take care not to end the name of type with an `s`. Querying for `ExternalSecrets` by mistake will attempt to return two types, `ExternalSecret` and `ExternalSecretStore`.

### The encrypted elephant in the room
With ESO connected to our secret store (Vault), test secrets syncing to our EKS cluster, and the default behaviors of ESO proven to be desirable (e.g. secrets stick around even if a user misconfigures something), it was time to tackle the migration. This task was daunting and I knew that being organized from the beginning was going to be key, and tackling the issue in small, incremental steps was going to to a long way to keeping organized.

#### Disclaimer
The approach that I ended up using took a number of shortcuts. This is because I felt it didn't make sense to _learn_ `SealedSecrets` just to migrate _off_ of `SealedSecrets`. Also, because all the steps were intended to be temporary or one-time-use, I opted to take the fastest path to success instead of adhering to best practices. While this worked for me and my company with hundreds of secrets which had a large degree of duplication, a bigger organization with thousands of secrets and/or little to no duplication will likely want to take a more programmatic approach that better follows best practices. I'll point out areas of improvement and items to consider throughout the post.

#### Step 1: Finding safety
I knew that to complete the migration, I was going to need to be looking at a complete list of all the secrets and their values and storing all that information on my computer, even with all the security measures put into place by my employer, would be unsanitary from a security perspective. Since all the secrets are already in the cluster, I decided that the best place to complete my work was from within the cluster itself by bringing up a new pod. Because this pod was being used as a temporary space for a one-off task, I chose to create a `bitnami/kubectl` pod that I could `exec` into as root which also contained the `config` file used to access the cluster so I could access the secrets (the _correct_ way to configure the pod would be to configure a `ServiceAccount`, a `ClusterRole`, and a `ClusterRoleBinding`).

Create the pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hushhush
spec:
  restartPolicy: Never
  containers:
    - name: kubectl
      image: bitnami/kubectl
      command: ["/bin/tail"]
      args: ["-f", "/dev/null"]
      # Set the user, group to root so additional tooling can be installed
      securityContext:
        runAsUser: 0
        runAsGroup: 0
```

Copy the relevant Kubernetes configurations into the pod.
```bash
user@local$ kubectl cp ~/.kube/config hushhush:/config
user@local$ kubectl cp ~/wip/flux hushhush:/opt
```

Then finally configure `kubectl`, and install Python for the next steps.
```bash
user@local$ kubectl exec -it hushhush -- bash
root@pod# export KUBECONFIG=/config
root@pod# apt update
root@pod# apt install python3 python3-yaml -y
```

#### Step 2: Build a list of secrets
The next step was gathering a list of secrets which were being created by using `SealedSecret`. We used [Flux](https://fluxcd.io/) to manage the cluster, so the easiest way to capture a list of secrets that needed to be migrated was to traverse the directory structure of our Flux repository, check for `SealedSecret` configurations, and use that configuration information to generate a list of commands that would save the contents of each `secret` being created. Note that the following code is recreated from memory and was tested on non-production configurations, but likely works for 90% of cases.

`/opt/breakSeals.py`:
```python
import os
import yaml

def main():
  # SealedSecrets has a provision to set secret metadata as part of the '.spec'
  # Baed on examples (and my memory) I think setting the name and namespace this way is non-standard
  # Handle that scenario in case someone had to configure something weird.
  get_metadata = lambda d, attribute: d.get("spec", {}).get("template", {}).get("metadata", {}).get(attribute, None) or d.get("metadata", {}).get(attribute)

  path='/opt/flux'
  is_yaml = lambda file: file.endswith('.yaml') or file.endswith('.yml')
  for pwd, dirs, files in os.walk(path):
    for file in files:
      lowfi = file.lower()
      if is_yaml(lowfi):
        with open(os.path.join(pwd, file), 'r') as fin:
          yams = fin.read()
          cut_yams = yams.split('---')  # handle multiple docs in one file
          for cy in cut_yams:
            # yamo may be `None` if the file started or ended with '---', so default to empty dict
            yamo = yaml.load(cy, Loader=yaml.SafeLoader) or {}
            if yamo.get('kind', None) == 'SealedSecret':
              name = get_metadata(yamo, "name") or "ERROR"  # if no 'name' was set, then something unexpected has happened, but be non-blocking
              namespace = get_metadata(yamo, "namespace") or "default"  # if no 'namespace' was set, assume it is in the 'default' namespace

              # Print a `kubectl` command to generate a file with the secret
              print(f'kubectl get secret {name} -n {namespace} -o yaml > {namespace}_{name}.yaml')

if __name__ == '__main__':
  main()
```

We can now get a little meta and use the previous Python script to build a shell script to save our credential information into YAML files. The best practice here would have been to use a Python library to interact with the Kubernetes cluster directly (or better still, directly decrypt all the `SealedSecrets`), but I didn't feel it was worth the time to find and learn a Python library for a one-time operation when I can easily get the same result by switching to Bash.

```bash
root@pod# mkdir /opt/secrets
root@pod# echo '#!/bin/bash' > /opt/secrets/getSecrets.sh
root@pod# chmod 700 /opt/secrets/getSecrets.sh
root@pod# python3 /opt/breakSeals.py >> /opt/secrets/getSecrets.sh
root@pod# cd /opt/secrets
```

...and, of course, run the new shell script to pull back all the secrets.

```bash
root@pod# ./getSecrets.sh
```

#### Step 3: Decode your data
With secrets identified and saved to files in the pod, we still need to convert the base64 encoded strings into something human readable. If your secrets look anything like the ones I was working with, then you doubtless have credentials that look lke `{"user": "dockerPullSvcAcct", "pass": "password123"}` in addition to credentials that look like `dockerPullSvcAcct:password123`. Using External Secrets Operator, these secrets can be de-duplicated, but we won't be able to fully identify the duplication until they are properly decoded.

I opted to update the YAML files in-place so I could work through each secret one file at a time. Again, this script is a recreation which I tested against non-production code.

`/opt/decode.py`:
```python
import os
import yaml
import base64
from breakSeals import is_yaml  # re-use lambda function from previous Python script


# Used to force 'yaml.dump()' to use 'myKey:|' syntax for multi-line text so files have more readable output than a bunch of '\n' newlines.
def str_presenter(dumper, data):
  if '\n' in data:  # Check if the string contains newlines
      return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
  return dumper.represent_scalar('tag:yaml.org,2002:str', data)


def main():
  path='/opt/secrets'
  yaml.add_representer(str, str_presenter)
  for pwd, dirs, files in os.walk(path):
    for file in files:
      lowfi = file.lower()
      if is_yaml(lowfi):
        with open(os.path.join(pwd, file), 'r+') as fi:
          yams = fi.read()
          yamo = yaml.load(yams, Loader=yaml.SafeLoader)
          if 'data' in yamo:  # handle atypical scenario where the secret exists, but has no values
            for name,secret in yamo['data'].items():
              yamo['data'][name] = base64.b64decode(secret).decode('utf-8')
          else:
            print(f'No data in {file}')
          fi.seek(0)
          fi.write(yaml.dump(yamo, default_flow_style=False))
          # There's a good chance the encoded secret is longer than the decoded secret. Truncate the file to remove any trailing text.
          fi.truncate()


if __name__ == '__main__':
  main()
```

...and, of course, run it.
```bash
root@pod# cd /opt
root@pod# python3 decode.py
```

## Embracing the slog
<!-- Let's ignore the obvious fact that "The Slog" would be a fantastic title for a dark comedy about a burned-out Software Engineer working at a major IaaS platform dealing with the stress of navigating a corporation filled with people withholding their interdepartmental cooperation for their personal corporate-political gain, executives pulling strings by pitting teams against each other, and language coded to weaponize the company's core values. -->
Working through all the secrets is going to be a slog, and because every company, every "org" within that company, and every credential store (e.g. Vault) is going to have its own quirks, I can't give you a definitive guide to a successful migration, but here are some recommendations and things to keep in mind:

### Start in a test cluster and identify naming conventions
Fully migrating your "dev" or "test" cluster (or even firing up a temporary cluster) will go a long, long ways to understanding the credentials you have, the features of External Secrets Operator, and the features of your credential store. Using the (hopefully) smaller data set will help you find the _final_ shape of how credentials are going to be organized in both your credential store and Kubernetes cluster. Developing patterns before you ever touch production is going to have a massively positive impact on the final outcome and will go a long way towards preventing having that _one_ secret that doesn't follow the pattern(s) of the rest.

Having consistent naming conventions in place in both your secret store and the various components (CRDs) of External Secrets (e.g. `SecretStore`, `ExternalSecret`, etc.) will not only help you stay organized throughout the migration process, but also lay the groundwork to making secrets management a minimally painful process. There's a good chance that you are simultaneously learning both ESO and the features of your credential store. I prescribe to the DevOps philosophy of software engineering, and if you're familiar with DevOps (or read ahead a little bit), you may be able to guess what one of my final recommendations will be.

### Secrets that, "...cross the streams."
I just realized that the phrase, "Don't cross the streams." is a reference to the 1984 movie "Ghostbusters" and there's likely a multitude of people who don't have the context for what that means, exactly. In this instance, I'm referencing credentials that are used in both your production and development cluster. If you are thinking about that duplication early enough, you can avoid some rework later. Having a space in your credential store that is accessible to both your dev and prod clusters will enable you to update that credential in a single place (your credential store) and have it change everywhere. If you can't have a shared pace for regulatory or security reasons, then take the extra time to ensure that the structure and naming is mirrored exactly between the respective credential sources.

### Have a checklist
Identify a system that lets you mark (and _unmark_) each secret as it is migrated. It might be a spreadsheet listing the names of the files (please don't put passwords directly into a spreadsheet), or possibly be as simple as creating a "done" subdirectory (e.g. `/opt/secrets/done`) that you move files into, to check them off your list.

### Namespaces for your namespace
If your organization uses namespaces in Kubernetes to give teams isolated environments to run their workloads, then check the functionality of your preferred credential store and see if it provides some kind of similar isolation. Vault also has the concept of a namespace (in fact, Vault allows you to create namespaces within namespaces. ["Yo, Dawg. I heard you like namespaces..."](https://knowyourmeme.com/memes/xzibit-yo-dawg)) with its own authorization and permissions rules. This would allow for a Vault namespace that matches a Kubernetes namespace and allow teams to better manage the contents of their own secrets.

### Tempaltes in External Secrets are a powerful tool
Using the [Advanced Templating](https://external-secrets.io/latest/guides/templating/) functionality of External Secrets Operator, you can build a larger secret that contains multiple credentials sourced from your credential store. For example, we were able to use templating in combination with the "Jenkins Configuration as Code" plugin to configure Jenkins and populate the configuration with all the necessary build credentials.

### Consider using the `ClusterExternalSecret` CRD
The standard way to create secrets using External Secrets Operator is by defining an [`ExternalSecret`](https://external-secrets.io/latest/api/externalsecret/). That `ExternalSecret` is "namespaced" meaning that it exists within a namespace and will populate that namespace with a `Secret`. In addition to the `ExternalSecret` resource, there is also the [`ClusterExternalSecret`](https://external-secrets.io/latest/api/clusterexternalsecret/). These exist outside of a namespace, and create an `ExternalSecret` for you. Using the `ClusterExternalSecret` can come with a couple of advantages, and one potential disadvantage.

The first advantage is that a `ClusterExternalSecret` can be used to target multiple namespaces. For example, your company likely has a private container image registry which requires a `dockerconfigjson` secret in all of your namespaces to be able to pull images from that private registry. With a `ClusterExternalSecret`, a `namespaceSelectors` configuration can be used to target all namespaces, or a subset of namespaces to create the required `dockerconfigjson` secret.

The second advantage is that a `ClusterExternalSecret` will immediately recreate an `ExternalSecret` when that `ExternalSecret` is deleted (very much like how a `Deployment` will recreate a `pod` if you delete the pod). This provides a safety net for the accidental deletion of credentials, but additionally, when the `ExternalSecret` is recreated, it will immediately reach back out to your credential store and refresh the `Secret` with any changes that may have made in the credential store giving you the flexibility to immediately refresh the secret.

The main disadvantage I see with using a `ClusterExternalSecret` is the potential of misconfiguration which could cause teams to have access to credentials that they should not have access to. Of course, this disadvantage can be mitigated though peer reviews and monitoring.

### Have a single ~~~threaded~~ contributor process
I admit, this is a bad plan from the perspective of the ["bus" (or preferably, "circus") factor](https://en.wikipedia.org/wiki/Bus_factor), but in this situation, there's a two key benefits to limiting the number of people working on the migration to just one individual.

1. **Consistent naming:** This is the weaker of my two arguments, but all too often I've found myself in the position of being in the middle of a lengthy project where I've established a naming convention and a team member jumps in to get the project knocked out, but because nothing is documented yet, a second naming convention is introduced which doesn't get caught until after the migration is complete. I've found that this type of mismatch can linger for a prolonged period because the inconvenience of fixing it isn't worth the improvement you get out of it.
1. **Identifying credential re-use:** As outlined previously, `{"user": "dockerPullSvcAcct", "pass": "password123"}` and `dockerPullSvcAcct:password123` represent different formats for the same credential. One of the super powers of External Secrets Operator is being able to source the credential details from the same single entry in your credential store. If two people are working through the same set of credentials, this duplication may be overlooked, turing a scheduled credential rotation into a "fire drill" to identify the duplicated secret.

### Test things out and itterate!
I warned you that I prescribe to the DevOps philosophy. You've done a ton of work to get to this point. You've likely done some degree iterating as you go by identifying repeated credentials, reconfiguring ExternalSecrets, fixing minor naming convention errors, or finding credentials which need to be split out into smaller parts within your credential store. You'll also be forced to iterate further as you work through the credentials in your production cluster and identify overlap between the two clusters. But regardless of that, I recommend that you start from the beginning and work through it again. Consider [rubber duck debugging](https://en.wikipedia.org/wiki/Rubber_duck_debugging) the implementation by creating a playground namespace in your cluster and volunteer a member of your team to fire up a pod with a new secret sourced from your credential store. Take the time to walk them through the entire process of adding a net-new credential and also rotating that credential. Not only will you be mitigating the "circus" factor, but you can use the time to identify the pain points, the pitfalls, and the take-aways which will later be helpful when writing up the documentation. Also consider scheduling a meeting with stakeholders to lay out the plan (and maybe show off a little bit). Remember that one of the principle long term goals here is to make work for **everyone** easier. Identifying improvements early should mean that they'll be easier to implement than having to kludge them in later.

### Production. Finally!
Yup. It's been a slog. The good news here is that even if your production cluster has many more secrets than your dev cluster, you will have identified a system that works well for you and you'll move through them much more quickly than you did while working through your development cluster.

## The "Gotcha'!" moment: ESO's "Pathological" behavior towards Vault
### The problem

_Disclaimer:_ This issue transpired in 2022. Improvements and fixes may already be in place (but they don't appear to be).

I don't think I've ever seen the adoption of a new tool that didn't come without one or more hiccup, and External Secrets Operator was no exception. In my first iteration of setting up External Secrets Operator, I had manually set up a one-off secret with a Vault token (as outlined in the first example in the [Vault Provider documentation](https://external-secrets.io/latest/provider/hashicorp-vault/)). In my second iteration, I set up a custom read-only `AppRole` in our Vault namespace. Once I had made that change, A colleague of mine on the Security team responsible for managing the Vault cluster noticed a significant increase on the load on the Vault cluster, and the cause was unexpected. To understand the issue, we need to walk through the basics of how secrets were being refreshed in the cluster. From my colleagues analysis, these are the steps are performed by every `ExternalSecret` in the cluster, which is effectively a one-to-one ratio with each `secret`.

1. Authenticate with the Vault server and get the authentication token.
1. Pull back the value(s) for the the `secret`.
1. Update the `secret` in the Kubernetes cluster.
1. Revoke the authentication token.

At first glance, this all sounds very reasonable. However, when you revoke an authentication token in Vault, that action is treated as high priority task that pauses other work in the Vault cluster to complete it. With every single `ExternalSecret` behaving this way, this can cause performance issues in the Vault cluster very quickly, and for that reason, my colleague described ESO's behavior as, "...absolutely pathological behavior." which I imagine were the kindest words he used to express his frustration that day.

### The quick-fix
Not having an immediate fix handy, my first step was to lengthen the refresh interval for all secrets. In some cases, I went from 5 minutes all the way up to 2 hours. Obviously, this wasn't a long term solution, but it gave the Security team confidence that I was engaged in getting the issue resolved, and it took enough pressure off of the Vault server that it gave me time to address the issue with a more long term solution.

### The "experimental" fix
By diving into the code base, I discovered that the Vault provider for ESO has an [undocumented flag that had recently been added](https://github.com/external-secrets/external-secrets/pull/1537) which will allow Vault tokens to be cached and reused. Since then, it appears that the feature has been reimplemented to allow for a, "[late initialization of the flag](https://github.com/external-secrets/external-secrets/pull/1640)" which I interpret to mean that the flag can be enabled at runtime. Even now (Late March of 2025), the flag appears to be undocumented, and to still be considered experimental. The Vault instance used in this instance was also used multiple services and teams. From a production readiness standpoint, the flag with "experimental" in the name did not appear to ready for prime time.

### The great ESO Rube Goldberg machine
This is going to be a little crazy. I considered making a diagram here, but I think a diagram would actually be more confusing as and explaining it in paragraph form would be worse, so here is a very boring list:

- I manually used the ready-only `AppRole` I previously mentioned to create a Vault authentication token.
- I bootstrapped the Kubernetes cluster with a `secret` I'll call `vaultToken` which contained the token from the previous step and will be used by the `SecretStore` for ESO to authenticate to Vault.
- I created a new `AppRole` in Vault that has permissions to read and write to a single secret in Vault. I'll call this role, `singleSecretRole` and the vault secret it can write to, `singleSecret`
- I created a `cronjob` in the Kubernetes cluster which:
  - Authenticated with Vault using the read-only `AppRole` to generate a new token
  - Authenticated with Vault using the `AppRole`, `singleSecret`
  - Use the `singleSecretRole` and update the Vault secret `singleSecret` with the new token for the ready-only `AppRole`
- I then had an `ExternalSecret` which synced `singleSecret` in Vault to the `vaultToken` secret in Kubernetes.

The read-only Vault token was set to live for 8 hours and the cron job was set to run every 6 hours with some retry options enabled. This was done to give the Vault server some ability to be offline due to maintenance or an outage. However, this also meant that if the Vault server was ever offline for a prolonged period of time, the Kubernetes cluster would have to be manually bootstrapped with a fresh Vault token again.

## Iterate, again!
There's still plenty of features available in External Secrets Operator that aren't discussed in this post. For example, many of the credential stores supported by ESO offer [Generators](https://external-secrets.io/latest/guides/generator/) and the [`PushSecret` resource](https://external-secrets.io/latest/guides/pushsecrets/) was recently added. The combination of the two has the potential to create fully automate a credential rotation process. Keep tabs on the ESO documentation, and file tickets for your backlog when you identify areas of improvement. ESO is a powerful tool for your cluster that makes secrets management surprisingly easy.
