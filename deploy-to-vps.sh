#!/bin/bash

rm -rf ./www-bk && git clone --depth=1 https://github.com/lijun401338/lijun401338.github.io.git www-bk

rm -rf ./www && mv www-bk www
