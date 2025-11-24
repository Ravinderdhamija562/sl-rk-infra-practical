# sl-rk-infra-practical

## Install Application

```bash
kubectl create ns devops-practical
helm upgrade --install devops-practical ./devops-practical/helm -n devops-practical
```

## Access Application

### Using Port Forwarding

```bash
# Forward local port 8080 to the application service port 80
kubectl port-forward -n devops-practical svc/devops-practical 8080:80

# Access the application at:
# http://localhost:8080
```

### Alternative: Direct Pod Port Forward

```bash
# Get the pod name
kubectl get pods -n devops-practical

# Forward to the pod directly (replace POD_NAME)
kubectl port-forward -n devops-practical POD_NAME 8080:3000

# Access at http://localhost:8080
```
