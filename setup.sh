echo "~~~~~~~~~~ Dev Container Setup ~~~~~~~~~~"
cd ~

echo "[ 1/10] - System Update"

# Add Docker's official GPG key:
sudo apt-get update -y

echo "[ 2/10] - Install Docker Dependencies"
sudo apt-get install ca-certificates curl -y

echo "[ 3/10] - Add Docker GPG Key & Repository"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[ 4/10] - System Update"
sudo apt-get update -y

echo "[ 5/10] - Install Docker and Docker-Compose"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "[ 6/10] - Add User to Docker Group"
sudo usermod -aG docker $USER

echo "[ 7/10] - Create Directory"
mkdir javaDev
mkdir javaDev/project
cd javaDev

echo "[ 8/10] - Create Docker Compose File"
touch docker-compose.yml

read -s -p "Bitte ein Passwort für code-server festlegen: " USER_PASSWORD
echo ""

echo "services:
    code-server:
        image: zenkuja/java-dev-container:latest

        ports:
            - "8080:8080"

        environment:
            - PASSWORD=$USER_PASSWORD

        volumes:
            - ./project-data:/home/javaDev/project
            - /var/run/docker.sock:/var/run/docker.sock

        restart: unless-stopped" > docker-compose.yml

chmod 600 docker-compose.yml

echo "[ 9/10] - Pull Docker Image and Run Image"
sudo docker compose pull
sudo docker compose up -d

SERVER_IP=$(curl -s icanhazip.com || hostname -I | awk '{print $1}')

echo ""
echo "[10/10] - Finished JavDevContainer Setup"
echo ""
echo "---------------------------------------------------"
echo "  URL:      http://$SERVER_IP:8080"
echo "  Passwort: $USER_PASSWORD"
echo "---------------------------------------------------"
echo ""
echo "WICHTIG: Starte eine neue Terminal-Session um Docker ohne 'sudo' verwenden zu können."
