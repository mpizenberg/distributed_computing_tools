# fab --parallel -z 50 --skip-bad-hosts --command-timeout=20 --warn-only benchmark_hosts:hosts_file=n7_no_psswd.txt

import string
import fabric
import operator

def get_hosts(hosts_file=None):
    hosts = []
    if hosts_file is not None:
        with open(hosts_file, 'r') as f:
            hosts = map(string.rstrip, f.readlines())
    return hosts

def robust_float(str_float, default):
    try:
        l = str_float.split()
        for s in l:
            try:
                return float(s)
            except:
                pass
        return default
    except:
        return default

def benchmark():
    return fabric.api.run("TIMEFORMAT=\"%U\"; time $(i=0; while (( i < 999999 )); do (( i ++ )); done)")

def benchmark_hosts(hosts_file=None):
    results = {}
    hosts = get_hosts(hosts_file)
    with fabric.api.hide('output'):
        results = fabric.tasks.execute(benchmark, hosts=hosts)
    timings_dict = {k: robust_float(v,100) for k,v in results.items()}
    print(timings_dict)
    timings_sorted = sorted(timings_dict.items(), key=operator.itemgetter(1))
    with open('hosts_perf.txt', 'w') as f:
        for (h,t) in timings_sorted:
            f.write("{} {}\n".format(h,t))
