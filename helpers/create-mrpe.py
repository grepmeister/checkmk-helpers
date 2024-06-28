#!/usr/bin/env python3


# create mrpe config for cluster nodes to check each other via icmp

my_own_ips = []

# read device specific config
with open("/etc/cma/device.conf", "r") as f:
    exec(f.read())

# get a list of my ips
for key, value in ip["adv"]["interfaces"].items():
    my_own_ips.append(value["ipaddress"])

# read the cluster config
with open("/etc/cma/cma.conf", "r") as f:
    exec(f.read())


def escape(item):
    return item.replace(" ", "%20")


for iface in cluster["ccm_ifs"]:

    # node1 > node2
    src_ip = cluster["node1_attrs"]["interfaces"][iface]
    dst_ip = cluster["node2_attrs"]["interfaces"][iface]

    if src_ip in my_own_ips:
        title = escape(f"icmp on ring {iface}")
        print(f"{title} /usr/local/bin/check_icmp -s {src_ip} -H {dst_ip}")

    # node2 > node1
    src_ip = cluster["node2_attrs"]["interfaces"][iface]
    dst_ip = cluster["node1_attrs"]["interfaces"][iface]

    if src_ip in my_own_ips:
        title = escape(f"icmp on ring {iface}")
        print(f"{title} /usr/local/bin/check_icmp -s {src_ip} -H {dst_ip}")
