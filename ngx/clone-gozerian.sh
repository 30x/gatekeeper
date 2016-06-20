#!/usr/bin/env bash
git clone git@github.com:30x/lua-gozerian.git gitlua
rm -rf lua
mkdir lua
mv gitlua/lib lua/lib
rm -rf gitlua
