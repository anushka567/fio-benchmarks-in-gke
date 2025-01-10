import json
import sys

def parse_fio_json(filename):
  """
  Parses the JSON output of a fio job and extracts relevant read operation metrics.
  Ignores any non-JSON lines at the beginning of the file.

  Args:
      filename (str): Path to the fio JSON output file (can be relative).

  Returns:
      list: A list of lists, where each inner list contains:
            ["jobname", throughput (bw_bytes), average latency (clat_ns), iops]
  """

  with open(filename, 'r') as f:
    lines = f.readlines()

  # Find the start of the JSON data
  json_start = 0
  for i, line in enumerate(lines):
    if line.startswith('{'):
      json_start = i
      break

  # Load JSON data, ignoring lines before the start
  data = json.loads(''.join(lines[json_start:]))

  results = []
  for job in data['jobs']:
    jobname = job['jobname']
    read_bw_bytes = job['read']['bw_bytes']/ (1024**3)
    read_clat_ns = job['read']['clat_ns']['mean']/ 1000000
    read_iops = job['read']['iops']
    results.append([jobname, read_bw_bytes, read_clat_ns, read_iops])

  return results

if __name__ == "__main__":
  if len(sys.argv) != 2:
    print("Usage: python script_name.py <filename>")
    sys.exit(1)

  filename = sys.argv[1]  # Get filename from command-line argument
  results = parse_fio_json(filename)
  for result in results:
    print(f"Throughput(GiBps) - {result[0]} : {result[1]}")

  for result in results:
    print(f"avg latency(ms) - {result[0]} : {result[1]}")

  for result in results:
    print(f"iops - {result[0]} : {result[1]}")