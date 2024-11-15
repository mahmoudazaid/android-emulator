# Set Build Tools and API Level
ARG ANDROID_VERSION=9
FROM mahmoudazaid/android:${ANDROID_VERSION}

#======================#
# Environment Settings #
#======================#
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Berlin"

ARG EMULATOR_DEVICE="pixel"

#=======================#
# Set working directory #
#=======================#
WORKDIR /opt

#================================#
# Install Essential Dependencies #
#================================#
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install --no-install-recommends -y \
    tzdata \
    curl \
    sudo \
    wget \
    unzip \
    bzip2 \
    libdrm-dev \
    libxkbcommon-dev \
    libgbm-dev \
    libasound-dev \
    libnss3 \
    libxcursor1 \
    libpulse-dev \
    libxshmfence-dev \
    xauth \
    xvfb \
    x11vnc \
    fluxbox \
    wmctrl \
    libdbus-glib-1-2 \
    iputils-ping \
    net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#==============#
# Copy Scripts #
#==============#
COPY . /opt/emulator

#=============================#
# Set Permissions for Scripts #
#=============================#
RUN chmod +x /opt/emulator/create-emulator.sh && \
    chmod +x /opt/emulator/start-emulator.sh &&\
    chmod +x /opt/emulator/start.sh

#====================================#
# Run SDK and Emulator Setup Scripts #
#====================================#
RUN /opt/emulator/create-emulator.sh --EMULATOR_DEVICE "$EMULATOR_DEVICE" --EMULATOR_PACKAGE "$EMULATOR_PACKAGE"

#============================================#
# Clean up the installation files and caches #
#============================================#
RUN rm -f /opt/emulator/create-emulator.sh && \
    rm -rf /tmp/* /var/tmp/*

#===============#
# Entry Command #
#===============#
ENTRYPOINT ["/opt/emulator/start.sh"]
