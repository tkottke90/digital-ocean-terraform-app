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

Record your personal access token temporarily 

It is recommended that your Terraform State be stored in a global location so it can be maintained by multiple members of your team.  To allow this with Digital Ocean spaces, we need to generate some Spaces API Keys.  You can find the instructions here:

[How to Manage Administrative Access to Spaces](https://docs.digitalocean.com/products/spaces/how-to/manage-access/#access-keys)

Record the access key/secret, we will need them later on to setup the project.  We will also need a space setup ahead of time, go to the Spaces page in Digital Ocean and create a new space for your terraform state. 

[How to Create Spaces](https://docs.digitalocean.com/products/spaces/how-to/create/)

Finally run the setup script in this repository which will prompt you for the information you created in order to connect to digital ocean