
#!/bin/bash

# Create a project and set GKE_PROJECT to the project id:
# See https://console.cloud.google.com/projectselector2/home/dashboard

# Set the PROJECT_ID environment variable and ensure the Google Kubernetes Engine and Cloud Operations APIs are enabled
PROJECT_ID="cr-gcp-devsecops-353409"
gcloud services enable container.googleapis.com --project ${PROJECT_ID}
gcloud services enable monitoring.googleapis.com \
    cloudtrace.googleapis.com \
    clouddebugger.googleapis.com \
    cloudprofiler.googleapis.com \
    --project ${PROJECT_ID}

# Create a GKE cluster
REGION=us-central1
gcloud container clusters create-auto onlineboutique \
    --project=${PROJECT_ID} --region=${REGION}