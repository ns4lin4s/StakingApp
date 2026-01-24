# --- Etapa 1: Descargador ---
FROM alpine:latest AS downloader
RUN apk add --no-cache curl tar

WORKDIR /deps

# Descargar Forge-Std
RUN mkdir -p forge-std && \
    curl -L https://github.com/foundry-rs/forge-std/archive/refs/heads/master.tar.gz | tar -xzC forge-std --strip-components=1

# Descargar OpenZeppelin Contracts
RUN mkdir -p openzeppelin-contracts && \
    curl -L https://github.com/OpenZeppelin/openzeppelin-contracts/archive/refs/heads/master.tar.gz | tar -xzC openzeppelin-contracts --strip-components=1

# --- Etapa 2: Imagen Final de Foundry ---
FROM ghcr.io/foundry-rs/foundry:latest

ENV FOUNDRY_DISABLE_NIGHTLY_WARNING=true
WORKDIR /app

# Copiamos el código del proyecto (asegúrate de tener el .dockerignore con 'lib' y '.git')
COPY . .

# Copiamos las librerías desde la etapa de descarga a la carpeta lib
COPY --from=downloader /deps/forge-std ./lib/forge-std
COPY --from=downloader /deps/openzeppelin-contracts ./lib/openzeppelin-contracts

# Importante: Algunos proyectos esperan encontrar OZ en 'lib/openzeppelin-contracts' 
# o simplemente 'lib/openzeppelin'. Forge suele usar mapeos.
# Compilamos para verificar
RUN forge build

CMD ["forge", "test"]