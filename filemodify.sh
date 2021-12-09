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
sed -i '/# Install dependencies/i\# Install ssh' Dockerfile
sed -i '/# Install dependencies/i\RUN apt install -y openssh-server' Dockerfile
sed -i '/# Install dependencies/i\RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config' Dockerfile
sed -i '/# Install dependencies/i\RUN sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config' Dockerfile
sed -i '/# Install dependencies/i\\n' Dockerfile

# Change entrypoint
sed -i 's/appdaemon -c $CONF/\/usr\/sbin\/sshd -D/' dockerStart.sh
sed -i '/#install user-specific packages/i\# if ENV SSHPASSWORD is set, change root password for ssh' dockerStart.sh
sed -i '/#install user-specific packages/i\if \[ -n "$SSHPASSWORD" \]; then' dockerStart.sh
sed -i '/#install user-specific packages/i\  echo root:$SSHPASSWORD | chpasswd' dockerStart.sh
sed -i '/#install user-specific packages/i\fi' dockerStart.sh
sed -i '/#install user-specific packages/i\\n' dockerStart.sh
