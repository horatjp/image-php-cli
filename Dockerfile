FROM php:8.4-cli-trixie

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=composer:2.9.2 /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    bash-completion \
    chromium \
    curl \
    dnsutils \
    fonts-noto-cjk \
    git \
    imagemagick \
    jq \
    less \
    locales \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmagickwand-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libwebp-dev \
    libxslt-dev \
    libzip-dev \
    mariadb-client \
    openssh-client \
    postgresql-client \
    rsync \
    sqlite3 \
    supervisor \
    tree \
    unzip \
    vim \
    wget \
    yq \
    zip \
    zsh \
    # Additional tools for development
    tmux \
    ripgrep \
    fd-find \
    bat \
    eza \
    fzf \
    gh \
    lazygit \
    git-delta \
    btop \
    # user
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    # clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN pecl install imagick mailparse redis-6.3.0 xdebug-3.4.7 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-enable imagick mailparse redis xdebug \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    xml \
    zip \
    && pecl clear-cache

COPY config/php.ini /usr/local/etc/php/conf.d/

# Remove Chromium desktop entry
RUN rm -f /usr/share/applications/chromium.desktop

# Install Starship prompt (as non-root user)
RUN su ${USERNAME} -c 'curl -sS https://starship.rs/install.sh | sh -s -- --yes'

# Install Znap (Zsh plugin manager) and pre-install plugins
RUN su -s /bin/zsh ${USERNAME} -c 'git clone --depth=1 https://github.com/marlonrichert/zsh-snap.git /home/${USERNAME}/.zsh-snap \
    && source /home/${USERNAME}/.zsh-snap/znap.zsh \
    && znap clone marlonrichert/zsh-autocomplete \
    && znap clone zsh-users/zsh-autosuggestions \
    && znap clone zsh-users/zsh-syntax-highlighting'

# Install mise
RUN su ${USERNAME} -c 'curl https://mise.run | sh'
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
ENV MISE_TRUSTED_CONFIG_PATHS="/workspace"

# Install usage CLI for better mise completions
RUN su ${USERNAME} -c 'mise use -g usage@latest'

# Copy custom configuration files
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.alias /home/${USERNAME}/.zshrc.alias
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.history /home/${USERNAME}/.zshrc.history
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.znap /home/${USERNAME}/.zshrc.znap
COPY --chown=${USERNAME}:${USERNAME} config/starship.toml /home/${USERNAME}/.config/starship.toml
COPY --chown=${USERNAME}:${USERNAME} config/.vimrc /home/${USERNAME}/.vimrc

# Set environment variables
ENV SHELL=/bin/zsh

WORKDIR /workspace
