# Day 10 — Deploy Flask Application to AKS

## Verify AKS

```bash
kubectl get nodes
```

## Deploy the application

```bash
kubectl apply -f kubernetes/deployment/retailflow-api.yaml
kubectl get deployment retailflow-api -n dev
kubectl get pods -n dev
```

## Check application logs

```bash
kubectl logs -n dev <pod-name>
```

Example:

```bash
kubectl logs -n dev retailflow-api-xxxxxxxxxx-xxxxx
```

## Create the Kubernetes Service

```bash
kubectl apply -f kubernetes/service/retailflow-api.yaml
kubectl get service -n dev
```

## Check Service routing

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

## Test the Service

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

