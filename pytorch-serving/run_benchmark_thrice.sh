echo "Running all benchmarks thrice ..."

echo "Starting tests with n2-96 ..."
echo "TestCase 1: Testing on n2-96 machine with http and cache-dir on disk"
echo  "First run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-boot.yaml serving_on_c4_http1_cachedir_disk1
echo "Second run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-boot.yaml serving_on_c4_http1_cachedir_disk2
echo "Third run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-boot.yaml serving_on_c4_http1_cachedir_disk3
echo " Completed Testcase 1!"

echo "TestCase 2: Testing on n2-96 machine with http and cache-dir on memory"
echo  "First run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-memory.yaml serving_on_c4_http1_cachedir_memory1
echo "Second run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-memory.yaml serving_on_c4_http1_cachedir_memory2
echo "Third run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/http-with-cache-on-memory.yaml serving_on_c4_http1_cachedir_memory3
echo " Completed Testcase 2!"

echo "TestCase 3: Testing on n2-96 machine with grpc and cache-dir on disk"
echo  "First run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-boot.yaml serving_on_c4_grpc_cachedir_disk1
echo "Second run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-boot.yaml serving_on_c4_grpc_cachedir_disk2
echo "Third run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-boot.yaml serving_on_c4_grpc_cachedir_disk3
echo " Completed Testcase 3!"

echo "TestCase 4: Testing on n2-96 machine with grpc and cache-dir on memory"
echo  "First run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-memory.yaml serving_on_c4_grpc_cachedir_memory1
echo "Second run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-memory.yaml serving_on_c4_grpc_cachedir_memory2
echo "Third run..."
bash starter.sh anushkadhn-c4-cluster-useast5b us-east5-b gcs-fuse-test pod-for-c4/grpc-with-cache-on-memory.yaml serving_on_c4_grpc_cachedir_memory3
echo " Completed Testcase 4!"

