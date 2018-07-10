BCBS-SC Environment Sizing
---

A worker node with 8 CPUs and 32 GB RAM can host ~64 Liberty Containers with memory requests of 512MB each.

-------------------
### Recommended Option - DevOps in QUAL
The DevOps tools will be co-located with other applications in the QUAL cluster.

#### Cluster 1: Development (DEV) and System Test (SYS)
A shared cluster with isolated resources for DEV and SYS

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 2: QUAL (QUAL) and DEVOPS TOOLS
The QUAL cluster will also host the DEVOPS tools (Jenkins etc)

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 3: Production (PROD)
Dedicated Production cluster.

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 4: Disaster Recover (DR)
DR cluster would be a restored version of the production cluster, it does not actually exist until a DR event occurs.

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

-------------------
### Alternate Option - Dedicated DevOps
The DevOps tools will be located in a dedicated cluster.

#### Cluster 1: Development (DEV) and System Test (SYS)
A shared cluster with isolated resources for DEV and SYS

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 2: DevOps
The DevOps cluster will host the DEVOPS tools (Jenkins etc)

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
| Boot	| 1	| 2	| 8	| 250 |
|	Master/Management	| 3	| 8	| 32	| 250 |
|	Proxy	| 3	| 4	| 16	| 250 |
|	Worker | 2	| 8	| 32	| 250 |
|	Worker (zLinux) | 2 | 8 | 32	| 250 |
|	Total  | 10	| 62	| 248	| 2500 |

#### Cluster 3: QUAL (QUAL)
A dedicated QUAL cluster

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 4: Production (PROD)
Dedicated Production cluster.

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |

#### Cluster 5: Disaster Recover (DR)
DR cluster would be a restored version of the production cluster, it does not actually exist until a DR event occurs.

| Node type | Number of nodes | CPU | Memory (GB) | Disk (GB) |
| :---: | :---: | :---: | :---: | :---: |
|	Boot	| 1	| 2	| 8	| 250 |
|	Master	| 3	| 8	| 32 | 250 |
|	Management | 2	| 8	| 32 | 300 |
|	Proxy	| 3	| 4	| 16 | 250 |
|	VA	| 3	| 6	| 24	| 500 |
|	Worker (x86) | 2 | 8 | 32	| 250 |
|	Worker (zLinux) | 6 | 8 | 32	| 250 |
|	Total |	20	| 136	| 544	| 5850 |
