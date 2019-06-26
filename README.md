# ArcoLinuxD Plasma desktop

### Steps to install
- Install using the latest ArcolinxD ISO - https://arcolinux.info/download
- Follow the steps below.

#### Action 1 : get fastest servers
Ensure you have the fastest Arch Linux servers with the alias

`mirror`

#### Action 2 : update arch and arcoLINUX repo’s
Update first your system to receive the latest updates

`sudo pacman -Syyu`

or use its alias

`update`

This will force a refresh of all package lists and upgrade all Arch and ArcoLinux packages

#### Action 3 : update AUR packages
Then you check if you need to update the packages coming from AUR

`pksyua`

#### Action 4 : Clone git repository
Clone this git repoisitory

`git clone https://github.com/esa1975/arco-plasma`

#### Action 5 : Run install scripts
Change to the arco-plasma directory and run the scripts in numerical order.

`cd arco-plasma`

`sh 000-use-all-cores-makepkg-conf-v3.sh` and so on until complete.

#### Action 6 : Reboot and enjoy!
You should now have a fully installed version of KDE Plasma.
