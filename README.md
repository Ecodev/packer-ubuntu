# Packer template for Ecodev cloud

This is a [packer](https://www.packer.io/) template to build a box for Ecodev cloud and publish it on
https://app.vagrantup.com/Ecodev. It is based on [chef/bento](https://github.com/chef/bento).

To build locally:

1. Create a token on https://app.vagrantup.com/settings/security
2. Set the token as the environment variable `VAGRANTCLOUD_TOKEN`
3. Run:
```sh
packer build template.json
```
