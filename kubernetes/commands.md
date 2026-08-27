# Azure Container Registry

## 1. Get the ACR login server

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

## 2. Authenticate Docker with ACR

```bash
az acr login --name acrretailflowdev
```

Expected:

```text
Login Succeeded
```

## 3. Tag the local image for ACR

```bash
docker tag retailflow-api:dev acrretailflowdev.azurecr.io/retailflow-api:dev
```

Check both image tags:

```bash
docker images | grep retailflow-api
```

## 4. Push the image to ACR

```bash
docker push acrretailflowdev.azurecr.io/retailflow-api:dev
```

## 5. Verify the repository exists in ACR

```bash
az acr repository list \
  --name acrretailflowdev \
  -o table
```

Expected:

```text
retailflow-api
```

## 6. Verify image tags in ACR

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
---

# Deploy Flask Application to AKS

## 1. Connect to AKS 

After recreating the AKS cluster, retrieve the Kubernetes credentials:

```bash
az aks get-credentials \
  --resource-group rg-retailflow-devops-platform \
  --name aks-retailflow-dev \
  --overwrite-existing
````

Verify the current Kubernetes context:

```bash
kubectl config current-context
```

Verify connectivity to the AKS cluster:

```bash
kubectl cluster-info
```

## 2. Verify AKS

```bash
kubectl get nodes
```

## 3. Deploy the dev namespace

Create the Kubernetes `dev` namespace:

```bash
kubectl apply -f kubernetes/namespaces/dev.yaml
```

Verify the namespace:

```bash
kubectl get namespace dev
```

Expected:
```bash
NAME   STATUS   AGE
dev    Active   ...
```
Verify that the namespace is currently empty:
```bash
kubectl get pods -n dev
```
Expected:
```bash
No resources found in dev namespace.
```

## 4. Deploy the application

```bash
kubectl apply -f kubernetes/deployment/retailflow-api.yaml
kubectl get deployment retailflow-api -n dev
kubectl get pods -n dev
```

## 5. Check application logs

```bash
kubectl logs -n dev <pod-name>
```

Example:

```bash
kubectl logs -n dev retailflow-api-xxxxxxxxxx-xxxxx
```

## 6. Create the Kubernetes Service

```bash
kubectl apply -f kubernetes/service/retailflow-api.yaml
kubectl get service -n dev
```

## 7. Check Service routing

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

## 8. Monitor the rollout
```bash
kubectl rollout status deployment/retailflow-api -n dev
```
Expected:
```bash
deployment "retailflow-api" successfully rolled out
```
## 9. Verify the Pod
```bash
kubectl get pods -n dev
```
Expected:
```bash
READY   STATUS
1/1     Running
```

## 10. Inspect the Pod
```bash
kubectl get pods -n dev
kubectl describe pod -n dev <pod-name>
```
Check for:
```bash
Liveness:  http-get http://:5000/health
Readiness: http-get http://:5000/health
```

## 11. Check Pod details
```bash
kubectl get pod -n dev <pod-name> -o wide
```

## 12. Check application logs
```bash
kubectl logs -n dev <pod-name>
```

## 13. Test the Service

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

## Troubleshooting

```bash
kubectl get pods -n dev
kubectl describe pod -n dev <pod-name>
kubectl logs -n dev <pod-name>
kubectl get deployment retailflow-api -n dev -o yaml
kubectl get service retailflow-api -n dev
```

Check the container port:

```bash
kubectl get deployment retailflow-api -n dev -o yaml | grep containerPort
```

## Port flow

```text
Flask application  → 5000
Container port     → 5000
Service port       → 80
Service targetPort → 5000
Local port-forward → 8080:80
```

`containerPort` describes the application's container port; it does not make Flask listen on that port.

