# Terraform config to launch Rancher 1.6

**Note: requires Terraform v0.12**

## Summary

This Terraform setup will:

- Start a droplet running `rancher/server` version specified in `rancher_version`
- Create environments named `cattle` and `kubernetes`
- Start `count_agent_cattle_nodes` of droplets and add them to `cattle` environment
- Start `count_agent_kubernetes_nodes` of droplets and add them to `kubernetes` environment

## Other options

All available options/variables are described in [terraform.tfvars.example](https://github.com/superseb/tf-do-rancher16/blob/master/terraform.tfvars.example).

## How to use

- Clone this repository
- Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
- Run `terraform apply`
