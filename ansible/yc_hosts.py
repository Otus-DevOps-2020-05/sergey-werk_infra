#!/usr/bin/env python3
"""
Reads output of `yc compute instance list --format json`.
Prints hosts public ip addresses in `ansible` inventory format.

Output format:
{
    "all": [
        "1.2.3.4",
        "1.2.3.5"
    ],
    "_meta": {
        "hostvars": {}
    }
}
"""
import sys
import json
import fileinput

def hostvars(host):
    name = host['name']
    ip_addr = None

    for iface in host['network_interfaces']:
        try:
            ip_addr = iface['primary_v4_address']['one_to_one_nat']['address']
            break
        except KeyError:
            continue

    return {'name': name, 'ip_addr': ip_addr}


data = json.load(sys.stdin)
hosts = [ hostvars(x) for x in data]

ip_list = [ x['ip_addr'] for x in hosts]

output = { 'all': {'hosts': ip_list },
            '_meta': {  # ansible magic
                "hostvars": {}
                }
            }

print(json.dumps(output, indent=4, sort_keys=False))
