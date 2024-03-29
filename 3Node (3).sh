############################################################
# Topology
#  _______   50mbit, 5ms     _______                _______
# |       |-----------------|       |              |       |
# |  h1   |                 |  h2   |--------------|  h3   |
# |_______|-----------------|_______|              |_______|
#             50mbit, 10ms             10mbit, 2ms       
############################################################

#!/bin/sh

# Create two network namespaces: h1 h2 h3
ip netns add h1
ip netns add h2
ip netns add h3

# Create two virtual ethernet (veth) pairs between h1,s1 and h2
ip link add eth1a netns h1 type veth peer name eth2a netns h2
ip link add eth1b netns h1 type veth peer name eth2b netns h2
ip link add eth3a netns h2 type veth peer name eth3b netns h3

# Assign IP address to each interface on h1
ip netns exec h1 ip address add 10.0.0.1/24 dev eth1a
ip netns exec h1 ip address add 192.168.0.1/24 dev eth1b

# Assign IP address to each interface on h2
ip netns exec h2 ip address add 10.0.0.2/24 dev eth2a
ip netns exec h2 ip address add 192.168.0.2/24 dev eth2b
ip netns exec h2 ip address add 10.0.1.1/24 dev eth3a

# Assign IP address to each interface on h3
ip netns exec h3 ip address add 10.0.1.2/24 dev eth3b

# Set the data rate and delay on the veth devices at h1
ip netns exec h1 tc qdisc add dev eth1a root netem delay 5ms rate 50mbit
ip netns exec h1 tc qdisc add dev eth1b root netem delay 10ms rate 50mbit

# Set the data rate and delay on the veth devices at h2
ip netns exec h2 tc qdisc add dev eth2a root netem delay 5ms rate 50mbit
ip netns exec h2 tc qdisc add dev eth2b root netem delay 10ms rate 50mbit
ip netns exec h2 tc qdisc add dev eth3a root netem delay 2ms rate 10mbit
# Set the data rate and delay on the veth devices at h3
ip netns exec h3 tc qdisc add dev eth3b root netem delay 2ms rate 10mbit

# Turn ON all ethernet devices
ip -n h1 link set lo up
ip -n h2 link set lo up
ip -n h3 link set lo up
ip -n h1 link set eth1a up
ip -n h1 link set eth1b up
ip -n h2 link set eth2a up
ip -n h2 link set eth2b up
ip -n h2 link set eth3a up
ip -n h3 link set eth3b up

# Enable IP forwarding
ip netns exec h2 sysctl -w net.ipv4.ip_forward=1

# Create two routing tables for two interace in h1
ip netns exec h1 ip rule add from 10.0.0.1 table 1
ip netns exec h1 ip rule add from 192.168.0.1 table 2

# Configure the two routing tables
ip netns exec h1 ip route add default via 10.0.0.2 dev eth1a table 1
ip netns exec h1 ip route add 10.0.0.0/24 dev eth1a scope link table 1

ip netns exec h1 ip route add default via 192.168.0.2 dev eth1b table 2
ip netns exec h1 ip route add 192.168.0.0/24 dev eth1b scope link table 2

# Global Default route for h1
ip netns exec h1 ip route add default scope global nexthop via 10.0.0.2 dev eth1a

# Default route for h3
ip netns exec h3 ip route add default via 10.0.1.1 dev eth3b

