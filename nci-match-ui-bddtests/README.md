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
In the terminal go to the project root and run
```
protractor config.js
```

### Contacts
- Raseel Mohamed: raseel.mohamed@nih.gov
- Vivek Ramani: vivek.ramani@nih.gov
