FROM archlinux

# Change root password
RUN echo 'root:1234' | chpasswd

# Initialize pacman keyring and populate Arch Linux keys
RUN pacman-key --init && pacman-key --populate archlinux

# Install basic packages
RUN pacman -Sy --noconfirm vi archlinux-keyring

# Configure sudoers
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# Create user 'tree' and add to wheel group
RUN useradd -m -G wheel -s /bin/bash tree && echo 'tree:1234' | chpasswd
RUN echo 'tree ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# Update system
RUN pacman -Syuu --noconfirm 
RUN pacman -S --noconfirm reflector &&	reflector -l 5 --sort rate --save /etc/pacman.d/mirrorlist

# Install essential packages
RUN pacman -S --noconfirm  git yarn zsh typescript nodejs  python3 python npm rustup go  neovim gitui unzip python-pip gitui openssh ctags wget fzf cmake eza lldb zoxide tmux postgresql llvm
nvidia nvidia-utils btop vulkan-devel mesa vulkan-dzn
# Install global npm packages
RUN npm install -g typescript typescript-language-server prettier spaceship bun

# Install yay (AUR helper)
RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git
RUN mkdir /tmp/yay && \
    chown -R tree:tree /tmp/yay
USER tree
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg --noconfirm --needed -sri && \
    cd / && \
    rm -rf /tmp/yay
USER root

# Install AUR packages
USER tree
RUN yay -S  --noconfirm ripgrep pnpm luarocks  ts-node noto-fonts-cjk fzf ripgrep python-huggingface-hub ollama atuin win32yank-bin
# Set Rust stable as default
USER tree
RUN rustup default stable

# Install Rust packages
RUN cargo install zoxide eza joshuto

# Configure .zshrc
RUN echo 'export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"' >> ~/.zshrc

# Configure sudo for dbus

# Change default shell to zsh
USER tree

# Change default shell to zsh

# Install Oh-My-Zsh
RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install zsh-syntax-highlighting plugin
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    echo 'plugins=(zsh-syntax-highlighting)' >> ~/.zshrc

# Install zsh-autosuggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    echo 'plugins=(zsh-autosuggestions)' >> ~/.zshrc && \
    echo 'ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"' >> ~/.zshrc

RUN git clone https://github.com/tendertree/config ~

RUN curl -fsSL https://ollama.com/install.sh | sh
RUN ollama run llama3
