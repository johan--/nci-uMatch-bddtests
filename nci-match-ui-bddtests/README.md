# NCI MATCH UI BDD TESTS

This Project houses all the tests for the NCI Match UI. The application under test (AUT) is built on Angular framework. This test project is being built with Protractor using the Cucumber framework. 

## Project Setup
Please make sure that the following are installed before running the project. 

1. Install node

   ```
   brew install node
   ```

2. Install the following npm packages globally.

   ```
   $ npm install -g protractor
   $ npm install -g cucumber
   $ npm install -g grunt-cli
   $ npm install -g phantomjs
   ```

   This should also install `Selenium Webdriver` and thus `webdriver-manager`
   Run the following commands in the terminal to make sure they are properly installed
    
   ```
   $ protractor --version
   $ cucumber.js --version
   ```

:exclamation: This projects needs protractor version 3.3.0, and cucumber 2.0.0 or higher.
  
3. Run npm install to get all modules added to `package.json`
   ```
   $ npm install
   ```

## Executing Tests
Make sure that the webdriver is up to date and running
```
webdriver-manager update
webdriver-manager start
```

In the terminal go to the project root and run
For all tests:
```
protractor config.js
```
Using tags:
```
Run tests tagged with @tagname1 and @tagname2
protractor config.js --cucumberOpts.tags='@tagname1, @tagname2'

Run tests tagged with @tagname1, but avoid @tagname2
protractor config.js --cucumberOpts.tags='@tagname1' --cucumberOpts.tags='~@tagname2' 
```

## Implementing Auth0 Integration
The default is *NO* AUTH0 integration
if we need to enable AUTH0 this is the way to run the protractor. 
```
protractor config.js [cucumber options] --params.useAuth0 true
```

## Additional configuration changes. 
The configuration settings present in the config.js can be altered at runtime by providing parameters. 

For example if you need to override the baseUrl being used to something else, you can use the following commmand.
 ```
 protractor config.js --baseUrl='www.example.org'
 ```

### Contacts
- Raseel Mohamed: raseel.mohamed@nih.gov
- Vivek Ramani: vivek.ramani@nih.gov
