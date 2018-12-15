#!/system/bin/sh 

sleep 25;

# Applying RedFlare settings 

# Setup Schedutil Governor
    echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo 200 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
    echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
    echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq

    echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor    
    echo 200 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
    echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
    echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq

# Stune configuration
    echo 30 > /sys/module/cpu_input_boost/parameters/dynamic_stune_boost

# Disable Boost_No_Override
    echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override
    echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override

# Set default schedTune value for foreground/top-app
    echo 1 > /dev/stune/foreground/schedtune.prefer_idle
    echo 1 > /dev/stune/top-app/schedtune.boost
    echo 1 > /dev/stune/top-app/schedtune.prefer_idle

# Enable PEWQ
    echo Y > /sys/module/workqueue/parameters/power_efficient

# Adjust SCHED Features
    echo NO_EAS_USE_NEED_IDLE > /sys/kernel/debug/sched_features
    echo TTWU_QUEUE > /sys/kernel/debug/sched_features

# Disable CAF task placement for Big Cores
    echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks

# Disable Autogrouping
    echo 0 > /proc/sys/kernel/sched_autogroup_enabled

# Setup EAS cpusets values for better load balancing
    echo 0-7 > /dev/cpuset/top-app/cpus
    # Since we are not using core rotator, lets load balance
    echo 0-3,6-7 > /dev/cpuset/foreground/cpus
    echo 0-3 > /dev/cpuset/background/cpus
    echo 0-3  > /dev/cpuset/system-background/cpus