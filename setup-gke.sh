
#!/bin/bash

# Create a project and set GKE_PROJECT to the project id:
# See https://console.cloud.google.com/projectselector2/home/dashboard

# Set parameters
export GKE_PROJECT=cr-gcp-devsecops-353409
export GKE_REGION=europe-west3
export GKE_ZONE=europe-west3-a
export GKE_CLUSTER=onlineboutique
export GKE_SERVICE_ACCOUNT=github-deployment

# Create a GKE cluster
gcloud container clusters create onlineboutique \
    --project=$PROJECT_ID --zone=$GKE_ZONE \
    --machine-type=e2-standard-2 --num-nodes=4

# Configure kubctl
gcloud container clusters get-credentials $GKE_CLUSTER

# enable API
gcloud services enable \
	containerregistry.googleapis.com \
	container.googleapis.com \
  artifactregistry.googleapis.com

# Create repository
gcloud artifacts repositories create $GKE_PROJECT \
   --repository-format=docker \
   --location=$GKE_REGION \
   --description="Docker repository"

# Create a service account
gcloud iam service-accounts create $GKE_SERVICE_ACCOUNT \
    --display-name "GitHub Deployment" \
    --description "Used to deploy from GitHub Actions to GKE"

# Get mail of service account
gcloud iam service-accounts list

GKE_SVC_MAIL="$GKE_SERVICE_ACCOUNT@$GKE_PROJECT.iam.gserviceaccount.com"

# Add 'container.clusterAdmin' role:
gcloud projects add-iam-policy-binding $GKE_PROJECT \
  --member=serviceAccount:$GKE_SVC_MAIL \
  --role=roles/container.clusterAdmin 

# Add 'artifactregistry.admin' role:
gcloud projects add-iam-policy-binding $GKE_PROJECT \
  --member=serviceAccount:$GKE_SVC_MAIL \
  --role=roles/artifactregistry.admin

# Download JSON
gcloud iam service-accounts keys create key.json --iam-account=$GKE_SVC_MAIL
