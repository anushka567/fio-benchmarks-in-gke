# fio-benchmarks-in-gke
This repository contains scripts and configurations to run fio benchmarks against GKE to evaluate performance on different machines.

## Prerequisites

* **Active GKE Cluster:**  You'll need an active GKE cluster with at least one node. For TPU testing, ensure your VPC network ([steps](https://cloud.google.com/vpc/docs/create-modify-vpc-networks) to create VPC network) is configured with 8896 MTU, regional dynamic routing, and legacy best path selection.
    *  **Cluster Creation:** Follow the guide for creating a zonal cluster with workload identity and gke csi driver enabled and set cluster networking to VPC network created above: [link](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster)
    *  **Node Pool Creation:**  Create a node pool with a recommended boot disk size of 100GB and allow full access to all cloud APIs.  [link](https://cloud.google.com/kubernetes-engine/docs/how-to/node-pools)
* **Cloud Storage Bucket:** Create a bucket in the same region as your cluster for testing with gRPC:
   ```bash
   gcloud storage buckets create gs://BUCKET_NAME --location=BUCKET_LOCATION 


## Benchmarking Steps

1. **Configure `pod.yaml`:**

   * Edit `pod.yaml` (found in the repository) to specify:
      * `nodePool`: The node pool where your pod will run.
      * `hostNetwork`: Set to `true` or `false` (`false` is recommended).
      * `bucketName`: The name of your Cloud Storage bucket.
      * `clientProtocol`: Choose `grpc` or `http1`(These values are configured under `mountOptions` within `VolumeAttributes` for the GKE CSI driver.)

   * Alternatively, use your own pod manifest by placing it in the `pod-manifests` directory. Ensure the pod name is `gcsfuse-test` and the application container name is `ubuntu`.

2. **Configure the fio Job File:**

   * Place your fio job file in the `job_files` directory.
   * Ensure the directory for the fio job is set to `${MOUNT_POINT}/directoryname`.
   * Note that : the directories specified in the job file must be created in the GCS bucket beforehand.
   * For easy identification, name your fio job files using the format `filesize<fs>_blocksize<bs>` (e.g., `1g-1m.fio`).
   * Example job files are provided in the `job_files` directory (e.g., `1g-1m.fio`, `gcsfuse-ext-benchmarks.fio`).

3. **Configure the fio Output File:**

   * Name your fio output file in the format `hostnetwork_<enabled/disabled>_bootdisksize_<val>_clientprotocol_<grpc/http>.json` to easily identify test configurations.

4. Run the Benchmark:
   * ```bash
     bash starter.sh <cluster_name> <location> <project> <pod.yaml> <fio_job_file.fio> <fio_result_file.json>

## Output
* Note that this script will perform 3 runs of the same fio jobset and the output is the throughput in GiBps
* Raw fio output is stored in the results/ directory, with filenames like run1_{fio_result_file.json}, run2_{fio_result_file.json}, and run3_{fio_result_file.json}.
Example output: 
```
Results from the first run...
Throughput(GiBps) - filesize128K_blocksize128K : 0.95551554299891
Throughput(GiBps) - filesize256K_blocksize128K : 1.9037225600332022
Throughput(GiBps) - filesize1M_blocksize1M : 5.781277873553336
Results from the second run...
Throughput(GiBps) - filesize128K_blocksize128K : 0.95551554299891
Throughput(GiBps) - filesize256K_blocksize128K : 1.9037225600332022
Throughput(GiBps) - filesize1M_blocksize1M : 5.781277873553336
Results from the third run...
Throughput(GiBps) - filesize128K_blocksize128K : 0.95551554299891
Throughput(GiBps) - filesize256K_blocksize128K : 1.9037225600332022
Throughput(GiBps) - filesize1M_blocksize1M : 5.781277873553336

```





