# The full launch command
sudo unshare \
  --user \
  --map-root-user \
  --pid \
  --fork \
  --mount \
  --uts \
  --ipc \
  --net \
  bash -c "
    # Join our cgroup before exec-ing into the container
    echo \$\$ > /sys/fs/cgroup/nsbox/cgroup.procs
    export CROOT=$CROOT
    exec /tmp/container-init.sh
  "
