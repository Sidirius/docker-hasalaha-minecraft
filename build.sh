#!/bin/bash
docker stop hasalaha
docker rm hasalaha
docker build --rm -t sidirius/docker-hasalaha-minecraft .
