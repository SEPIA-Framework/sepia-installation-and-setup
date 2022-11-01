# SEPIA STT-Server

The SEPIA STT-Server is an offline speech-recognition server that can be installed centrally next to your SEPIA-Home stack or individually on each DIY client.  
  
Check out the repository to learn more: https://github.com/SEPIA-Framework/sepia-stt-server/

## Quick-start with Docker

If you've Docker installed you can use the included script to quick-start a default STT-Server: `bash run-docker-container.sh`.  

## Install w/o Docker

If you don't want to use Docker check the info at: https://github.com/SEPIA-Framework/sepia-stt-server/  
There is an install script you can try:
```
wget https://raw.githubusercontent.com/SEPIA-Framework/sepia-stt-server/master/scripts/install.sh
bash install.sh -h
```

## Nginx Setup

If you run the STT-Server next to your SEPIA-Home stack check your Nginx proxy settings inside `/etc/nginx/sites-enabled/sepia-fw-...` to enable STT routes.
