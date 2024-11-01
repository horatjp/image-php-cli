FROM php:8.3-cli

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND noninteractive

COPY --from=composer:2.8.1 /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    bash-completion \
    curl \
    dnsutils \
    git \
    imagemagick \
    jq \
    less \
    locales \
    libc-client-dev \
    libfreetype6-dev \
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

RUN pecl install imagick mailparse redis-6.1.0 xdebug-3.3.2 \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-enable imagick mailparse redis xdebug \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    imap \
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

# Install nvm (Node Version Manager)
ENV NVM_DIR /home/${USERNAME}/.nvm
RUN mkdir -p ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && chown -R ${USERNAME}:${USERNAME} ${NVM_DIR}

# Install Oh My Zsh and configure it
RUN su ${USERNAME} -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' \
    && chsh -s /usr/bin/zsh ${USERNAME}

# Install useful zsh plugins
RUN : \
    && git clone https://github.com/zsh-users/zsh-autosuggestions /home/${USERNAME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/${USERNAME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-completions /home/${USERNAME}/.oh-my-zsh/custom/plugins/zsh-completions \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.oh-my-zsh/custom/plugins

# Configure zsh with enhanced settings
RUN echo '' > /home/${USERNAME}/.zshrc \
    && echo 'export ZSH=~/.oh-my-zsh' >> /home/${USERNAME}/.zshrc \
    && echo 'ZSH_THEME="robbyrussell"' >> /home/${USERNAME}/.zshrc \
    && echo 'ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999"' >> /home/${USERNAME}/.zshrc \
    && echo 'ZSH_AUTOSUGGEST_STRATEGY=(history completion)' >> /home/${USERNAME}/.zshrc \
    && echo 'plugins=(git docker composer zsh-syntax-highlighting zsh-autosuggestions zsh-completions)' >> /home/${USERNAME}/.zshrc \
    && echo 'source $ZSH/oh-my-zsh.sh' >> /home/${USERNAME}/.zshrc \
    && echo 'autoload -U compinit && compinit' >> /home/${USERNAME}/.zshrc \
    && echo 'zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"' >> /home/${USERNAME}/.zshrc \
    && echo 'setopt HIST_IGNORE_DUPS' >> /home/${USERNAME}/.zshrc \
    && echo 'setopt HIST_IGNORE_SPACE' >> /home/${USERNAME}/.zshrc \
    && echo 'setopt HIST_REDUCE_BLANKS' >> /home/${USERNAME}/.zshrc \
    && echo 'setopt AUTO_CD' >> /home/${USERNAME}/.zshrc \
    # Add nvm configuration
    && echo 'export NVM_DIR="$HOME/.nvm"' >> /home/${USERNAME}/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/${USERNAME}/.zshrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/${USERNAME}/.zshrc \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.zshrc

RUN mkdir -p /workspace;chown -R ${USERNAME}:${USERNAME} /workspace
WORKDIR /workspace
