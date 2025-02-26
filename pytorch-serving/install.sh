apt-get update
apt-get install -y python3


apt install -y  python3.10-venv
python3 -m venv venv

source venv/bin/activate
pip3 install torch torchvision torchaudio

cd tmp
python3 pd-emu.py

echo "Done :)"