# Optimage: rport

This image should be mounted read-only with writable mounts chmod g+w $data_gid group

## Information

[Project Homepage](www.rport.io)
[Project Sourcecode](https://github.com/cloudradar-monitoring/rport)
[Project Documentation](https://oss.rport.io/docs)

## Why?

* Simple.
* Complete.

## FAQ

* Can you implement feature xyz?
* Submit a pull request.

## Buildtime arguments

Refer to Dockerfile.

## Runtime arguments

Any environment variables prefixed with RPORT_CFG will be translated into an argument to rportd (e.g. RPORT_CFG_URL=foo -> --url foo).
