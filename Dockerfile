# Built by Akito
# npub1wprtv89px7z2ut04vvquscpmyfuzvcxttwy2csvla5lvwyj807qqz5aqle

FROM alpine:3.18.3 as build
ENV TZ=Europe/London
WORKDIR /build
RUN \
  apk --no-cache add \
    linux-headers \
    git \
    g++ \
    make \
    pkgconfig \
    libtool \
    ca-certificates \
    perl-yaml-libyaml \
    perl-yaml \
    perl-template-toolkit \
    perl-app-cpanminus \
    libressl-dev \
    zlib-dev \
    lmdb-dev \
    flatbuffers-dev \
    libsecp256k1-dev \
    zstd-dev \
  && rm -rf /var/cache/apk/* \
  && cpanm Regexp::Grammars

COPY . .
RUN git submodule update --init
RUN make setup-golpe
RUN make -j4

FROM alpine:3.18.3
WORKDIR /app

RUN \
  apk --no-cache add \
    lmdb \
    flatbuffers \
    libsecp256k1 \
    libb2 \
    zstd \
    libressl3.7-libssl \
  && rm -rf /var/cache/apk/*

COPY --from=build /build/strfry strfry
ENTRYPOINT ["/app/strfry"]
CMD ["relay"]
