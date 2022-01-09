# SEPIA STT-Server

The SEPIA STT-Server is an offline speech-recognition server that can be installed centrally next to your SEPIA-Home stack or individually on each DIY client.  
  
Check out the repository to learn more: https://github.com/SEPIA-Framework/sepia-stt-server/

## Quick-start with Docker

If you've Docker installed you can use the included script to quick-start a default STT-Server: `bash run-docker-container.sh`.  

## Nginx Setup

If you run the STT-Server next to your SEPIA-Home stack check your Nginx proxy settings inside `/etc/nginx/sites-enabled/sepia-fw-...` to enable STT routes.
