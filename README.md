# digital-ocean-terraform-app
Repository to contain a setup for a App/Database on Digital Ocean

# Digital Ocean Setup

To get started you will need to create a Digital Ocean account if you have not already created one.  You can create an account by following this tutorial:

[Getting Started with DigitalOcean](https://docs.digitalocean.com/products/getting-started/)

[Optional] The next step is only needed if you are working on a team and want to keep your own stuff separate from your teams.  It is recommended if you are working on a project for a job or something.  Teams out of the box do not cost anything.

[Teams Quickstart](https://docs.digitalocean.com/products/teams/quickstart/)

# Project Setup

Once you have yourself setup with an account and optionally a team, you will need a couple of security pieces to get started.  Firstly, you will need to generate an access token which will allow Terraform to interact with the Digital Ocean API.  This is how it manages the resources in Digital Ocean.  Here is their steps to complete that process:

[How to Create a Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)

Create a new file in your repository here under the `/terraform` directory called `dev.auto.tfvars`.  This file will be ignored by `.gitignore` and is a place to store secure configurations that should not be stored in version control.  You will need to come up with another way to share this information across your team.

After you created the file, add your new access token as `do_token`

```s
# dev.auto.tfvars
do_token = "<Your Token Here>"
```

It is recommended that your Terraform State be stored in a global location so it can be maintained by multiple members of your team.  To allow this with Digital Ocean spaces, we need to generate some Spaces API Keys.  You can find the instructions here:

[How to Manage Administrative Access to Spaces](https://docs.digitalocean.com/products/spaces/how-to/manage-access/#access-keys)

After you have created your keys go back to the repo and create another new file called `config.s3.tfbackend`



go to the Spaces page in Digital Ocean and create a new space for your terraform state. 

[How to Create Spaces](https://docs.digitalocean.com/products/spaces/how-to/create/)

Once your space has been created, we will need to take t