#!/bin/bash

# check if grafana is up
echo "Checking if Grafana is running..."
curl -s -f -o /dev/null host.docker.internal:$GRAFANA_PORT || { >&2 printf '\nERROR: Grafana not found. Have you set GRAFANA_PORT correctly?\n'; exit 1; }

# install some libraries
echo "Installing libraries..."
go install github.com/google/go-jsonnet/cmd/jsonnet@latest 
go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest 
go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest
jb install github.com/grafana/grafonnet/gen/grafonnet-latest@main 

# install entr for file watching
git clone https://github.com/eradman/entr.git /tmp/entr
cd /tmp/entr || exit
./configure
sudo make install

# activate and download jsonnet language server 
mkdir -p /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/ 
ls -la /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/
curl -L "$(curl -s https://api.github.com/repos/grafana/jsonnet-language-server/releases/latest | jq -r '.assets[] | select(.name | test("jsonnet-language-server_.*_linux_amd64")) | .browser_download_url')" -o /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/jsonnet-language-server
chmod +x /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/jsonnet-language-server

curl -L "$(curl -s https://api.github.com/repos/grafana/jsonnet-debugger/releases/latest | jq -r '.assets[] | select(.name | test("jsonnet-debugger_.*_linux_amd64")) | .browser_download_url')" -o /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/jsonnet-debugger
chmod +x /home/vscode/.vscode-server/data/User/globalStorage/grafana.vscode-jsonnet/bin/jsonnet-debugger