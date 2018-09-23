[![docker-badges.webbedlam.com](http://docker-badges.webbedlam.com/image/mkenney/composer)](https://hub.docker.com/r/mkenney/composer/)

# composer

[![MIT License](https://img.shields.io/github/license/mkenney/docker-composer.svg)](https://github.com/mkenney/docker-composer/blob/master/LICENSE) [![stability-mature](https://img.shields.io/badge/stability-mature-008000.svg)](https://github.com/mkenney/software-guides/blob/master/STABILITY-BADGES.md#mature) [![Build status](https://travis-ci.org/mkenney/docker-composer.svg?branch=master)](https://travis-ci.org/mkenney/docker-composer) [![Github issues](https://img.shields.io/github/issues-raw/mkenney/docker-composer.svg)](https://github.com/mkenney/docker-composer/issues) [![Github pull requests](https://img.shields.io/github/issues-pr/mkenney/docker-composer.svg)](https://github.com/mkenney/docker-composer/pulls)

Portable `composer` dev and build tool.

### Tagged Images

Images are tagged according to the installed PHP version.Please [let me know](https://github.com/mkenney/docker-composer/issues) if you need a particular version tagged.

#### [`latest` Dockerfile](https://github.com/mkenney/docker-composer/blob/master/latest/Dockerfile)

Based on [`php:7-cli-alpine`](https://hub.docker.com/r/library/php/). This image should be considered under development and may not be as stable as versioned images.

#### [`php7` Dockerfile](https://github.com/mkenney/docker-composer/blob/master/php7/Dockerfile)

Based on [`php:7-cli-alpine`](https://hub.docker.com/r/library/php/).

#### [`php7.0` Dockerfile](https://github.com/mkenney/docker-composer/blob/master/php7.0/Dockerfile)

Based on [`php:7.0-cli-alpine`](https://hub.docker.com/r/library/php/). This is the last version with mcrypt available.

#### [`php5` Dockerfile](https://github.com/mkenney/docker-composer/blob/master/php5/Dockerfile)

Based on [`php:5-cli-alpine`](https://hub.docker.com/r/library/php/).

### Installation

Essentially, this is just a [shell script](https://github.com/mkenney/docker-composer/tree/master/bin/composer) that manages a [Composer](https://getcomposer.org/) docker image. The docker image includes a script ([`run-as-user`](https://github.com/mkenney/docker-scripts/tree/master/container)) that allows commands to write files as either the current user or the owner/group of the current directory, which the shell scripts take advantage of to make sure files are created with your preferred permissions rather than root.

### About

The [source repository](https://github.com/mkenney/docker-composer) contains a [shell script](https://github.com/mkenney/docker-composer/blob/php5/bin/composer) that wraps running a docker container to execute [composer](https://getcomposer.org/). The current directory is mounted into `/src` which is the location the `composer` command will run from. In order to facilitate access to private repositories or use public-key authentication, `$HOME/.ssh` is mounted into the container user's home directory. Any authentication issues that come up can most likely be resolved by modifying your `$HOME/.ssh/config` file.

A wrapper script (`/run-as-user`) is provided in the image that attempts to execute composer as the current user. If the `$HOME/.ssh` directory exists on the host, is mounted into the container properly and is not owned by root, then the wrapper script will execute `composer` as a user who's `uid` and `gid` matches those properties on that mounted directory. Otherwise, the wrapper script will execute `composer` as a user who's `uid` and `gid` matches those properties on the mounted `/src` directory (the current directory). This way composer files are installed as either the current user or as the project directory's owner/group instead of root or a random user.

Because this runs out of a Docker container, all files and directories required by your composer command must be available within the current directory. Specifying files or directories from other locations on the system will not work. For example, `--working-dir=/home/user/folder/` would attempt to use the `/home/user/folder/` path inside the container instead of on the host.

#### Images & Wrapper Scripts

This assumes that you already have [Docker](https://www.docker.com) installed. A running `docker` daemon is required.

Installation is just a matter of putting the [shell script](https://github.com/mkenney/docker-composer/blob/master/bin/composer) somewhere in your path and making it executable. I like to put my scripts in a `bin/` folder in my home directory:

```
$ wget -nv -O ~/bin/composer https://raw.githubusercontent.com/mkenney/docker-composer/master/bin/composer
$ chmod 0755 ~/bin/composer
```

The [wrapper script](https://github.com/mkenney/docker-composer/blob/master/bin/composer) defaults to the `php7` tag, but specifying a different tag is easy. You can define the image tag you want to use in your environment which will set the default (you probably want to define this in your `.bashrc` or similar profile script):
```txt
export DOCKER_COMPOSER_TAG=php5
```

or you can easily specify it at runtime whenever necessary, for example:
```txt
$ DOCKER_COMPOSER_TAG=php5 composer install
```

If you would to see like additional modules, tags, and/or wrapper scripts added to this project please feel free to [create an issue](https://github.com/mkenney/docker-composer/issues) or [open a pull request](https://github.com/mkenney/docker-composer/pull/new/master).

* `composer self-update`

  The `self-update` command pulls down the latest docker image _matching the current image tag_ and updates the shell script itself. If you don't have write permissions on the shell script you'll get a permissions error, you can run the self-update command with `sudo` if needed.
