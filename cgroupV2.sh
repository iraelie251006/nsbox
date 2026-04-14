sudo bash -c 'echo "+cpu +memory +pids" > /sys/fs/cgroup/cgroup.subtree_control'

sudo mkdir -p /sys/fs/cgroup/mycontainer

sudo bash -c 'echo "256M" > /sys/fs/cgroup/mycontainer/memory.max'
sudo bash -c 'echo "128M" > /sys/fs/cgroup/mycontainer/memory.high'
sudo bash -c 'echo "500000 1000000" > /sys/fs/cgroup/mycontainer/cpu.max'
sudo bash -c 'echo "50" > /sys/fs/cgroup/mycontainer/pids.max'

cat /sys/fs/cgroup/mycontainer/memory.max
cat /sys/fs/cgroup/mycontainer/cpu.max
