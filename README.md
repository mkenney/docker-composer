![MIT License](https://img.shields.io/github/license/mkenney/docker-composer.svg) ![Docker pulls](https://img.shields.io/docker/pulls/mkenney/composer.svg) ![Docker stars](https://img.shields.io/docker/stars/mkenney/composer.svg) ![Image size](https://img.shields.io/badge/image size-34MB-blue.svg) ![Github issues](https://img.shields.io/github/issues-raw/mkenney/docker-composer.svg)

# Portable composer script

## Tagged Dockerfiles

* [latest](https://github.com/mkenney/docker-composer/blob/master/Dockerfile), [php7](https://github.com/mkenney/docker-composer/blob/master/Dockerfile)

  ![build status](https://travis-ci.org/mkenney/docker-composer.svg?branch=master) [![PHP v7](https://img.shields.io/badge/PHP-v7.0.11-8892bf.svg) ![Composer v1](https://img.shields.io/badge/composer-v1.1.2-orange.svg)](https://github.com/mkenney/docker-composer)

* [php5](https://github.com/mkenney/docker-composer/blob/php5/Dockerfile)

  ![build status](https://travis-ci.org/mkenney/docker-composer.svg?branch=php5) [![PHP v5](https://img.shields.io/badge/PHP-v5.6.26-8892bf.svg) ![Composer v1](https://img.shields.io/badge/composer-v1.1.2-orange.svg)](https://github.com/mkenney/docker-composer/tree/php5)

## Synopsys

Essentially, this is just a shell script that manages a very small (34MB) `composer` docker image. The combination of the shell script and docker image allows `composer` to run as either the current user (you) or the owner/group of the current directory.

### Installation

This assumes that you already have [Docker](https://www.docker.com) installed. A running `docker` daemon is required.

Installation is just a matter of putting the [shell script](https://github.com/mkenney/docker-composer/blob/master/bin/composer) somewhere in your path and making it executable. I like to put my scripts in a `bin/` folder in my home directory:
* PHP 5

  `wget -nv -O ~/bin/composer https://raw.githubusercontent.com/mkenney/docker-composer/php5/bin/composer && chmod 0755 ~/bin/composer`

* PHP 7

  `wget -nv -O ~/bin/composer https://raw.githubusercontent.com/mkenney/docker-composer/master/bin/composer && chmod 0755 ~/bin/composer`
* `composer self-update`

  The `self-update` command pulls down the latest docker image and then updates the shell script itself. If you don't have write permissions on the shell script you'll get a permissions error, you can run the self-update command with `sudo` if needed.

## About

The [source repository](https://github.com/mkenney/docker-composer) contains a [shell script](https://github.com/mkenney/docker-composer/blob/php5/bin/composer) that wraps running a docker container to execute [composer](https://getcomposer.org/). The current directory is mounted into `/src` which is the location the `composer` command will run from. In order to facilitate access to private repositories or use public-key authentication, `$HOME/.ssh` is mounted into the container user's home directory. Any authentication issues that come up can most likely be resolved by modifying your `$HOME/.ssh/config` file.

A wrapper script (`/run-as-user`) is provided in the image that attempts to execute composer as the current user. If the `$HOME/.ssh` directory exists on the host, is mounted into the container properly and is not owned by root, then the wrapper script will execute `composer` as a user who's `uid` and `gid` matches those properties on that mounted directory. Otherwise, the wrapper script will execute `composer` as a user who's `uid` and `gid` matches those properties on the mounted `/src` directory (the current directory). This way composer files are installed as either the current user or as the project directory's owner/group instead of root or a random user.

Because this runs out of a Docker container, all files and directories required by your composer command must be available within the current directory. Specifying files or directories from other locations on the system will not work. For example, `--working-dir=/home/user/folder/` would attempt to use the `/home/user/folder/` path inside the container instead of on the host.

## Source repository

* [mkenney/docker-composer](https://github.com/mkenney/docker-composer)

## Docker image

* [mkenney/composer](https://hub.docker.com/r/mkenney/composer/)

Based on [alpine 3.3](https://hub.docker.com/_/alpine/). This is simply a php CLI binary built with a few tools required to run `composer` and to do minimal user management in order to run as a user with the same `uid` and `gid` as the current directory.

## Change log

### 2016-10-28

* Switched to the official PHP alpine images
* Updated shell script for wider compatibility

### 2016-10-07

* updated the software version badges in this document with current information
* updated the `bin/composer` wrapper script
* added a `travis-ci` test to validate [this issue](https://github.com/mkenney/docker-composer/issues/2)

### 2016-09-08

I removed the `root` group from the dev user, it was interfering with the `run-as-user` script

### 2016-09-08

I fixed an upstream error with the script wrapper (the `shadow` package was moved to another repository).

### 2016-07-16

I have re-structured automated the Docker Hub builds, they are no longer triggered by GitHub pushes. Instead they are triggered by a deployment script that is executed on successful `travis-ci` builds. This way, even if builds are failing the image on DockerHub should remain the last stable image at all times.

There may be an issue with API call throttling on the Docker Hub side, if that seems to be happening I'll dig in further.

Please [let me know](https://github.com/mkenney/docker-composer/issues) if you have any problems.

### 2016-06-06

I removed the `as-user` and `composer-wrapper` scripts and put them in a [separate repo](https://github.com/mkenney/docker-scripts/tree/master/container) to reduce duplicate code. [Let me know](https://github.com/mkenney/docker-composer/issues) if you have any trouble.

### 2016-06-03

I modified the `/as-user` command wrapper to check for a valid mounted `~/.ssh` directory. If one exists and it wasn't created by the volume flag in the wrapper script (it's not owned by root) then composer will run as that user, otherwise it will run as the project directory owner.

This fixes a public-key authentication issue when the project directory is not owned by the user running the wrapper script. It will not, however, address issues with the project directory being writable by the current user, that can be solved by fixing the directory permissions on the host and running the script again.

### 2016-06-02

I changed the base image from [mkenney/php-base](https://hub.docker.com/r/mkenney/php-base/) to [alpine](https://hub.docker.com/_/alpine/) to reduce the image size and because Composer doesn't have many dependencies. This reduced the image size from ~330MB to 34MB. Please [let me know](https://github.com/mkenney/docker-composer/issues) if you have any problems.

