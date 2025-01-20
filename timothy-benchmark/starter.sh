#!/bin/bash

cluster_name=$1
location=$2
project=$3
client_protocol=$4
fio_job_script=$5
fio_result_file="${fio_job_script%.*}"


gcloud container clusters get-credentials $cluster_name \
    --location=$location \
    --project=$project

#custom csi driver -

kubectl apply -f ../pod-manifests/pod-for-${client_protocol}.yaml

# Wait for the pod to be running
kubectl wait --for=condition=ready pod/gcsfuse-test --timeout=120s

# Copy the install script
kubectl cp ./install.sh gcsfuse-test:/tmp/ -c ubuntu
kubectl cp ./${fio_job_script} gcsfuse-test:/tmp/ -c ubuntu
kubectl cp ./read.fio gcsfuse-test:/tmp/ -c ubuntu

# Get the logs
kubectl logs gcsfuse-test -c gke-gcsfuse-sidecar

# Execute the script
kubectl exec --stdin --tty gcsfuse-test -c ubuntu -- /bin/bash -c "chmod +x /tmp/install.sh && /tmp/install.sh /tmp/'$fio_job_script'  /tmp/'$fio_result_file'"

kubectl get pods

kubectl cp gcsfuse-test:/tmp/$fio_result_file ./timothy-benchmark/results/$fio_result_file -c ubuntu

kubectl delete pods gcsfuse-test

echo "done"
