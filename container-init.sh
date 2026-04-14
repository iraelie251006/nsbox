cat > /tmp/container-init.sh << 'EOF'
#!/bin/bash
# This runs inside all the new namespaces, as PID 1

# Set our hostname
hostname nsbox

# Mount essential virtual filesystems inside the new root
mount -t proc proc "$CROOT/proc"
mount -t sysfs sysfs "$CROOT/sys"
mount -t devtmpfs devtmpfs "$CROOT/dev" 2>/dev/null || \
    mount --bind /dev "$CROOT/dev"

# Set up DNS so the container can resolve names
mkdir -p "$CROOT/etc"
cp /etc/resolv.conf "$CROOT/etc/resolv.conf"

# Change root to the Alpine filesystem
exec chroot "$CROOT" /bin/sh
EOF
chmod +x /tmp/container-init.sh
