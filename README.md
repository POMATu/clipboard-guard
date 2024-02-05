# clipboard-guard

Remember how you accidentally sent your nudes to public discord server or your boss because fukin ctrl+c didnt worked? Never again. 

# Installation

`apt install xclip -y`
Download the script
Invoke `chmod +x ./guard.pl`

# Usage
For testing just run the script and test what minimum amount of seconds you are comfortable with. The less is better but obviously it should not fuck you up.

For persistence you might need to add it to your Desktop Environment autorun so it executes within inside X session and gets all Xorg variables it needs to operate. For gnome you need to edit .desktop file and drop it to `~/.config/autostart/clipboard-guard.desktop `

Might be possible to create systemd service but idk what variables you need to pass to it and how, just DISPLAY=:0 is not enuf.


