#!/bin/bash
cd /home/ec2-user/app
node src/app.js > app.out.log 2> app.err.log < /dev/null &