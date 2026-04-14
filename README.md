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
