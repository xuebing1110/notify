FROM golang:1.13.5-alpine3.10 as build-env

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/community/" >> /etc/apk/repositories

# git
RUN apk update
RUN apk add --no-cache git

# move to GOPATH
RUN mkdir -p /app
WORKDIR /app

# go mod
ENV GOPROXY=https://goproxy.cn
COPY go.mod .
COPY go.sum .
RUN go mod download

# build
COPY . .
RUN go build -o /app/notify cmd/main.go


FROM alpine:3.10
MAINTAINER Xue Bing <xuebing1110@gmail.com>

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/community/" >> /etc/apk/repositories

# timezone
RUN apk update
RUN apk add --no-cache tzdata \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apk add curl

COPY --from=build-env /app /app

EXPOSE 8080
WORKDIR /app
CMD ["/app/notify"]
