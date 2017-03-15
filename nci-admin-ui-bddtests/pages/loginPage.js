var utilities = require ('../support/utilities');

var LoginPage = function() {

    var accessButton = element(by.css('button[ng-click="vm.authService.login()"]'));
    var auth0WidgetContaner = element(by.css('div.auth0-lock-widget-container'));
    var previousAuth0Login = element(by.css('button.auth0-lock-social-button.auth0-lock-social-big-button'));
    var notYourLink = element(by.cssContainingText('a.auth0-lock-alternative-link', 'Not your name?'));
    var loginLink = element(by.css('span.auth0-label-submit'));
    var loginEmail = element(by.css('input[type="email"]'));
    var loginPassword = element(by.css('input[type="password"]'));

    var logoutLink = element(by.css('a[ng-click="logout()"]>i.fa-sign-out'));

    this.signInName = element(by.binding('name'));

    this.goToLogin = function(){
        return browser.get('/#/login', 3000).then(function(){
            logoutLink.isPresent().then(function(present){
                if (present == true){
                    logoutLink.click().then(function(){
                        browser.waitForAngular();
                    });
                }
            });
        });
    }

    this.loginProcess = function(userId, password) {
        accessButton.click().then(function(){          
            browser.waitForAngular();
            expect(auth0WidgetContaner.isPresent()).to.eventually.eql(true);
        }).then(function(){
            notYourLink.isPresent().then(function(previouslyLoggedIn){
                if ( previouslyLoggedIn === true ) {
                    console.log("I am in the previouslyLoggedIn section")
                    expect(notYourLink.isPresent()).to.eventually.eql(true);
                    browser.sleep(5000).then(function(){
                        notYourLink.click().then(function(){
                            console.log("I should've clicked the notYourLink by now")
                            browser.waitForAngular().then(function(){
                                utilities.waitForElement(loginLink, "Login text box").then(function(){
                                    browser.waitForAngular().then(function(){
                                        enterLoginDetails(userId, password);
                                        loginLink.click().then(function(){
                                            browser.waitForAngular();
                                        });    
                                    });    
                                });
                            })
                        });    
                    })
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

    this.logout = function() {
        return logoutLink.click();
    }

    function enterLoginDetails(userId, password) {
        loginEmail.sendKeys(userId);
        loginPassword.sendKeys(password);
    }
}

module.exports = new LoginPage();