### NodeJS v10 based images

| **Tag**                             | **Base Image**               | **Arch** | **OS** | **Description**   | *test* |
|-------------------------------------|------------------------------|----------|--------|-------------------|--------|
| 0.20.7-alpine-amd64                 | amd64/node:10-alpine         | amd64    | alpine | no python         |   ok   |
| 0.20.7-alpine-arm32v6               | arm32v6/node:10-alpine       | arm32v6  | alpine | no python         |   ok   |
| ~~0.20.7-alpine-arm32v7~~           | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-buster-slim-arm32v7          | arm32v7/node:10-buster-slim  | arm32v7  | debian | no python         |   ok   |
| 0.20.7-alpine-arm64v8               | arm64v8/node:10-alpine       | arm64v8  | alpine | no python         |   no test   |
||  
| 0.20.7-alpine-amd64-python3         | amd64/node:10-alpine         | amd64    | alpine | python 3          |   ok   |
| 0.20.7-alpine-arm32v6-python3       | arm32v6/node:10-alpine       | arm32v6  | alpine | python 3          |   ok   |
| ~~0.20.7-alpine-arm32v7-python3~~   | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-buster-slim-arm32v7-python3  | arm32v7/node:10-slim         | arm32v7  | debian | python 3          |   ok   |
| 0.20.7-alpine-arm64v8-python3       | arm64v8/node:10-alpine       | arm64v8  | alpine | python 3          |      |
||  
| 0.20.7-alpine-amd64-python2         | amd64/node:10-alpine         | amd64    | alpine | python 2          |   ok   |
| 0.20.7-alpine-arm32v6-python2       | arm32v6/node:10-alpine       | arm32v6  | alpine | python 2          |   ok   |
| ~~0.20.7-alpine-arm32v7-python2~~   | ~~arm32v7/node:10-alpine~~       | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
| 0.20.7-buster-slim-arm32v7-python2  | arm32v7/node:10-slim         | arm32v7  | debian | python 2          |   ok   |
| 0.20.7-alpine-arm64v8-python2       | arm64v8/node:10-alpine       | arm64v8  | alpine | python 2          |   no test   |
     
#### Manifest Lists     
| **Tag**                        | **Base Image**                    | **Arch** | **OS** | **Description**   | *test* |
|--------------------------------|-----------------------------------|----------|--------|-------------------|--------|
| latest, 0.20.7                 | 0.20.7-alpine-amd64               | amd64    | alpine | no python         |     |
|                                | 0.20.7-alpine-arm32v6             | arm32v6  | alpine | no python, gpio   |     |
|                                | ~~0.20.7-alpine-arm32v7~~         | ~~arm32v7~~  | ~~alpine~~ | not available yet | |
|                                | 0.20.7-buster-slim-arm32v7        | arm32v7  | debian | no python         | |
|                                | 0.20.7-alpine-arm64v8             | arm64v8  | alpine | no python         |    |
||
| latest-python3, 0.20.7-python3 | 0.20.7-alpine-amd64-python3       | amd64    | alpine | python 3          |    |
|                                | 0.20.7-alpine-arm32v6-python3     | arm32v6  | alpine | python 3          |    |
|                                | ~~0.20.7-alpine-arm32v7-python3~~ | ~~arm32v7~~  | ~~alpine~~ | not available yet ||
|                                | 0.20.7-buster-slim-arm32v7-python3| arm32v7  | debian | python 3          |    |
|                                | 0.20.7-alpine-arm64v8-python3     | arm64v8  | alpine | python 3          |    |
||
| latest-python2, 0.20.7-python2 | 0.20.7-alpine-amd64-python2       | amd64    | alpine | python 2          |   |
|                                | 0.20.7-alpine-arm32v6-python2     | arm32v6  | alpine | python 2          |   |
|                                | ~~0.20.7-alpine-arm32v7-python2~~ | ~~arm32v7~~  | ~~alpine~~ | ~~not available yet~~ | |
|                                | 0.20.7-buster-slim-arm32v7-python2| arm32v7  | debian | python 2          |   |
|                                | 0.20.7-alpine-arm64v8-python2     | arm64v8  | alpine | python 2          |   |

#### Raspberry PI Tags
| **Tag**                                | **Image**                          | **Arch** | **OS** | **Description**   |
|----------------------------------------|------------------------------------|----------|--------|-------------------|
| latest-rpi*, 0.20.7-rpi*                 | 0.20.7-alpine-arm32v6              | arm32v6  | alpine | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7         | arm32v7  | alpine | |
||
| latest-rpi-python3, 0.20.7-rpi-python3 | 0.20.7-alpine-arm32v6-python3      | arm32v6  | alpine | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7-python3 | arm32v7  | alpine | |
||
| latest-rpi-python2, 0.20.7-rpi-python2 | 0.20.7-alpine-arm32v6-python2      | arm32v6  | alpine | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7-python2 | arm32v7  | alpine | |


