# On the HOST (in another terminal):

CPID=$(cat /sys/fs/cgroup/nsbox/cgroup.procs | head -1)

# Create veth pair
sudo ip link add veth-host type veth peer name veth-container

# Move one end into the container's net namespace
sudo ip link set veth-container netns $CPID

# Configure host end
sudo ip addr add 10.42.0.1/24 dev veth-host
sudo ip link set veth-host up

# Configure container end (run inside container net ns)
sudo nsenter --net=/proc/$CPID/ns/net bash -c "
  ip addr add 10.42.0.2/24 dev veth-container
  ip link set veth-container up
  ip link set lo up
  ip route add default via 10.42.0.1
"

# Enable NAT on host so container can reach internet
sudo iptables -t nat -A POSTROUTING -s 10.42.0.0/24 -j MASQUERADE
sudo sysctl -w net.ipv4.ip_forward=1
