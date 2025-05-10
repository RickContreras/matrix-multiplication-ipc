# Imagen base con soporte para C, Go y herramientas básicas
FROM ubuntu:22.04

# Configurar el entorno
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    python3 \
    python3-pip \
    golang \
    git \
    manpages-dev \
    sudo \
    && apt-get clean

# Establecer directorio de trabajo
WORKDIR /workspaces/matrix-multiplication-ipc

# Crear usuario vscode
RUN useradd -m vscode && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode

# Configurar Go
ENV GOPATH=/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Establecer usuario predeterminado
USER vscode