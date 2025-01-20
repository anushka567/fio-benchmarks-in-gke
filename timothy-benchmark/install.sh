apt-get update
apt-get install -y libaio-dev gcc make git time wget

git clone -b fio-3.36 https://github.com/axboe/fio.git
cd fio
sed -i 's/define \+FIO_IO_U_PLAT_GROUP_NR \+\([0-9]\+\)/define FIO_IO_U_PLAT_GROUP_NR 32/g' stat.h
./configure && make && make install
cd ..

fio --version
echo "first run"

fio_script=$1
fio_output=$2
cd /tmp

chmod +x $fio_script
${fio_script} > $fio_output

echo "done"
