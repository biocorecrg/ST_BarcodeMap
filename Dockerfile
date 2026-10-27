# Multi-stage build for ST_BarcodeMap
# Stage 1: Build binary
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    make \
    libboost-all-dev \
    libhdf5-dev \
    zlib1g-dev \
    dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY Makefile ./
COPY src/ ./src/

ENV CPATH="/usr/include/hdf5/serial:${CPATH}"
ENV LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/hdf5/serial:/usr/lib/aarch64-linux-gnu/hdf5/serial:${LIBRARY_PATH}"

RUN make -j"$(nproc)" && \
    make install PREFIX=/install/usr/local

# Stage 2: Minimal runtime image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="ST_BarcodeMap" \
      org.opencontainers.image.description="Map barcode of stereomics-seq to stereomics-chip" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libboost-serialization1.74.0 \
    libhdf5-103-1 \
    zlib1g \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install/usr/local/bin/ /usr/local/bin/

ENTRYPOINT ["ST_BarcodeMap"]
CMD ["--help"]
