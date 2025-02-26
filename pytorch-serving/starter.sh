#!/bin/bash
# Make sure that the podname is gcsfuse-test and the application container is named ubuntu.
# It is advised to name the fio jobs in the format filesize<filesize>_blocksize<blocksize> for easier interpretation.
# Move you fio job file to job_files before running the script.
# Add nodepool, hostnetwork config,client protocol ,bucket name in pod-manifests/pod.yaml.Alternatively, move your pod.yaml to pod-manifests/
# and pass it as an argument to this script.
# Run the script with bash starter.sh <cluster_name> <location> <project> <pod.yaml> <fio_job_file.fio> <fio_result_file.json>

cluster_name=$1
location=$2
project=$3
podyaml=$4
instance=$5

echo "Run parameters : \
      cluster: ${cluster_name} \
      location: ${location} \
      project: ${project}\
      pod: ${podyaml}"

gcloud container clusters get-credentials $cluster_name \
    --location=$location \
    --project=$project

# Add necessary permission to gcloud bucket
gcloud storage buckets add-iam-policy-binding gs://anushkadhn-llama2-us-east5 --member principal://iam.googleapis.com/projects/927584127901/locations/global/workloadIdentityPools/gcs-fuse-test.svc.id.goog/subject/ns/default/sa/default --role roles/storage.objectUser

kubectl apply -f ../pod-manifests/${podyaml}

# Wait for the pod to be running
kubectl wait --for=condition=ready pod/gcsfuse-test --timeout=120s

# Copy the install script and the fio job file.
kubectl cp ./install.sh gcsfuse-test:/tmp/ -c ubuntu
kubectl cp ./pd-emu.py gcsfuse-test:/tmp/ -c ubuntu

# Get the gcsfuse sidecar logs for debugging purpose.
kubectl logs gcsfuse-test -c gke-gcsfuse-sidecar

# Execute the script
kubectl exec --stdin --tty gcsfuse-test -c ubuntu -- /bin/bash -c "chmod +x /tmp/install.sh && /tmp/install.sh > /tmp/logs"

kubectl cp gcsfuse-test:/tmp/logs ./results/${instance} -c ubuntu

# Delete the pod.
kubectl delete pods gcsfuse-test