# v1 alternative using cgcreate
sudo cgcreate -g memory,cpu,pids:nsbox
sudo cgset -r memory.limit_in_bytes=268435456 nsbox
sudo cgset -r cpu.cfs_period_us=1000000 nsbox
sudo cgset -r cpu.cfs_quota_us=500000 nsbox
sudo cgset -r pids.max=50 nsbox
