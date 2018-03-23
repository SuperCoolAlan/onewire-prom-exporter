#!/bin/bash

export GOBIN=.
export PATH=$PATH:$GOBIN
export GOOS=linux
export GOARCH=arm
export GOARM=5

dep ensure --update 
go build -o onewire-prom-exporter main.go