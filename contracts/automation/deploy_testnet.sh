#!/bin/bash

set -eEou

cd ../

forge script ./script/DeployTestnet.s.sol --legacy --broadcast --slow -vvvv
