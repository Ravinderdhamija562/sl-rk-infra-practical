# MongoDB Setup for DevOps Practical

MongoDB is deployed using the [Bitnami MongoDB Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mongodb) in a dedicated namespace (`mongodb`) to keep it isolated from the application.

## Install MongoDB

```bash
# 1. Create namespace (if not present)
kubectl create namespace mongodb --dry-run=client -o yaml | kubectl apply -f -

# 2. Add Bitnami repo & update
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 3. Install/upgrade MongoDB with custom values
helm upgrade --install mongodb bitnami/mongodb \
  --namespace mongodb \
  --values mongodb-values.yaml \
  --wait --timeout 5m
```

### Test connection from a pod

```bash
kubectl run -it --rm --restart=Never mongo-test --image=mongo:7.0 --namespace=mongodb -- \
  mongosh "mongodb://admin:CHANGE_ME_ADMIN_PASSWORD@mongodb.mongodb.svc.cluster.local:27017/admin"
```

**Note:** The default credentials are set in `mongodb-values.yaml`:

- Root password: `CHANGE_ME_ROOT_PASSWORD`
- Admin username: `admin`
- Admin password: `CHANGE_ME_ADMIN_PASSWORD`
- Database: `admin`

**Security Warning:** These are placeholder passwords. In production, use secure passwords and store them in Kubernetes Secrets or a secrets management solution like AWS Secrets Manager.
