# nsbox(NameSpace Box)

A minimal container runtime built from scratch using Linux namespaces and cgroups (no Docker).

## Prerequisites

```bash
# Ubuntu / Debian
sudo apt-get install -y cgroup-tools debootstrap util-linux

# Fedora / RHEL
sudo dnf install -y libcgroup-tools util-linux

# Check kernel has user namespaces enabled (should output 1)
cat /proc/sys/kernel/unprivileged_userns_clone   # Debian/Ubuntu
# Fedora: always enabled

```

## Step 1: Build a minimal root filesystem

We need something for the container's `/`. We'll use Alpine Linux's minirootfs 5 MB, self-contained, no package manager needed beyond `apk`.

```bash
# The rootfs has no kernel, it's just a userspace filesystem tree. The kernel we're using is the host kernel.

File: rootfs.sh
```

## Step 2: Create and configure the cgroup

We'll use cgroups v2 here. First verify you're on v2

```bash
stat -fc %T /sys/fs/cgroup

# output: cgroup2fs  ← good, you're on v2
# output: tmpfs      ← you're on v1
```

If on cgroup v2 (the common case on modern distros):

```bash
chmod +x cgroupV2.sh

./cgroupV2.sh
```

If on cgroup v1 (older kernels), use `cgcreate`:

```bash
chmod +x cgroupV1.sh

./cgroupV1.sh
```

## Step 3: Write the container entry script

This script runs inside the new namespaces and sets up the environment before handing control to a shell.

```bash
chmod +x container-init.sh

./container-init.sh
```

## Step 4: Launch the container

Now we combine everything: `unshare` creates the namespaces, we attach to the cgroup, then the init script runs inside.

```bash
chmod +x launch.sh

./launch.sh
```

### You should land at an Alpine shell:

```bash
/ #
```

## verify the isolation is working:

```bash
# Inside the container:

# PID isolation, we are PID 1
echo "My PID: $$" # My PID: 1
ps aux  # shows only our shell processes

# UTS isolation, our own hostname
hostname # nsbox

# Filesystem isolation, we see Alpine, not the host
ls / #  Alpine rootfs, no host directories
cat /etc/alpine-release # 3.19.1

# Network isolation, only loopback
ip link show # lo only, no host eth0

# Can't see host processes
cat /proc/1/cmdline # our shell, not systemd
```

## Step 5: Verify the cgroup limits are enforced

```bash
chmod +x cgroup_limits.sh

./cgroup_limits.sh
```

To test the memory limit, run this inside the container:

```bash
# Inside container: try to allocate 300MB (should be killed at 256MB)
dd if=/dev/zero bs=1M count=300 | cat > /dev/null
# Killed  (OOM kill within the cgroup, host unaffected)
```

## Step 6: basic networking

The container has its own net namespace but only a loopback. Let's wire it to the host with a veth pair:

```bash
chmod +x networking.sh

./networking.sh
```

### verify:
inside the container:
```bash
ping 10.42.0.1  # host reachable
ping 8.8.8.8          # internet reachable (with NAT)
wget -qO- https://ifconfig.me # shows host's IP (via NAT)
```

## step 7: clean up

```bash
# Inside container
exit

# On host: clean up cgroup
sudo rmdir /sys/fs/cgroup/nsbox

# Clean up networking
sudo ip link del veth-host   # also removes veth-container
sudo iptables -t nat -D POSTROUTING -s 10.42.0.0/24 -j MASQUERADE

# Clean up rootfs mounts (if any got stuck)
sudo umount -R "$CROOT/proc" "$CROOT/sys" "$CROOT/dev" 2>/dev/null
```
