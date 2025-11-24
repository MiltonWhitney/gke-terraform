### Responsibilities & Achievements:

Developed and containerized a RESTful Flask API with health and info endpoints.

Built a Docker image and pushed it to Google Artifact Registry.

Provisioned a single-node GKE cluster using Terraform and enabled API and billing integration.

Deployed the API to GKE with Kubernetes manifests and exposed it via a LoadBalancer service.

Implemented optional autoscaling to handle variable traffic loads.

Created a Helm chart for reproducible deployments and version-controlled application management.

Documented all processes in a comprehensive README, including local testing, GCP deployment, Helm chart usage, and useful CLI commands for maintenance and troubleshooting.

### Impact:

Achieved a fully functional, cloud-hosted API deployment pipeline that demonstrates expertise in cloud-native application delivery, infrastructure as code, and DevOps practices.

Created a reusable, production-ready template for deploying containerized applications on GKE, suitable for portfolio and interview demonstrations.



### This project demonstrates:

* Cloud-native development & containerization
* Infrastructure-as-Code concepts
* Kubernetes deployment strategies
* GKE LoadBalancer networking
* Helm templating
* Artifact Registry usage
* Real-world API deployment patterns

 confidently discuss:

* Pods, Deployments, Services
* Load balancing & autoscaling
* CI/CD workflows
* Image registries
* Packaging apps with Helm
* Cloud networking fundamentals

---
### 📦 Architecture Overview

          +------------------+
          |   Flask API      |
          |  (Python/Gunicorn|
          +--------+---------+
                   |
                   v
        +------------------------+
        |        Docker          |
        | Local container build  |
        +-----------+------------+
                    |
                    v
     +----------------------------------+
     | Google Artifact Registry (GAR)   |
     | us-central1-docker.pkg.dev       |
     +---------------+------------------+
                     |
                     v
           +-------------------+
           |     GKE Cluster   |
           | Single node pool  |
           +---------+---------+
                     |
             LoadBalancer Service
                     |
                     v
          Public URL (External IP)


### 📘 Table of Contents

Overview

Architecture

Prerequisites

Terraform — Build the GKE Cluster

Step 1 — Build & Test Flask API

Step 2 — Push Image to Artifact Registry

Step 3 — Deploy to GKE

Step 4 — Helm Deployment

Common Commands

Project Structure

Next Steps

📌 Overview

This project builds a Flask REST API, containerizes it using Docker, stores images in Google Artifact Registry, and deploys it to a GKE Kubernetes cluster created using Terraform.
The app is then packaged and deployed using a Helm chart.


🏗 Architecture
Terraform → GKE Cluster  
Docker → Build Flask API Image  
Artifact Registry → Store Images  
GKE Deployment → Deploy API  
Service → LoadBalancer Public Access  
Helm → Manage K8s Deployment  

🛠 Prerequisites

GCP project with billing enabled

gcloud CLI installed

kubectl installed

Docker installed (inside WSL2 Ubuntu recommended)

Terraform installed

Helm installed

### Step 0
🌍 Terraform — Build the GKE Cluster
Initialize Terraform
terraform init

Validate configuration
terraform validate

Apply Terraform plan
terraform apply


Enter your project ID when prompted.

Once complete, authenticate kubectl:
gcloud container clusters get-credentials single-node-cluster \
  --zone us-central1-a \
  --project <PROJECT_ID>

Verify cluster is reachable:
kubectl get nodes

###
Step 1 — Build & Test Docker Image Locally
Build the Docker image
docker build -t flask-api .

Test locally
docker run -p 8080:8080 flask-api

Verify it works:

http://localhost:8080/health

### Step 2 — Push Image to Google Artifact Registry
Tag image for Artifact Registry
docker tag flask-api us-central1-docker.pkg.dev/<PROJECT_ID>/<REPO>/flask-api:latest

Authenticate Docker to GAR

Inside WSL Ubuntu (where Docker is installed):

gcloud auth configure-docker us-central1-docker.pkg.dev

Push the image
docker push us-central1-docker.pkg.dev/<PROJECT_ID>/<REPO>/flask-api:latest

### Step 3 — Deploy to GKE (YAML manifests)
Apply Deployment
kubectl apply -f k8s/deployment.yaml

Apply Service (LoadBalancer)
kubectl apply -f k8s/service.yaml

Retrieve External IP
kubectl get svc flask-api-lb


Access the API:

http://<EXTERNAL_IP>/health


💡 Note: GKE Load Balancers incur small costs, but your cluster is a single-node setup eligible for free-tier credits.

### Step 4 — Create and Deploy Helm Chart
Create a new Helm chart
helm create flask-api-chart

Modify the following:

values.yaml

templates/deployment.yaml

Remove or update Helm test files that reference missing values

Ensure your image values match:

image:
  repository: us-central1-docker.pkg.dev/<PROJECT_ID>/<REPO>/flask-api
  tag: "latest"
  pullPolicy: Always

Install the Helm release
helm install flask-api ./flask-api-chart


If you deployed plain YAML earlier, remove them first:

kubectl delete deployment flask-api
kubectl delete service flask-api-lb

### 💻 Working Inside WSL (Ubuntu) Container
Install WSL Ubuntu
wsl --install
wsl -d Ubuntu
wsl --shutdown
wsl -l -v

### Notes

Docker Desktop runs Linux containers.

Docker CLI inside Ubuntu can build and push containers.

Use WSL for everything involving Docker or gcloud authentication.

### 🛠 Useful Commands Reference
Docker
docker ps
docker images
docker build -t flask-api .
docker run -p 8080:8080 flask-api
docker tag <src> <dest>
docker push <dest>

Kubernetes (kubectl)
kubectl get nodes
kubectl get pods
kubectl get svc
kubectl describe pod <pod>
kubectl logs <pod>
kubectl delete pod <pod>

GCloud (GKE)
gcloud config set project <PROJECT_ID>
gcloud container clusters list
gcloud container clusters get-credentials <CLUSTER_NAME> --region <REGION>

Helm
helm create flask-api-chart
helm install flask-api ./flask-api-chart
helm upgrade flask-api ./flask-api-chart
helm uninstall flask-api

🧹 Cleanup (Avoid Charges)

Delete Helm release:

helm uninstall flask-api


Delete underlying manifests:

kubectl delete deployment flask-api
kubectl delete service flask-api-lb


Optional: delete GKE cluster:

gcloud container clusters delete <CLUSTER_NAME> --region <REGION>

