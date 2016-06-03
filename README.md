![MIT License](https://img.shields.io/github/license/mkenney/docker-composer.svg) ![Docker pulls](https://img.shields.io/docker/pulls/mkenney/composer.svg) ![Docker stars](https://img.shields.io/docker/stars/mkenney/composer.svg) ![Github issues](https://img.shields.io/github/issues-raw/mkenney/docker-composer.svg)

![PHP v5](https://img.shields.io/badge/PHP-v5.6.21-8892bf.svg) ![Composer v1](https://img.shields.io/badge/composer-v1.1.1-orange.svg)

# Portable composer script

The [source repository](https://github.com/mkenney/docker-composer) contains a [shell script](https://github.com/mkenney/docker-composer/blob/php5/bin/composer) that wraps running a docker container to execute [composer](https://getcomposer.org/). The current directory is mounted into `/src` inside the container and an internal wrapper script executes composer as a user who's `uid` and `gid` matches those properties on that mounted directory. This way composer files are installed as the directory owner/group instead of root or a random user.

Because this runs out of a Docker container, all files and directories required by your composer command must be available within the current directory. Specifying files or directories from other locations on the system will not work. For example, `--working-dir=/home/user/folder/` would attempt to use the `/home/user/folder/` path inside the container instead of on the host.

In order to facilitate access to private repositories or use public-key authentication, `$HOME/.ssh` is mounted into the container user's home directory. Any authentication issues that come up can most likely be resolved by modifying your `$HOME/.ssh/config` file.

# Source repository

* [mkenney/docker-composer](https://github.com/mkenney/docker-composer)

# Docker image

* [mkenney/composer](https://hub.docker.com/r/mkenney/composer/)

Based on [alpine 3.3](https://hub.docker.com/_/alpine/). This is simply a php CLI binary built with a few tools required to run `composer` and to do minimal user management in order to run as a user with the same `uid` and `gid` as the current directory.

# Change log

## 2016-06-02

I changed the base image from [mkenney/php-base](https://hub.docker.com/r/mkenney/php-base/) to [alpine](https://hub.docker.com/_/alpine/) to reduce the image size and because Composer doesn't have many dependencies. This reduced the image size from ~330MB to 34MB. Please [let me know](https://github.com/mkenney/docker-composer/issues) if you have any problems.

# Tagged Dockerfiles

* [latest](https://github.com/mkenney/docker-composer/blob/master/Dockerfile), [php7](https://github.com/mkenney/docker-composer/blob/master/Dockerfile)
* [php5](https://github.com/mkenney/docker-composer/blob/php5/Dockerfile)
