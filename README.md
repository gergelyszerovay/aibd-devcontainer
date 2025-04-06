# AIBD Dev Container

A preconfigured development container setup for AI-assisted development with Claude, based on VS Code Dev Containers with integrated [Model Context Protocol (MCP) server for file system and shell](https://www.npmjs.com/package/@gergelyszerovay/mcp-server-aibd-devcontainer) operations.

## Overview

This repository provides a ready-to-use development container that:

- Creates a consistent, isolated development environment
- Integrates seamlessly with Claude Desktop via MCP server
- Uses Docker volumes for persistent storage
- Works on Windows (with WSL2), macOS, and Linux

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- For Windows users: [WSL2 enabled](https://docs.docker.com/desktop/features/wsl/)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/gergelyszerovay/aibd-devcontainer.git
cd aibd-devcontainer
```

### 2. Open in VS Code

Open the cloned repository in Visual Studio Code. You should receive a notification asking if you want to reopen the folder in a container. Click "Reopen in Container" to proceed.

Alternatively, you can:

1. Click the green button in the lower-left corner of VS Code
2. Select "Reopen in Container" from the menu

### 3. Wait for Container Build

VS Code will build and start your development container. This process may take a few moments on first launch. Subsequent starts will be faster.

### 4. Access Your Project Files

The container creates a Docker volume mounted at `/volume` inside the container:

```bash
cd volume
```

This is where you should place your project files. You can either:

- Clone an existing repository: `git clone https://github.com/your-username/your-project.git`
- Create new files directly in this directory

### 5. Connect Claude to the Container

To connect Claude to your development container:

1. Configure Claude Desktop to use the MCP server by adding the following to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "devcontainer": {
      "command": "npx",
      "args": ["-y", "supergateway", "--sse", "http://localhost:3100/sse"]
    }
  }
}
```

2. Restart Claude Desktop to establish the connection

## Container Configuration

### Dev Container JSON

The `.devcontainer/devcontainer.json` file configures the development container:

```json
{
  "name": "Node.js & TypeScript",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:1-22-bookworm",
  "forwardPorts": [3100],
  "postCreateCommand": "bash .devcontainer/install.sh",
  "postStartCommand": "bash .devcontainer/start.sh",
  "mounts": [
    "source=${localWorkspaceFolderBasename}-volume,target=${containerWorkspaceFolder}/volume,type=volume"
  ]
}
```

This configuration:

- Uses the official Microsoft TypeScript/Node.js image
- Forwards port 3100 for the MCP server
- Runs setup scripts after creation and on each start
- Creates a persistent Docker volume for your project files

### Installation Script

The `.devcontainer/install.sh` script runs once when the container is first created:

```bash
#/bin/sh

sudo chown -R node:node ./

# Additional setup commands can be added here
```

You can customize this script to install additional tools or dependencies.

### Startup Script

The `.devcontainer/start.sh` script runs each time the container starts:

```bash
#/bin/sh

npx -y @gergelyszerovay/mcp-server-aibd-devcontainer --enableHttpTransport=true --mcpHttpPort=3100 --enableStdioTransport=false --enableRestServer=true --restHttpPort=3101 --enableShellExecTool=true --allowed-directories=/workspaces
```

This script starts the MCP server that enables Claude to interact with your code.

## License

This project is available under the MIT License. See the LICENSE file for more details.
