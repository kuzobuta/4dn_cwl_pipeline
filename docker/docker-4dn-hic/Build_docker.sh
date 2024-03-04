#!/bin/bash
#230704 Install docker images for bug fix
#To build docker & add the new_script 
docker build -t duplexa/4dn-hic:v43.pre .
docker rmi duplexa/4dn-hic:v43
docker tag duplexa/4dn-hic:v43.pre duplexa/4dn-hic:v43
docker rmi duplexa/4dn-hic:v43.pre

