# Default to Go 1.15
ARG GO_VERSION=1.15
FROM golang:${GO_VERSION}-alpine as build

# Necessary to run 'go get' and to compile the linked binary
RUN apk add git musl-dev

ADD . /go/src/github.com/Marck/transfer.sh

WORKDIR /go/src/github.com/Marck/transfer.sh

ENV GO111MODULE=on

# build & install server
RUN go get -u ./... && CGO_ENABLED=0 go build -tags netgo -ldflags '-a -s -w -extldflags "-static"' -o /go/bin/transfersh github.com/Marck/transfer.sh

FROM scratch AS final
LABEL maintainer="Marck <connect.with.marck@gmail.com>"

COPY --from=build  /go/bin/transfersh /go/bin/transfersh
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/go/bin/transfersh", "--listener", ":8080"]

EXPOSE 8080
