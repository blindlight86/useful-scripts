# Change base image
sed -i 's/-alpine//' Dockerfile
sed -i 's/apk add/apt install/' Dockerfile
sed -i 's/--no-cache /-y /' Dockerfile
sed -i 's/build-base/build-essential/' Dockerfile
sed -i 's/openssl-dev/openssl libssl-dev/' Dockerfile
sed -i '/# Install dependencies/a\RUN apt update && apt -y upgrade' Dockerfile
sed -i '/#install user-specific packages/a\apt update' dockerStart.sh
sed -i 's/apk add --no-cache/apt install -y/' dockerStart.sh

# Add ssh support
sed -i '/EXPOSE 5050/a\EXPOSE 22' Dockerfile
sed -i '/# Install additional packages/i\# Install ssh' Dockerfile
sed -i '/# Install additional packages/i\RUN apt install -y openssh-server' Dockerfile
sed -i '/# Install additional packages/i\RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config' Dockerfile
sed -i '/# Install additional packages/i\RUN sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config' Dockerfile
sed -i '/# Install additional packages/i\RUN mkdir -p /run/sshd' Dockerfile
sed -i '/# Install additional packages/i\\n' Dockerfile

# Copy config
sed -i '/CONF_SRC=\/usr\/src\/app\/conf/i\CONF_DEBUG=\/usr\/src\/app\/config' dockerStart.sh
sed -i '/#install user-specific packages/i\# copy volumed conf to debug config' dockerStart.sh
sed -i '/#install user-specific packages/i\if [ -f $CONF/appdaemon.yaml ]; then' dockerStart.sh
sed -i '/#install user-specific packages/i\  cp -r $CONF $CONF_DEBUG' dockerStart.sh
sed -i '/#install user-specific packages/i\fi' dockerStart.sh
sed -i '/#install user-specific packages/i\\n' dockerStart.sh

# Change entrypoint
sed -i '/appdaemon -c $CONF/i\if \[ -n "$DAEMON" \]; then' dockerStart.sh
sed -i '/appdaemon -c $CONF/a\fi' dockerStart.sh
sed -i '/appdaemon -c $CONF/a\exec \/usr\/sbin\/sshd -D "$@"' dockerStart.sh
sed -i '/appdaemon -c $CONF/a\else' dockerStart.sh
sed -i '/#install user-specific packages/i\# if ENV SSHPASSWORD is set, change root password for ssh' dockerStart.sh
sed -i '/#install user-specific packages/i\if \[ -n "$SSHPASSWORD" \]; then' dockerStart.sh
sed -i '/#install user-specific packages/i\  echo root:$SSHPASSWORD | chpasswd' dockerStart.sh
sed -i '/#install user-specific packages/i\fi' dockerStart.sh
sed -i '/#install user-specific packages/i\\n' dockerStart.sh

sed -i '/#install user-specific packages/i\# if ENV RSA_PUB is set, copy file' dockerStart.sh
sed -i '/#install user-specific packages/i\if \[ -n "$RSA_PUB" \]; then' dockerStart.sh
sed -i '/#install user-specific packages/i\  mkdir -p ~\/.ssh && chmod 700 ~\/.ssh' dockerStart.sh
sed -i '/#install user-specific packages/i\  cp $CONF\/$RSA_PUB ~\/.ssh\/authorized_keys && chmod 600  ~\/.ssh\/authorized_keys' dockerStart.sh
sed -i '/#install user-specific packages/i\fi' dockerStart.sh
sed -i '/#install user-specific packages/i\\n' dockerStart.sh
