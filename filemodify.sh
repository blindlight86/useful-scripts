# Change base image
sed -i 's/-alpine//' Dockerfile
sed -i 's/apk add/apt install/' Dockerfile
sed -i 's/--no-cache /-y /' Dockerfile
sed -i 's/build-base/build-essential/' Dockerfile
sed -i 's/openssl-dev/openssl libssl-dev/' Dockerfile
sed -i '/# Install dependencies/a\RUN apt update && apt -y upgrade' Dockerfile

# Add ssh support
sed -i '/EXPOSE 5050/a\EXPOSE 22' Dockerfile
sed -i '/# Install dependencies/i\# Install ssh' Dockerfile
sed -i '/# Install dependencies/i\RUN apt install -y ssh' Dockerfile
sed -i '/# Install dependencies/i\RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config' Dockerfile
# sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
# sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# sed -i '/#install user-specific packages/a\apt update' dockerStart.sh
# sed -i 's/apk add --no-cache/apt install -y/' dockerStart.sh