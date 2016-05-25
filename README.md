![PHP v7](https://img.shields.io/badge/PHP-v7.0.6-8892bf.svg?link=https://php.net/) ![Composer v1](https://img.shields.io/badge/composer-v1.1.1-orange.svg?link=https://getcomposer.org/) ![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?link=https://en.wikipedia.org/wiki/MIT_License)

# Environment independent composer script

The source repo contains a `composer` script that wraps executing a docker container to execute [composer](https://getcomposer.org/). The current directory is mounted into /src in the container and a wrapper script executes composer as a user who's `uid` and `gid` matches those properties on that directory. This way composer files are installed as the directory owner/group instead of root or a random user.

Because this runs out of a Docker container, all files and directories required by your composer command must be available within the current directory. Specifying files or directories from other locations on the system will not work. For example, `--working-dir=/home/user/folder/` would attempt to use the `/home/user/folder/` path inside the container instead of on the host.

In order to facilitate access to private repositories or use public-key authentication, `$HOME/.ssh` is mounted into the container user's home directory. Any authentication issues that come up can most likely be resolved by modifying your `~/.ssh/config` file.

# SOURCE REPOSITORY

* [mkenney/docker-composer](https://github.com/mkenney/docker-composer)

# Docker image

* [mkenney/composer](https://hub.docker.com/r/mkenney/composer/)

Based on [mkenney/php-base](https://hub.docker.com/r/mkenney/php-base/) (debian:jessie) which is simply a php CLI binary built with various tools, most notably Oracle OCI libraries, because they're a pain to install.

# Tagged Dockerfiles

* [latest](https://github.com/mkenney/docker-composer/blob/master/Dockerfile), [php7](https://github.com/mkenney/docker-composer/blob/master/Dockerfile)
* [php5](https://github.com/mkenney/docker-composer/blob/php5/Dockerfile)
