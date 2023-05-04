# Customization Direction

See [Jira PME-1034](https://curity.atlassian.net/browse/PME-1034) for work in progress details.\
These are the main objectives:

- Provide resources commonly requested for customers and prospects, and also educate them
- Demonstrate great extensibility, better than other IAM systems
- Make it easy to add new recipes requested by professinal services in future

## Deliverables

- This quick start repository, to create a good initial developer experience
- A HOWTO to follow on from the current [UI Builder Tutorial](https://curity.io/resources/learn/customize-look-and-feel/)
- One or more videos on the recipes used

## Recipes

The recipes should have three main levels, to demonstrate these technical areas:

- Basics
- Template Areas
- Deeper Extensibility

## Basics

- Customized text, which cannot be done in the Admin UI
- Customized logo
- Some CSS changes for a basic theme
- Email template updates
- Other, to be defined, and discussed with Urban + PMEs

## Template Areas

- Perhaps the same changes as a template area
- Deal with string IDs, as suggested by Jacob
- Other, to be defined, and discussed with Urban + PMEs

## Extensibility

This might come as a later releasem, but I'd like to do something related to registration and custom data.\
My [draft document](https://docs.google.com/document/d/1cYaSE1vTech62-MVQnVJyxiHz3ml64riQLPrjeaUVnY/edit#) has some early thoughts.

## Technical Setup

Enable PMEs to work on customization recipes in a productive manner.\
It is a little fiddly to identify the location for each asset and to implement the deployment.

## TODO

1. Run a deployment, and make logo inside and image bigger.
   Get Admin UI results in configuration and apply them

2. Get client working with desktop OAuth tools.
   Make an ngrok internet setup part of the deployment, but optional

3. Read up on differences between custom.properties and individual message files

4. Same changes as template areas

5. Page with screenshots for each recipe