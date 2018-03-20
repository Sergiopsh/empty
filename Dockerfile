FROM golang:1.9.2-alpine3.7 as builder
ENV GOBIN=$GOPATH/bin
COPY . /go
RUN apk add --no-cache git ca-certificates; \
  go get; \
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/empty \
  -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo

FROM scratch
COPY --from=builder /go/bin/empty /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
EXPOSE 8080/tcp
ENTRYPOINT ["/empty"]
