https://pranavk-official.gitlab.io/posts/post-2/

Install Cloudflare on Arch

To install Cloudflare-related tools on Arch Linux, the method depends on the specific product you need.

For **Cloudflare Tunnel** (`cloudflared`), install it from the Arch User Repository (AUR). You can use an AUR helper like `yay` or `paru`:
```bash
yay -S cloudflared-bin
```
Alternatively, without an AUR helper:
```bash
git clone https://aur.archlinux.org/cloudflared.git
cd cloudflared
makepkg -si
```
After installation, authenticate the machine by running `cloudflared tunnel login`, which opens a browser window to log in to your Cloudflare account and select a hostname 

For **Cloudflare WARP** (`cloudflare-warp`), use the AUR as well. Install the binary package with:
```bash
yay -S cloudflare-warp-bin
```
Or, if using `paru`:
```bash
paru -S cloudflare-warp-bin
```
After installation, enable and start the service:
```bash
sudo systemctl enable --now warp-svc
```
Register and connect using the `warp-cli` tool:
```bash
warp-cli registration new
warp-cli mode warp+doh
warp-cli connect
```
This sets up a full tunnel with DNS over HTTPS 

For other Cloudflare tools like `certbot-dns-cloudflare` or `cloudflare-ddns`, you can install them via the Snap Store on Arch Linux. First, install `snapd` from the AUR:
```bash
git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
```
Enable the snap socket service:
```bash
sudo systemctl enable --now snapd.socket
```
Then install the desired tool:
```bash
sudo snap install certbot-dns-cloudflare
sudo snap install cloudflare-ddns
```
Note that classic snap support may require creating a symbolic link: `sudo ln -s /var/lib/snapd/snap /snap` 

If you need to build `cloudflared` from source, especially for unsupported architectures like aarch64, use:
```bash
go get -u github.com/cloudflare/cloudflared/cmd/cloudflared
```
Then move the binary to a system path like `/usr/bin` 
