import os, redis, subprocess

r = redis.Redis(
host='redis-master.redis.svc.cluster.local',
port=6379)
node = os.getenv("NODE_NAME")
try:
    numa_output = subprocess.check_output(['numalign'], shell=True)
    if 'true' in numa_output.decode('utf-8'):
        if not r.exists('aligned_count'):
            r.set('aligned_count', 0)
        r.incr('aligned_count')
        if not r.exists(node):
            r.set(node, 0)
        r.incr(node)
except Exception as e:
    if not r.exists('unaligned_count'):
        r.set('unaligned_count', 0)
    r.incr('unaligned_count')
