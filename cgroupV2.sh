# setup subtree control for cgroup
sudo bash -c 'echo "+cpu +memory +pids" > /sys/fs/cgroup/cgroup.subtree_control'

# create a cgroup
sudo mkdir -p /sys/fs/cgroup/nsbox

sudo bash -c 'echo "256M" > /sys/fs/cgroup/nsbox/memory.max'
sudo bash -c 'echo "128M" > /sys/fs/cgroup/nsbox/memory.high'
sudo bash -c 'echo "500000 1000000" > /sys/fs/cgroup/nsbox/cpu.max'
sudo bash -c 'echo "50" > /sys/fs/cgroup/nsbox/pids.max'

cat /sys/fs/cgroup/nsbox/memory.max
cat /sys/fs/cgroup/nsbox/cpu.max
