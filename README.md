# Curity Identity Server Customization Recipes

A fast setup for running the common login customization use cases.\
Once understood, similar customizations can be quickly applied to your own system.

## Prerequisites

First ensure that the following components are installed locally:

- A [Docker](https://www.docker.com/) engine
- The [envsubst](https://github.com/a8m/envsubst) tool

## Run the UI Builder

First run the ui-builder tool, with a recipe to customize:

```bash
export RECIPE='basics'
./run-ui-builder.sh
```

This copies the files from the first recipe, then opens the UI builder at the customized page.\
You can see a list of all pages by browsing to the base URL of http://localhost:3000.

## Example Customizations

Some example customizations are provided, in the below link, each of which has its own README file:

| Example | Description |
| ------- | ----------- |
| [Basics](recipes/basics) | Simple customizations to change text, logos and styles | 
| [Email Templates](recipes/email) | Customizations to email text and email templates | 
| [Template Areas](recipes/template-areas) | How to implement different branded customizations per client application |

## Deploy Customizations

Deploy the recipe files to the Curity Identity Server, using a command of this form:

```bash
export RECIPE='basics'
./deploy-idvr.sh
```

Login to the Admin UI if required, using these details, to understand the demo client and its authentication:

- URL: https://localhost:6749/admin
- Username: admin
- Password: Password1

## Run OAuth Tools

Once the system is up and running, use OAuth tools to test deployed customizations.\
Run the desktop version of OAuth Tools and create an environment from this metadata URL:

```text
http://localhost:8443/oauth/v2/oauth-anonymous/.well-known/openid-configuration
```

Then run a code flow with these client settings:

- Client ID: web-client
- Client Secret: Password1
- Scope: openid
