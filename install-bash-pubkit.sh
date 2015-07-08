#!/bin/bash
sudo apt-get update
sudo apt-get install pandoc git
git clone https://github.com/dmpop/bash-pubkit.git
#Install Calibre
sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
echo 'All done!'
