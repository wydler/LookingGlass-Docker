#!/bin/bash

wwwpath=/var/www/html
gitrepo=https://github.com/dwydler/LookingGlass.git
lgversion=2.0.3

if [ -z "$(find $wwwpath -mindepth 1 -print -quit)" ]; then

    git config --global --add safe.directory $wwwpath

    git clone $gitrepo $wwwpath
    git -C $wwwpath checkout $lgversion
fi