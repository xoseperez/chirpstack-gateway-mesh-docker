ARG ARCH
ARG VERSION
ARG BUILD_DATE

# Base image
FROM alpine:3.19

# Variables
ARG ARCH
ARG VERSION
ARG BUILD_DATE
ARG WORKDIR=/opt/chirpstack
ARG OWNER=xoseperez
ARG FILE=chirpstack-gateway-mesh
ARG DOWNLOAD_FROM=https://github.com/${OWNER}/${FILE}/releases/download

# Dependencies
RUN apk add --no-cache bash

# Switch to working directory for our app
WORKDIR ${WORKDIR}

# Checkout and compile remote code
ADD --chmod=666 ${DOWNLOAD_FROM}/${VERSION}/${FILE}_${VERSION}_${ARCH}.tar.gz ${FILE}.tar.gz
RUN tar -xf ${FILE}.tar.gz && rm ${FILE}.tar.gz

# Copy fles from builder and repo
COPY ./runner/ ./
RUN chmod 777 start
RUN chmod 777 .

# Run as nobody
USER nobody:nogroup

# Add application folder to path
ENV PATH="${PATH}:${WORKDIR}"

# Launch our binary on container startup.
CMD ["bash", "start"]
