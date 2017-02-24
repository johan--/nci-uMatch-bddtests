var utilities = require ('../support/utilities');

var LoginPage = function() {

    var accessButton = element(by.css('button[ng-click="vm.authService.login()"]'));
    var auth0WidgetContaner = element(by.css('div.auth0-lock-widget-container'));
    var previousAuth0Login = element(by.css('button.auth0-lock-social-button.auth0-lock-social-big-button'));
    var notYourLink = element(by.css('a.auth0-lock-alternative-link'));
    var loginLink = element(by.css('span.auth0-label-submit'));
    var loginEmail = element(by.css('input[type="email"]'));
    var loginPassword = element(by.css('input[type="password"]'));

    this.signInName = element(by.binding('name'));

    this.goToLogin = function(){
        return browser.get('/#/login', 3000);
    }

    this.loginProcess = function(userId, password) {
        accessButton.click().then(function(){          
            browser.waitForAngular();
            auth0WidgetContaner.isPresent().then(function(present) {
                if(present === true){
                    console.log("I can see the auth0WidgetContaner")                    
                } else {
                    console.log("soeme thisn is wrong. the status of prestn is " + present);
                }
            })
        }).then(function(){
            previousAuth0Login.isPresent().then(function(previouslyLoggedIn){
                if ( previouslyLoggedIn === true ) {
                    console.log("I am in the previouslyLoggedIn section")
                    notYourLink.click().then(function(){
                        console.log("I should've clicked the notYourLink by now")
                        browser.waitForAngular().then(function(){
                            utilities.waitForElement(loginLink, "Login text box").then(function(){
                                browser.waitForAngular().then(function(){
                                enterLoginDetails(userId, password)
                                loginLink.click().then(function(){
                                    browser.waitForAngular();
                                    });    
                                });    
                            });
                        })
                    });
                } else {
                    browser.sleep(2000).then(function(){
                        utilities.waitForElement(loginLink, "Login text box").then(function(){
                            enterLoginDetails(userId, password)
                            loginLink.click().then(function(){
                                browser.sleep(5000);
                            });
                        }); 
                    })
                }
            });
        });  


    };

    function enterLoginDetails(userId, password) {
        loginEmail.sendKeys(userId);
        loginPassword.sendKeys(password);
    }

}

module.exports = new LoginPage();