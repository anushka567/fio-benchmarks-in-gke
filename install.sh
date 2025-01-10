apt-get update
apt-get install -y libaio-dev gcc make git time wget

git clone -b fio-3.36 https://github.com/axboe/fio.git
cd fio
sed -i 's/define \+FIO_IO_U_PLAT_GROUP_NR \+\([0-9]\+\)/define FIO_IO_U_PLAT_GROUP_NR 32/g' stat.h
./configure && make && make install
cd ..

fio --version
echo "Starting first run..."
MOUNT_POINT=/data fio --alloc-size=1048576 $1 --output-format=json > /tmp/run1_$2
echo "Starting second run..."
MOUNT_POINT=/data fio --alloc-size=1048576 $1 --output-format=json > /tmp/run2_$2
echo "Starting third run..."
MOUNT_POINT=/data fio --alloc-size=1048576 $1 --output-format=json > /tmp/run3_$2

echo "done"
