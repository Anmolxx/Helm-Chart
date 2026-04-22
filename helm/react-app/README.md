# React App Helm Chart

This chart deploys the existing React app as the nginx-served container built from the app Dockerfile.

## Windows prerequisites

Install Minikube and Helm on Windows with winget:

```powershell
winget install -e --id Kubernetes.minikube --accept-package-agreements --accept-source-agreements
winget install -e --id Helm.Helm --accept-package-agreements --accept-source-agreements
```

If winget gives you source prompts, use Chocolatey instead:

```powershell
choco install minikube kubernetes-helm -y
```

## Local setup with kind

Build the image from the `app` directory:

```bash
docker build -f app/Dockerfile -t react-app:local .
```

Load the image into your kind cluster:

```bash
kind load docker-image react-app:local --name react-app-cluster
```

Install the chart into a local namespace:

```bash
helm install react-app ./helm/react-app -n react-app --create-namespace --set image.repository=react-app --set image.tag=local
```

Access the app with port-forward:

```bash
kubectl port-forward svc/react-app 8080:80 -n react-app
```

Then open `http://localhost:8080`.

## Configuration

- `replicaCount`: Number of app pods.
- `image.repository` / `image.tag`: Container image to run.
- `service.type`: `ClusterIP` by default, can be switched to `NodePort`.
- `resources`: CPU and memory requests and limits.