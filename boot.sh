#!/bin/bash

RUSER=replace_user

echo "Fixing User Ownershp"
chown -R $RUSER:$RUSER /opt /home/$RUSER

echo "Adding SSH setup"
if [ ! -d /home/$RUSER/.ssh ]; then
  sudo -u $RUSER bash -c "\
    mkdir /home/$RUSER/.ssh \
    && cp /opt/authorized_keys /home/$RUSER/.ssh/. \
    && cp /opt/exports.local /home/$RUSER/. \
    && chmod 700 /home/$RUSER/.ssh"
fi

# install rustup
echo "Installing Rust"
if [ ! -d /home/$RUSER/.cargo ]; then
  sudo -u $RUSER bash -c "\
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >/home/$RUSER/rustup-init.sh \
    && bash /home/$RUSER/rustup-init.sh -y \
    && rm /home/$RUSER/rustup-init.sh \
    && source /home/$RUSER/.cargo/env \
    && rustup update"
fi

echo "Adding dotfiles and installing python and neovim"
if [ ! -d /home/$RUSER/.dotfiles ]; then
  sudo -u $RUSER bash -c "
    git clone https://github.com/koaps/devdotfiles.git /home/$RUSER/.dotfiles \
    && pushd /home/$RUSER/.dotfiles \
    && rm -rf nvim \
    && git clone https://github.com/koaps/nvim-minimax.git nvim \
    && sh -x ./uv.sh \
    && sh -x ./create_symlinks.sh \
    && sh -x ./neovim.sh \
    && popd"
fi

# install python packages
echo "Installing Python Packages"
su -l -c "/home/$RUSER/.local/bin/uv pip install --upgrade pip setuptools wheel" - $RUSER
su -l -c "/home/$RUSER/.local/bin/uv pip install -r /opt/pip-packages.txt" - $RUSER

# This has to be last
echo "Running sshd daemon..."
/usr/sbin/sshd -D
