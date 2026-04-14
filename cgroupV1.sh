# v1 alternative using cgcreate
sudo cgcreate -g memory,cpu,pids:mycontainer
sudo cgset -r memory.limit_in_bytes=268435456 mycontainer
sudo cgset -r cpu.cfs_period_us=1000000 mycontainer
sudo cgset -r cpu.cfs_quota_us=500000 mycontainer
sudo cgset -r pids.max=50 mycontainer
