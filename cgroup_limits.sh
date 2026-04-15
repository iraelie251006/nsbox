# Get container PID and print it
CPID=$(cat /sys/fs/cgroup/nsbox/cgroup.procs | head -1)
echo "Container host PID: $CPID"

cat /proc/$CPID/cgroup

# set limits for memory and cpu
cat /sys/fs/cgroup/nsbox/memory.max   # 268435456
cat /sys/fs/cgroup/nsbox/cpu.max      # 500000 1000000

# Live stats
cat /sys/fs/cgroup/nsbox/memory.current
cat /sys/fs/cgroup/nsbox/cpu.stat
