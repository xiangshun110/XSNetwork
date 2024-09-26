#!/bin/sh
#


pod spec lint --verbose XSNetwork.podspec

pod trunk push XSNetwork.podspec --allow-warnings --verbose --use-libraries
# pod repo push master XSNetwork.podspec --allow-warnings