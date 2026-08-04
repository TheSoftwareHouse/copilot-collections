---
name: tsh-deploy-kubernetes
description: "Create Kubernetes deployments, Helm charts, and workload configurations following production-ready patterns for high availability, resource management, and secrets handling."
user-invocable: false
---
<routing>Designated agent: `tsh-devops-engineer`; private workflow skill: `tsh-deploy-kubernetes`.</routing>

Create Kubernetes deployments, Helm charts, and workload configurations following project conventions, production readiness, health probes, scaling, resource limits, and secure secret handling. Escalate service-mesh, multi-cluster, and topology decisions to `tsh-architect`.

<required-skills>`tsh-implementing-kubernetes`, `tsh-managing-secrets`, `tsh-technical-context-discovering`</required-skills>
<workflow>Discover existing manifests and namespace patterns; implement deployments, services, ingress, resources, probes, HPA/PDB, affinity, and secrets; validate manifests; report current state, proposed configuration, prerequisites, verification, and files.</workflow>
<constraints>Redirect Terraform, CI/CD, and observability work to `tsh-implement-terraform`, `tsh-implement-pipeline`, and `tsh-implement-observability`.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-deploy-kubernetes:v1 -->
