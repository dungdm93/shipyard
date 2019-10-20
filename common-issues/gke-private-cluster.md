GKE Private Cluster
===================

## 1. Intro
In GKE private clusters, VPC peering automatically configured between your Kubernetes cluster’s network in a separate Google managed project. The default firewall-rules *only open ports 10250 (kubelet) and 443 (HTTPS) between masters and worker nodes*.

In some special cases as Admission Webhook, masters need to access services in worker nodes. This means that in order to webhook work in GKE private cluster:
* webhook service MUST use port 443, or
* your need configure an additional firewall rule to allow connection from masters CIDR to your webhook service.

## 2. Configs
* View cluster master's CIDR block
    ```bash
    gcloud container clusters describe [CLUSTER_NAME]
    ```
    In the command output, take note of the value in the `masterIpv4CidrBlock` field.

* View existing firewall rules
    ```bash
    gcloud compute firewall-rules list \
        --filter 'name~^gke-[CLUSTER_NAME]' \
        --format 'table(
            name,
            network,
            direction,
            sourceRanges.list():label=SRC_RANGES,
            allowed[].map().firewall_rule().list():label=ALLOW,
            targetTags.list():label=TARGET_TAGS
        )'
    ```
    In the command output, take note of the value in the `TARGET_TAGS` field.

* Add a firewall rule
    ```bash
    gcloud compute firewall-rules create [FIREWALL_RULE_NAME] \
        --action ALLOW \
        --direction INGRESS \
        --source-ranges [MASTER_CIDR_BLOCK] \
        --rules [PROTOCOL]:[PORT] \
        --target-tags [TARGET]
    ```

* **NOTE**: Add `--zone GKE_ZONE` and `--project GCLOUD_PROJECT` if above commands error.

## 3. References
* GKE private cluster: [add ddding firewall rules](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#add_firewall_rules)
* [Filtering and formatting fun with gcloud](https://cloud.google.com/blog/products/gcp/filtering-and-formatting-fun-with)
