# Assignment Context

This chart converts static Kubernetes manifests into a parameterized, environment-aware Helm chart that can scale from development to production.

## Note
- The voting-app-chart dir contains the generated helm chart 
- The voting-app-manifests dir contains the initial kubernetes manifests

## Components

This chart deploys five microservices:

- **Vote**  - Frontend web app where users cast votes
- **Result**  - Frontend web app displaying real-time results
- **Worker**  - Background service processing votes from Redis to PostgreSQL
- **Redis** - In-memory data store for vote queue
- **PostgreSQL** - Persistent database storing final results

### Kubernetes Resources

The chart creates the following Kubernetes resources per environment:

**Development (10 resources):**
- 5 Deployments (vote, result, worker, redis, postgresql)
- 4 Services (vote, result, redis, postgresql)

**Staging (15 resources):**
- 5 Deployments 
- 4 Services
- 3 HorizontalPodAutoscalers (vote, result, worker)
- 2 PersistentVolumeClaims (redis, postgresql)

**Production (15 resources):**
- 5 Deployments 
- 4 Services
- 3 HorizontalPodAutoscalers (vote, result, worker)
- 2 PersistentVolumeClaims (redis, postgresql)

## My Approach

### Chart Structure
I organized the chart following Helm conventions with clear separation between base configuration and environment-specific overrides. The base `values.yaml` contains sensible defaults, while environment-specific files (`values-dev.yaml`, `values-staging.yaml`, `values-production.yaml`) override only what differs per environment. 

The templates directory contains deployments for all five services (vote, result, worker, redis, postgresql), along with their associated services, HorizontalPodAutoscalers, and PersistentVolumeClaims. I used `_helpers.tpl` to create reusable template functions for common patterns like labels and resource names

### Scalability

First, horizontal scaling through configurable replica counts and HorizontalPodAutoscalers that automatically adjust pod counts based on CPU and memory usage. Second, vertical scaling through parameterized resource requests and limits that can be tuned per environment. Third, storage scaling through configurable PersistentVolumeClaim sizes that grow with data needs.

In development, the focus is on minimal resource usage with single replicas and no autoscaling. Production configurations enable autoscaling and provision substantial storage to handle 'real' workloads.

### Configuration

The chart provides parameters for image tags, resource limits, service types, health probe timings, and feature toggles. This means teams can customize the chart to their needs without modifying templates.

I implemented feature toggles for optional capabilities like Ingress for external access and monitoring integrations. These are disabled by default in development but can be enabled in production.



## Installation

Go to dir
```bash
cd voting-app-chart
```
Deploy to development:
```bash


helm install my-app . -f values-dev.yaml
```

Deploy to staging:
```bash
helm install my-app . -f values-staging.yaml
```

Deploy to production:
```bash
helm install my-app . -f values-production.yaml
```

## Validation

Verify the chart renders correctly:
```bash
# Lint for errors
helm lint .

# Preview rendered templates
helm template test . -f values-production.yaml > rendered-prod.yaml
```

# Count resources per environment
Development creates 10 resources. 
Production creates 15 resources (adds HPAs and PVCs).

## Configuration Reference
Key configuration sections in `values.yaml`:

**Component Configuration**: Each microservice (vote, result, worker, redis, postgresql) has its own section with settings for replicas, resources, autoscaling, images, and health probes.

**Global Settings**: The `global.environment` value tags all resources with the environment name. Global labels and annotations apply to all components.

**Feature Toggles**: Enable or disable Ingress, monitoring, network policies, and other optional features through `features.*` values.

**Security Contexts**: Pod and container security settings are configurable at both global and per-component levels.

See `values.yaml` for complete documentation of all available parameters.