---
name: implementing-kubernetes
description: 'Kubernetes deployment patterns, Helm charts, and cluster management. Use when deploying applications to K8s, designing workload configurations, implementing scaling strategies, or managing cluster resources.'
---

# Kubernetes Patterns

## When to Use

- Deploying applications to Kubernetes
- Designing Deployment, StatefulSet, or Job configurations
- Implementing auto-scaling (HPA, VPA, KEDA)
- Creating or modifying Helm charts
- Setting up ingress, networking, and service mesh
- Configuring resource requests, limits, and QoS

## Project Detection

Check which Kubernetes tooling the project uses:
- `helm/` or `Chart.yaml` → Helm charts
- `kustomize/` or `kustomization.yaml` → Kustomize
- `k8s/` or `kubernetes/` with `*.yaml` → Raw manifests
- `skaffold.yaml` → Skaffold for local dev
- `argocd/` or `Application` resources → ArgoCD GitOps
- `flux-system/` or `Kustomization` CRD → Flux GitOps

Use `context7` to look up Kubernetes API versions and syntax.

## Workload Type Decision

| Workload Type | Use When |
|---------------|----------|
| **Deployment** | Stateless apps, web servers, APIs |
| **StatefulSet** | Databases, stateful apps needing stable identity |
| **DaemonSet** | Node-level agents (logging, monitoring) |
| **Job** | One-time tasks, batch processing |
| **CronJob** | Scheduled recurring tasks |

## Deployment Configuration

### Resource Management

```yaml
resources:
  requests:    # Scheduler uses for placement
    memory: "256Mi"
    cpu: "100m"
  limits:      # Kubelet enforces these
    memory: "512Mi"
    cpu: "500m"
```

**Rules:**
- Always set requests (required for scheduling)
- Set memory limits to prevent OOM impact on node
- CPU limits optional (can cause throttling)
- Request:Limit ratio of 1:2 is good starting point

### QoS Classes

| Class | Condition | Eviction Priority |
|-------|-----------|-------------------|
| **Guaranteed** | requests == limits (all containers) | Last to evict |
| **Burstable** | requests < limits | Medium |
| **BestEffort** | No requests or limits | First to evict |

**Rule:** Production workloads should be Guaranteed or Burstable, never BestEffort.

### Probes Configuration

```yaml
livenessProbe:      # Restarts container if fails
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:     # Removes from Service if fails
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 3

startupProbe:       # Delays liveness until startup complete
  httpGet:
    path: /healthz
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

**Rules:**
- Always configure readinessProbe (graceful traffic handling)
- Use startupProbe for slow-starting apps (instead of long initialDelaySeconds)
- livenessProbe should check app health, not dependencies

### Pod Disruption Budget

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  minAvailable: 2        # OR maxUnavailable: 1
  selector:
    matchLabels:
      app: api
```

**Rule:** Always create PDB for production workloads to ensure availability during node drains.

### Pod Anti-Affinity

```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: api
          topologyKey: kubernetes.io/hostname
```

**Rule:** Spread replicas across nodes/zones for high availability.

## Scaling Strategies

### Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300  # Prevent flapping
```

### Scaling Decision Matrix

| Scaling Type | Use When | Tool |
|--------------|----------|------|
| CPU-based | General compute workloads | HPA |
| Memory-based | Memory-intensive apps | HPA |
| Custom metrics | Queue depth, request rate | HPA + Prometheus Adapter |
| Event-driven | Message queues, scheduled jobs | KEDA |
| Vertical | Right-sizing requests/limits | VPA |

## Helm Chart Structure

```
mychart/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values
├── values-dev.yaml     # Environment overrides
├── values-prod.yaml
├── templates/
│   ├── _helpers.tpl    # Template helpers
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   ├── pdb.yaml
│   └── configmap.yaml
└── charts/             # Dependencies
```

### Helm Best Practices

```yaml
# values.yaml - use structured defaults
replicaCount: 2

image:
  repository: myapp
  tag: ""  # Override in CI, not here
  pullPolicy: IfNotPresent

resources:
  requests:
    memory: "256Mi"
    cpu: "100m"
  limits:
    memory: "512Mi"

# Enable/disable optional components
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
```

**Rules:**
- Don't hardcode image tags in values.yaml (set in CI)
- Use `{{ include "mychart.fullname" . }}` for resource names
- Provide sensible defaults, override per environment

## Ingress Configuration

### Ingress Class Decision

| Ingress Controller | Use When |
|-------------------|----------|
| **nginx-ingress** | General purpose, widely supported |
| **AWS ALB** | AWS-native, integrated with WAF/ACM |
| **Traefik** | Simple setup, automatic HTTPS |
| **Istio Gateway** | Service mesh already in use |

### Ingress Example (nginx)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.example.com
      secretName: api-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api
                port:
                  number: 80
```

## Security Context

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  fsGroup: 1000
  seccompProfile:
    type: RuntimeDefault

containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
          - ALL
```

**Rule:** Always run as non-root with minimal capabilities in production.

## Process

1. **Discover context** → Check existing K8s manifests, Helm charts, Kustomize
2. **Choose workload type** → Deployment, StatefulSet, Job based on requirements
3. **Configure resources** → Set requests/limits based on profiling or estimates
4. **Add probes** → Configure readiness, liveness, and startup probes
5. **Enable scaling** → Add HPA/KEDA based on scaling requirements
6. **Add resilience** → PDB, pod anti-affinity, topology spread
7. **Configure security** → Security context, network policies
8. **Validate** → `kubectl apply --dry-run=server`, helm template

## Checklist

- [ ] Resource requests and limits defined
- [ ] Readiness and liveness probes configured
- [ ] PodDisruptionBudget created for production
- [ ] Pod anti-affinity or topology spread configured
- [ ] HPA configured for variable workloads
- [ ] Security context with non-root user
- [ ] Image pull policy appropriate (Never use `latest` in prod)
- [ ] Labels consistent (`app`, `version`, `environment`)
- [ ] Namespace isolation per environment

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Use `latest` image tag | Pin specific versions or SHA |
| Skip resource requests | Always set requests for scheduling |
| Single replica in production | Minimum 2 replicas with PDB |
| Run as root | Use non-root user with minimal caps |
| Missing readiness probe | Configure probes for graceful traffic |
| `kubectl apply` in production | GitOps with ArgoCD/Flux |
| Hardcode values in manifests | Use Helm values or Kustomize overlays |
| Ignore pod eviction | Set PDB to maintain availability |

## Related Skills

- `implementing-observability` - For K8s monitoring and logging setup
- `implementing-ci-cd` - For K8s deployment pipelines
- `managing-secrets` - For K8s secret management patterns
- `implementing-terraform-modules` - For provisioning K8s clusters
