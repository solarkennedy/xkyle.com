---
title: "Using Per-Instance-Type Kernels in a Single AWS EC2 AMI"
date: 2023-09-21T00:00:00-00:00
---

Sometimes it is uself to have an EC2 Machine Image (AMI) change its behavior depending on its runtime environment.
This adds complexity to the AMI, but reduces the complexity of having to maintain `N` AMIs with `N` behaviors.

One of the hardest things about an AMI to change at runtime is the Linux kernel.
By the time you are acutally running, the Linux kernel is there, and it is too late to upgrade or change.
Except maybe using [`kexec`](https://linux.die.net/man/8/kexec).

But here is how I made an AMI pick different kernels depending on its booted [Instance Type](https://aws.amazon.com/ec2/instance-types/) in AWS.

## SMBIOS

[System Management BIOS](https://en.wikipedia.org/wiki/System_Management_BIOS) (SMBIOS) is standard for placing hardware-specific descriptions of things in the BIOS of an x86 computer.
Luckily for us, AWS populates the SMBIOS datastructures with helpful hints about what hardware it is running on.

You can query them directly from Linux:

```
$ sudo dmidecode -t system
# dmidecode 3.3
Getting SMBIOS data from sysfs.
SMBIOS 2.7 present.

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Amazon EC2
	Product Name: r5.2xlarge
...
```

`dmidecode` interprets the coming from the [Desktop Management Interface](https://en.wikipedia.org/wiki/Desktop_Management_Interface) which is reporting the SMBIOS data to you.

The GRUB bootloader can also fetch this data, but at a more raw level using the [`smbios`](https://www.gnu.org/software/grub/manual/grub/html_node/smbios.html) command:

```
grub> smbios --type 1 --get-string 4
Amazon EC2
grub> smbios --type 1 --get-string 5
r5.2xlarge
```

For the purposes of choosing a different Linux Kernel depending on the Instance Type, we want that second piece of data.

The "`5`" here really means an offset of `0x05h` of the [struct](https://en.wikipedia.org/wiki/System_Management_BIOS#Structure_types).
And `--get-string` tells GRUB to interpret it as a classic null-terminated string per the [spec](https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.2.0.pdf).

## Making GRUB "Instance Family Aware"

Once we know what strings we want, we can extract them, in grub, at grub start time.
Even better though, we can use the [`regexp`](https://www.gnu.org/software/grub/manual/grub/html_node/regexp.html) functionality to simplify this string to only the first part before the `.`: the instance family:

```
insmod smbios
smbios --type 1 --get-string 5 --set instance_type
regexp --set=1:instance_family '([^.]*)\..*' "${instance_type}"
```

Now that we have a grub variable for `$instance_family`, we can use normal grub [syntax](https://www.gnu.org/software/grub/manual/grub/html_node/Shell_002dlike-scripting.html) to do conditionals:


```
if [ "$instance_family" == "r5" ] ; then
  menuentry 'Special R5 Kernel!!!' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.15' {
        ...
        echo   'Loading Linux ... for R5s!'
        linux  /boot/vmlinuz-...
        initrd /boot/microcode.cpio /boot/initrd.img
  }
fi
```

Of course with the power of `$instance_family` at your fingertips, you are not limited to just making a `menuentry`.
In practice the easiest thing to do is simply set a different default kernel:

```
if [ "$instance_family" == "r5" ] ; then
  # We explicitly ask them to use the latest kernel in the 0th slot
  set default=0
else
  # Older instances need to use the older kernel
  set default=1 
fi
```

But you could also change kernel parameters or any other crazy GRUB setting with this ability.

I highly recommend using the AWS [EC2 Serial Console](https://aws.amazon.com/blogs/compute/using-ec2-serial-console-to-access-the-grub-menu-and-recover-from-boot-failures/) feature for interactivly working with the grub menu.

This only works if GRUB is configured to output to the serial console:

```
$ cat /etc/default/grub.d/60-grub-serial.cfg 
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=9600 --unit=0"
```

Actually injecting this GRUB configuration with your specific Linux distribution is left as an exercise to the reader.
But with Ubuntu, one can inject this config _before_ the `menuentry` settings by creating a script in `/etc/grub.d/`.
The scripts in this directory are all compiled together with `update-grub`:

```
$ cat /etc/grub.d/09_instance_type
#!/bin/sh
cat << 'EOF'
insmod smbios
smbios --type 1 --get-string 5 --set instance_type
regexp --set=1:instance_family '([^.]*)\..*' "${instance_type}"

if [ "$instance_family" == "r5" ] ; then
  # We explicitly ask them to use the latest kernel in the 0th slot
  set default=0
else
  # Older instances need to use the older kernel
  set default=1 
fi
EOF
```

And then the `update-grub` command runs these commands for you and compiles the config to `/boot/grub/grub.cfg`.
You can edit the script, run `update-grub`, then inspect `/boot/grub/grub.cfg` until the whole config looks sane.
Of course, you have to reboot and use the serial console to really check your results.
You can read more about how `update-grub` works on Ubuntu in their [Grub2 docs](https://help.ubuntu.com/community/Grub2/Setup#Configuring_GRUB_2).

For troubleshooting, it is also useful to have a `GRUB_TIMEOUT=30` to give you 30 seconds to work in the menu.
You can read more about accessing the GRUB menu on EC2 at their [official docs](https://aws.amazon.com/blogs/compute/using-ec2-serial-console-to-access-the-grub-menu-and-recover-from-boot-failures/).