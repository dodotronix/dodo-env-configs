# Dodotronix's enviroment cofigurations

## BOOT (EFISTUB, no bootloader)
The kernel is booted directly by the UEFI firmware. The boot entry lives in the
firmware NVRAM and is managed with `efibootmgr` (assumes the ESP is mounted at `/boot`).

### 1. Find the names of the loaders in /boot
```sh
ls /boot
# vmlinuz-linux          -> kernel (the --loader)
# initramfs-linux.img    -> initramfs
```

### 2. Find the disks and partitions
```sh
lsblk -o NAME,SIZE,FSTYPE,PARTTYPENAME,MOUNTPOINTS
# ESP  = the "EFI System" partition mounted at /boot, e.g. /dev/nvme0n1p1
# root = the partition mounted at /, e.g. /dev/nvme0n1p2
```

### 3. Get the UUID of the root partition
```sh
sudo blkid -s UUID -o value /dev/nvme0n1p2
```

### 4. Create the entry
`--disk` + `--part` point at the ESP (disk and partition number, NOT the root partition).
Paths are relative to the root of the ESP. Inside `--unicode` use backslashes.
```sh
sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 \
    --label "Arch Linux" --loader /vmlinuz-linux \
    --unicode 'root=UUID=<uuid-from-blkid> rw initrd=\initramfs-linux.img'
```
A new entry is put first in the boot order.

### 5. List the entries
```sh
efibootmgr --unicode   # entries + their kernel parameters
```

### 6. Delete an entry
```sh
sudo efibootmgr --bootnum 0003 --delete-bootnum   # 0003 = number from Boot0003*
```

### Change the boot order
```sh
sudo efibootmgr --bootorder 0003,0001
```

## CLAUDE (docker)
`make docker_prepare_claude` installs docker and builds the `claude-code-ubuntu-24.04`
image from `claude/Dockerfile`.

## FIREFOX
Since there is no browser nativly with nvim shortcuts supporting all the privacy
plugins for the mainstream browsers, i use the VimFx for firefox which u
download [here](https://github.com/akhodakivskiy/VimFx/releases)


## TODO
* check and if not already installed -> install firefox, git (set the config name and mail)
* install autojump, yay, zathura, inkscape, deepin screenshot,
