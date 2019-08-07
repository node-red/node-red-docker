### NodeJS v10 based images

| **Tag**                             | **Base Image**               | **Arch** | **OS** | **Description**   | *test* |
|-------------------------------------|------------------------------|----------|--------|-------------------|--------|
| 0.20.7-alpine-amd64                 | amd64/node:10-alpine         | amd64    | alpine | no python         |   , ok |
| 0.20.7-alpine-arm32v6               | arm32v6/node:10-alpine       | arm32v6  | alpine | no python         |   , ok |
| ~~0.20.7-alpine-arm32v7~~           | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-slim-arm32v7                 | arm32v7/node:10-slim         | arm32v7  | debian | no python         ||
| 0.20.7-alpine-arm64v8               | arm64v8/node:10-alpine       | arm64v8  | alpine | no python         |   , ok |
||  
| 0.20.7-alpine-amd64-python3         | amd64/node:10-alpine         | amd64    | alpine | python 3          |   , ok |
| 0.20.7-alpine-arm32v6-python3       | arm32v6/node:10-alpine       | arm32v6  | alpine | python 3, gpio    |   , ok |
| ~~0.20.7-alpine-arm32v7-python3~~   | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-slim-arm32v7-python3         | arm32v7/node:10-slim         | arm32v7  | debian | python 3          ||
| 0.20.7-alpine-arm64v8-python3       | arm64v8/node:10-alpine       | arm64v8  | alpine | python 3          |   , ok |
||  
| 0.20.7-alpine-amd64-python2         | amd64/node:10-alpine         | amd64    | alpine | python 2          |   , ok |
| 0.20.7-alpine-arm32v6-python2       | arm32v6/node:10-alpine       | arm32v6  | alpine | python 2, gpio    |   , ok |
| ~~0.20.7-alpine-arm32v7-python2~~   | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-slim-arm32v7-python2         | arm32v7/node:10-slim         | arm32v7  | debian | python 2          |   , ok |
| 0.20.7-alpine-arm64v8-python2       | arm64v8/node:10-alpine       | arm64v8  | alpine | python 2          |   , ok |
     
#### Manifest Lists     
| **Tag**                        | **Image**                         | **Arch** | **OS** | **Description**   | *test* |
|--------------------------------|-----------------------------------|----------|--------|-------------------|--------|
| latest, 0.20.7                 | 0.20.7-alpine-amd64               | amd64    | alpine | no python         |   ,ok  |
|                                | 0.20.7-alpine-arm32v6             | arm32v6  | alpine | no python, gpio   |   ,ok  |
|                                | ~~0.20.7-alpine-arm32v7~~         | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
|                                | 0.20.7-slim-arm32v7               | arm32v7  | debian | no python         | |
|                                | 0.20.7-alpine-arm64v8             | arm64v8  | alpine | no python         |   , ok |
||
| latest-python3, 0.20.7-python3 | 0.20.7-alpine-amd64-python3       | amd64    | alpine | python 3          |   , ok |
|                                | 0.20.7-alpine-arm32v6-python3     | arm32v6  | alpine | python 3          |   , ok |
|                                | ~~0.20.7-alpine-arm32v7-python3~~ | ~~arm32v7~~  | ~~alpine~~ | not available yet ||
|                                | 0.20.7-slim-arm32v7-python3       | arm32v7  | debian | python 3          |   , ok |
|                                | 0.20.7-alpine-arm64v8-python3     | arm64v8  | alpine | python 3          |   , ok |
||
| latest-python2, 0.20.7-python2 | 0.20.7-alpine-amd64-python2       | amd64    | alpine | python 2          |   , ok |
|                                | 0.20.7-alpine-arm32v6-python2     | arm32v6  | alpine | python 2          |   , ok |
|                                | ~~0.20.7-alpine-arm32v7-python2~~ | ~~arm32v7~~  | ~~alpine~~ | ~~not available yet~~ | |
|                                | 0.20.7-slim-arm32v7-python2       | arm32v7  | debian | python 2          |   , ok |
|                                | 0.20.7-alpine-arm64v8-python2     | arm64v8  | alpine | python 2          |   , ok |

#### Raspberry PI Tags
| **Tag**                      | **Image**                    | **Arch** | **OS** | **Description**   |
|------------------------------|------------------------------|----------|--------|-------------------|
| rpi                          | 0.20.7-alpine-arm32v6        | arm32v6  | alpine | rpi 1, 2 & zero   |
| rpi3                         | ~~0.20.7-alpine-arm32v7~~        | ~~arm32v7~~  | ~~alpine~~ | not available yet |
| rpi3                         | 0.20.7-slim-arm32v7          | arm32v7  | debian | rpi 3 & 4         |
||
| rpi-python                   | 0.20.7-alpine-arm32v6-python | arm32v6  | alpine | rpi 1, 2 & zero   |
| rpi3-python                  | ~~0.20.7-alpine-arm32v7-python~~ | arm32v7  | alpine | not available yet |
| rpi3-python                  | 0.20.7-slim-arm32v7-python   | arm32v7  | debian | rpi 3 & 4         |


##### Docker Run
`docker run -it --rm -p1441:1880 --user=root --privileged=true -v /dev/mem:/dev/mem raymondmm/node-red-gpio-python2v2`
