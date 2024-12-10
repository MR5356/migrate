FROM golang:1.23-alpine3.20 AS builder
ARG VERSION

RUN apk add --no-cache git gcc musl-dev make ca-certificates

WORKDIR /go/src/github.com/golang-migrate/migrate

ENV GO111MODULE=on

COPY go.mod go.sum ./

RUN go mod download

COPY . ./

RUN make build-docker

RUN copy /go/src/github.com/golang-migrate/migrate/build/migrate.linux-386 /usr/local/bin/migrate && \
    ln -s /usr/local/bin/migrate /migrate

ENTRYPOINT ["migrate"]
CMD ["--help"]
