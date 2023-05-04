# Curity Identity Server Customization Recipes

A quick start to 

## Prerequisites

- Docker
- Java runtime
- envsubst

## Run the UI Builder

First run the ui-builder tool, with a recipe to customize:

```bash
export RECIPE='basics'
./run-ui-builder.sh
```

This copies the files from the `recipes/basics` folder, then opens the UI builder at the customized page.\
You can see a list of all pages by browsing to the base URL of http:/localhost:3000.

## Example Customizations

Some example customizations are provided, in the below link.\
Each link is a folder and you can inspect resources to understand the changes.

| Example | Description |
| ------- | ----------- |
| [Basics](recipes/basics) | Simple customizations to change text, logos, styles and email templates | 
| [Template Areas](recipes/template-areas) | How to implement different branded customizations per client application |

## Deploy Customizations

Deploy customizations with the Curity Identity Server, using a command of this form:

```bash
export RECIPE='basics'
./deploy-idvr.sh
```

Login to the Admin UI if required, using these details:

- URL: https://localhost:6749/admin
- Username: admin
- Password: Password1

## Test Customizations

TODO - describe OAuth tools and the client, with ngrok as one option in the deployment file.