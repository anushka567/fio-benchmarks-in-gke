#!/bin/bash
# Make sure that the podname is gcsfuse-test and the application container is named ubuntu.
# It is advised to name the fio jobs in the format filesize<filesize>_blocksize<blocksize> for easier interpretation.
# Move you fio job file to job_files before running the script.
# Add nodepool, hostnetwork config,client protocol ,bucket name in pod-manifests/pod.yaml.Alternatively, move your pod.yaml to pod-manifests/
# and pass it as an argument to this script.
# Run the script with bash starter.sh <cluster_name> <location> <project> <pod.yaml> <fio_job_file.fio> <fio_result_file>

cluster_name=$1
location=$2
project=$3
podyaml=$4
fio_job_file=$5
fio_result_file=$6 # Make sure to name this in format hostnetwork_<enabled/disabled>_bootdisksize_<val>_clientprotocol_<grpc/http>.json for identifying test runs.


gcloud container clusters get-credentials $cluster_name \
    --location=$location \
    --project=$project


kubectl apply -f ./pod-manifests/${podyaml}

# Wait for the pod to be running
kubectl wait --for=condition=ready pod/gcsfuse-test --timeout=120s

# Copy the install script and the fio job file.
kubectl cp ./install.sh gcsfuse-test:/tmp/ -c ubuntu
kubectl cp ./job_files/${fio_job_file} gcsfuse-test:/tmp/ -c ubuntu


# Get the gcsfuse sidecar logs for debugging purpose.
kubectl logs gcsfuse-test -c gke-gcsfuse-sidecar

# Execute the script
kubectl exec --stdin --tty gcsfuse-test -c ubuntu -- /bin/bash -c "chmod +x /tmp/install.sh && /tmp/install.sh /tmp/'$fio_job_file' '$fio_result_file' "

kubectl cp gcsfuse-test:/tmp/run1_${fio_result_file}  ./results/run1_${fio_result_file} -c ubuntu
kubectl cp gcsfuse-test:/tmp/run2_${fio_result_file}  ./results/run2_${fio_result_file} -c ubuntu
kubectl cp gcsfuse-test:/tmp/run3_${fio_result_file}  ./results/run3_${fio_result_file} -c ubuntu

# Delete the pod.
kubectl delete pods gcsfuse-test

# Parsing the fio output to extact the throughput .
echo "Results from the first run..."
python3 parse_fio_output.py ./results/run1_${fio_result_file} | grep  Throughput
echo "Results from the second run..."
python3 parse_fio_output.py ./results/run2_${fio_result_file} | grep  Throughput
echo "Results from the third run..."
python3 parse_fio_output.py ./results/run3_${fio_result_file} | grep  Throughput