#!/bin/bash

sudo sshfs -o idmap=user,exec,allow_other mikesart@10.10.10.10:/mnt/drive2 /mnt/drive2
