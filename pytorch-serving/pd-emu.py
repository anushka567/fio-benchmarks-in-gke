import os
import time
import torch
import argparse

MODEL_DIR = "/data/llama2/llama2-70b-hf"

hf_weights_files = ['pytorch_model-00001-of-00015.bin', 'pytorch_model-00002-of-00015.bin', 'pytorch_model-00003-of-00015.bin', 'pytorch_model-00004-of-00015.bin', 'pytorch_model-00005-of-00015.bin', 'pytorch_model-00006-of-00015.bin', 'pytorch_model-00007-of-00015.bin', 'pytorch_model-00008-of-00015.bin', 'pytorch_model-00009-of-00015.bin', 'pytorch_model-00010-of-00015.bin', 'pytorch_model-00011-of-00015.bin', 'pytorch_model-00012-of-00015.bin', 'pytorch_model-00013-of-00015.bin', 'pytorch_model-00014-of-00015.bin', 'pytorch_model-00015-of-00015.bin']

very_beginning = time.time()
print(f"Starting workload at {time.time()}")

for hf_weight_file in hf_weights_files:
  local_file = os.path.join(MODEL_DIR, hf_weight_file)

  with open(local_file, 'rb') as file2:
    state = torch.load(file2, map_location="cpu")
    del state
    torch.cuda.empty_cache()
    print(f"Finished file {hf_weight_file} at {time.time()}")

very_end = time.time()
print(f"Ending workload at {time.time()}")

print(f"Emulator workflow took {very_end - very_beginning}")
time.sleep(5)