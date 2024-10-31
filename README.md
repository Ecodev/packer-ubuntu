# Packer template for Ecodev cloud

This is a [packer](https://www.packer.io/) template to build a box for Ecodev cloud and publish it on
https://portal.cloud.hashicorp.com/vagrant/discover/Ecodev. It is based on [chef/bento](https://github.com/chef/bento).

To build locally:

1. Create a new key on for the service principal "Box uploader" on https://portal.cloud.hashicorp.com/ >
   `Access control (IAM)` > `Service principals` > `box-uploader` > `Keys` > `Generate key`
2. Set the key as the environment variable `HCP_CLIENT_ID` and `HCP_CLIENT_SECRET`
3. Install packer plugins:

```sh
packer init .
```

4. Build the box and automatically upload to https://portal.cloud.hashicorp.com/vagrant/discover/Ecodev:

```sh
packer build .
```
