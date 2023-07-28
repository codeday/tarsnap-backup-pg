#!/bin/bash
echo $TARSNAP_KEYFILE | base64 --decode > /tarsnap/key
tarsnap --fsck
supercronic ./crontab
