# NGINX Ingress Controller Setup for DevOps Practical

NGINX Ingress Controller is deployed using the [official Kubernetes NGINX Ingress Controller Helm chart](https://github.com/kubernetes/ingress-nginx) in a dedicated namespace (`ingress-nginx`) to manage external access to cluster services.

## Install NGINX Ingress Controller

```bash
# 1. Create namespace (if not present)
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

# 2. Add NGINX Ingress Controller repo & update
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# 3. Install/upgrade NGINX Ingress Controller with custom values
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --values ingress-controller-values.yaml \
  --wait --timeout 5m
```
