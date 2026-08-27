# RetailFlow Kubernetes Deployment Runbook

This runbook covers publishing the Docker image to Azure Container Registry (ACR), connecting to the development AKS cluster, deploying the application, and verifying the service.

## 1. Publish the Image to ACR

### 1.1 Get the ACR login server

```bash
az acr show \
  --name acrretailflowdev \
  --query loginServer \
  -o tsv
```

Expected:

```text
acrretailflowdev.azurecr.io
```

### 1.2 Authenticate Docker with ACR

```bash
az acr login --name acrretailflowdev
```

Expected:

```text
Login Succeeded
```

### 1.3 Tag and push the local image

```bash
docker tag retailflow-api:dev acrretailflowdev.azurecr.io/retailflow-api:dev
docker images | grep retailflow-api
docker push acrretailflowdev.azurecr.io/retailflow-api:dev
```

### 1.4 Verify the image in ACR

```bash
az acr repository list \
  --name acrretailflowdev \
  -o table
```

Expected:

```text
retailflow-api
```

```bash
az acr repository show-tags \
  --name acrretailflowdev \
  --repository retailflow-api \
  -o table
```

Expected:

```text
dev
```

## 2. Connect to AKS

After recreating the AKS cluster, retrieve the Kubernetes credentials:

```bash
az aks get-credentials \
  --resource-group rg-retailflow-devops-platform \
  --name aks-retailflow-dev \
  --overwrite-existing
```

Verify the current context, cluster connectivity, and nodes:

```bash
kubectl config current-context
kubectl cluster-info
kubectl get nodes
```

## 3. Deploy the Development Workload

### 3.1 Create the `dev` namespace

```bash
kubectl apply -f kubernetes/namespaces/dev.yaml
kubectl get namespace dev
```

Expected:

```text
NAME   STATUS   AGE
dev    Active   ...
```

Confirm that the namespace is initially empty:

```bash
kubectl get pods -n dev
```

Expected:

```text
No resources found in dev namespace.
```

### 3.2 Create and verify the ConfigMap

```bash
kubectl apply -f kubernetes/config/retailflow-api.yaml
kubectl get configmap -n dev
kubectl describe configmap retailflow-api-config -n dev
```

### 3.3 Deploy the application

```bash
kubectl apply -f kubernetes/deployment/retailflow-api.yaml
kubectl get deployment retailflow-api -n dev
kubectl get pods -n dev
```

Monitor the rollout:

```bash
kubectl rollout status deployment/retailflow-api -n dev
```

Expected:

```text
deployment "retailflow-api" successfully rolled out
```

Verify the pod and inspect its logs:

```bash
kubectl get pods -n dev
kubectl logs -n dev <pod-name>
```

Example:

```bash
kubectl logs -n dev retailflow-api-xxxxxxxxxx-xxxxx
```

Expected pod status:

```text
READY   STATUS
1/1     Running
```

### 3.4 Create the Kubernetes Service

```bash
kubectl apply -f kubernetes/service/retailflow-api.yaml
kubectl get service -n dev
```

Check service routing:

```bash
kubectl describe service retailflow-api -n dev
kubectl get endpoints retailflow-api -n dev
```

Expected:

```text
Service port: 80
Target port: 5000
Endpoint: <pod-ip>:5000
```

## 4. Verify the Deployment

### 4.1 Verify the ConfigMap environment variables

Get the pod name:

```bash
kubectl get pods -n dev
```

Then inspect the application variables:

```bash
kubectl exec -n dev <pod-name> -- env | grep '^APP_'
```

Expected:

```text
APP_ENV=dev
APP_PORT=5000
```

### 4.2 Inspect pod health and details

```bash
kubectl get pods -n dev
kubectl describe pod -n dev <pod-name>
kubectl get pod -n dev <pod-name> -o wide
```

Check for the health probes:

```text
Liveness:  http-get http://:5000/health
Readiness: http-get http://:5000/health
```

### 4.3 Test the service locally

Start port-forwarding:

```bash
kubectl port-forward -n dev service/retailflow-api 8080:80
```

In another terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

Expected:

```json
{"message":"RetailFlow API is running"}
{"status":"healthy"}
```

## 5. Troubleshooting

Use these commands to inspect the workload, deployment, and service:

```bash
kubectl get pods -n dev
kubectl describe pod -n dev <pod-name>
kubectl logs -n dev <pod-name>
kubectl get deployment retailflow-api -n dev -o yaml
kubectl get service retailflow-api -n dev
kubectl get deployment retailflow-api -n dev -o yaml | grep containerPort
```

## 6. Port Flow

```text
Flask application  -> 5000
Container port     -> 5000
Service port       -> 80
Service targetPort -> 5000
Local port-forward -> 8080:80
```

`containerPort` describes the application's container port; it does not make Flask listen on that port.

