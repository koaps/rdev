#!/bin/bash

RUSER=rdev

chown -R $RUSER.$RUSER /opt/ssh /opt/dotfiles

sudo -u $RUSER bash -c "\
git clone http://172.16.16.1:3000/koaps/devssh.git /home/$RUSER/.ssh
git clone http://172.16.16.1:3000/koaps/devdotfiles.git /home/$RUSER/.dotfiles
sh -x /home/$RUSER/.dotfiles/setup.sh
"

# install python dependencies
sudo -u $RUSER bash -c "\
python3 -m venv --system-site-packages /home/$RUSER/.venv && \
source /home/$RUSER/.venv/bin/activate && \
python3 -m pip install --upgrade pip && \
python3 -m pip install -r /opt/pip-packages.txt
"
# install nodejs
sudo -u $RUSER bash -c "\
sudo apt-get install -y nodejs && \
sudo /usr/bin/npm update -g npm && \
sudo rsync -av /home/$RUSER/node_modules/ /usr/lib/node_modules/ && \
sed 's/#.*//' /opt/npm-packages.txt | xargs sudo /usr/bin/npm install -g
"

# This has to be last
echo "Running sshd daemon..."
/usr/sbin/sshd -D
