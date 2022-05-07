# SEPIA-Home - Automatic Setup

This folder contains the YAML config file to run SEPIA's setup process unattended/automatically.  
  
How to:
- Copy or rename the `template.yaml` to `config.yaml` and modify the content as required
- Run the setup script with the flag `--automatic` (setup menu option 1b)
- Check `results.log` after the setup finished to obtain random passwords etc.

## YAML File

Sections:
- `tasks`: Add the tasks to run during setup. Keep the default setting unless you want to change an existing server.
- `users`: Add information about the users created during 'accounts' task. If you use `<random>` for passwords check the results.log later.
- `dns`: Add information required during DNS tasks like 'duckdns' (non-default) to setup for example the SEPIA DuckDNS process

## Docker Container Support

If you use the official Docker container it will look for the (empty) file `docker-setup` in this folder and start the automatic setup process.  
After the setup finishes successfully the file will be deleted automatically to prevent further setup runs.
You can simply create a new file if required. In fact every file starting with `docker-setup...` will work!
