#/bin/sh

npx -y @gergelyszerovay/mcp-server-aibd-devcontainer --enableHttpTransport=true --mcpHttpPort=3100 --enableStdioTransport=false --enableRestServer=true --restHttpPort=3101 --enableShellExecTool=true --allowed-directories=/workspaces