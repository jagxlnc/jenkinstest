Managing IBM Cloud Private Capacity
---

#### Overall Capacity
Overall capacity of a Kubernetes cluster is defined by the amount of CPU, Memory and Disk space allocated to the nodes.
[IBM Sizing T-shirt Sizes Table](https://github.com/ibm-cloud-architecture/refarch-privatecloud/blob/master/Sizing.md)

By default a maximum of 110 pods can be assigned to a node. This value can be [changed](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_2.1.0/installing/config_yaml.html)  

By default, pods run with **unbounded** CPU and memory limits. This means that any pod in the system will be able to consume as much CPU and memory on the node that executes the pod.

[Kubernetes documentation section related to CPU and Memory Quotas, Limits and Defaults ](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/#motivation-for-default-cpu-limits-and-requests)

[Kubernetes documentation section on how compute resources for a container are managed ](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/)

In summary, when you create a Pod, the Kubernetes scheduler selects a node for the Pod to run on. Each node has a maximum capacity for each of the resource types: the amount of CPU and memory it can provide for Pods. The scheduler ensures that, for each resource type, the sum of the resource requests of the scheduled Containers is less than the capacity of the node. Note that although actual memory or CPU resource usage on nodes is very low, the scheduler still refuses to place a Pod on a node if the capacity check fails. This protects against a resource shortage on a node when resource usage later increases, for example, during a daily peak in request rate.

The command `kubectl describe node <nodename>` will display the current status for a given node.

```
Capacity:
 cpu:                4
 ephemeral-storage:  201667536Ki
 hugepages-2Mi:      0
 memory:             8174900Ki
 pods:               110
Allocatable:
 cpu:                4
 ephemeral-storage:  201565136Ki
 hugepages-2Mi:      0
 memory:             8072500Ki
 pods:               110
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  CPU Requests  CPU Limits  Memory Requests  Memory Limits
  ------------  ----------  ---------------  -------------
  200m (5%)     200m (5%)   256Mi (3%)       256Mi (3%)
```

Simple examples (assuming a node with 4 CPUs/4000m and 8GB RAM/8000Mi)
- 40 pods with CPU Requests of 100m would use the 4000m CPU
- 40 pods with Memory Requests of 200m would use the 8000Mi RAM

#### Managing Capacity
There are a number of methods available to an administrator to control tenants and their pods in a Kubernetes cluster.

| Parameter       | When it's evaluated | Purpose |
| ------------- |-------------|-----|
|Quotas	| Request Time |	To limit how many resources a single tenant can request so that they cannot take over the cluster.|
|Requests |	Scheduling Time |	Requests are used to choose which node is the best fit for the given workload (together with other criteria).|
|Limits |	Run Time | Limits are used to limit the maximum amount of resources that a container can use at runtime.|

[Eviction Policies](https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/) are used by Kubernetes to reclaim memory or disk when compute resources are low. By default, IBM Cloud Private is configured with the following eviction policy which will start to evict pods when less than 100MB of Memory and/or 100MB of disk space is available:

--eviction-hard=memory.available<100Mi,nodefs.available<100Mi

Kuberentes will not evict pods if they exceed their CPU limits. It is recommended that [AutoScaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) is used to manage pods that have spikes in CPU usage.

Recommendations:
- Define Pod Quotas for Namespaces
- Define Default CPU and Memory Requests and Limits for Namespaces
- Define Maximum and Minimum CPU and Memory constraints for a Namespace
- Analyze the actual CPU and Memory usage of the containers during performance testing to refine their CPU and Memory Request and Limit values.
