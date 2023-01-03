# Install az-cli

Reference: https://learn.microsoft.com/pt-br/cli/azure/install-azure-cli-linux?pivots=apt
<code>


cd /etc/apt/sources.list.d
sudo rm google-cloud-sdk.list

sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
gpg --dearmor |
sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" |
sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli -y
</code>

# if on a desktop GUI
az login

# prove authentication
az group list -o table