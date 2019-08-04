### NodeJS v10 based images

| **Tag**                      | **Base Image**               | **Arch** | **OS** | **Description**   |
|------------------------------|------------------------------|----------|--------|-------------------|
| 0.20.7-alpine-amd64          | amd64/node:10-alpine         | amd64    | alpine |                   |
| 0.20.7-alpine-arm32v6        | arm32v6/node:10-alpine       | arm32v6  | alpine |                   |
| 0.20.7-alpine-arm32v7        | arm32v7/node:10-alpine       | arm32v7  | alpine | not available yet |
| 0.20.7-slim-arm32v7          | arm32v7/node:10-slim         | arm32v7  | debian |                   |
| 0.20.7-alpine-arm64v8        | arm64v8/node:10-alpine       | arm64v8  | alpine |                   |
||
| 0.20.7-alpine-amd64-python   | amd64/node:10-alpine         | amd64    | alpine |                   |
| 0.20.7-alpine-arm32v6-python | arm32v6/node:10-alpine       | arm32v6  | alpine |                   |
| 0.20.7-alpine-arm32v7-python | arm32v7/node:10-alpine       | arm32v7  | alpine | not available yet |
| 0.20.7-slim-arm32v7-python   | arm32v7/node:10-slim         | arm32v7  | debian |                   |
| 0.20.7-alpine-arm64v8-python | arm64v8/node:10-alpine       | arm64v8  | alpine |                   |
     
#### Manifest Lists     
| **Tag**                      | **Image**                    | **Arch** | **OS** | **Description**   |
|------------------------------|------------------------------|----------|--------|-------------------|
| latest, 0.20.7               | 0.20.7-alpine-amd64          | amd64    | alpine |                   |
|                              | 0.20.7-alpine-arm32v6        | arm32v6  | alpine |                   |
|                              | 0.20.7-alpine-arm32v7        | arm32v7  | alpine | not available yet |
|                              | 0.20.7-slim-arm32v7          | arm32v7  | debian |                   |
|                              | 0.20.7-alpine-arm64v8        | arm64v8  | alpine |                   |
||
| latest-python, 0.20.7-python | 0.20.7-alpine-amd64-python   | amd64    | alpine |                   |
|                              | 0.20.7-alpine-arm32v6-python | arm32v6  | alpine |                   |
|                              | 0.20.7-alpine-arm32v7-python | arm32v7  | alpine | not available yet |
|                              | 0.20.7-slim-arm32v7-python   | arm32v7  | debian |                   |
|                              | 0.20.7-alpine-arm64v8-python | arm64v8  | alpine |                   |

#### Raspberry PI Tags
| **Tag**                      | **Image**                    | **Arch** | **OS** | **Description**   |
|------------------------------|------------------------------|----------|--------|-------------------|
| rpi                          | 0.20.7-alpine-arm32v6        | arm32v6  | alpine | rpi 1, 2 & zero   |
| rpi3                         | 0.20.7-alpine-arm32v7        | arm32v7  | alpine | not available yet |
| rpi3                         | 0.20.7-slim-arm32v7          | arm32v7  | debian | rpi 3 & 4         |
||
| rpi-python                   | 0.20.7-alpine-arm32v6-python | arm32v6  | alpine | rpi 1, 2 & zero   |
| rpi3-python                  | 0.20.7-alpine-arm32v7-python | arm32v7  | alpine | not available yet |
| rpi3-python                  | 0.20.7-slim-arm32v7-python   | arm32v7  | debian | rpi 3 & 4         |
