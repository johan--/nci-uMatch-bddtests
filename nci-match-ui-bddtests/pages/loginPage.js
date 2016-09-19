/**
 * Created by raseel.mohamed on 6/3/16
 */

var utils = require ('../support/utilities');
var dashboard = require ('../pages/dashboardPage');

var LoginPage = function() {

    this.title = 'MATCHBox | Login';
    var email =  element(by.id('a0-signin_easy_email'));
    var pass = element(by.id('a0-signin_easy_password'));
    var loginbtn = element(by.buttonText('Access'));
    var accessBtn = element(by.css('div[ng-controller="AuthController"]')).element(by.css('button[ng-click="login()"]'));
    var oldUserLink = element(by.linkText('Not your account?'));

    this.goToLoginPage = function(){
        browser.get('/#/auth/login', 6000).then(function () {
            browser.waitForAngular();
        });
        browser.getCurrentUrl().then(function(url){
            if(url !== (browser.baseUrl + '/#/auth/login')){
                dashboard.logout();
            }
        });
    };

    this.login = function (username, password, callback) {
        var loginPopupPanel = element(by.css('.a0-onestep'));
        var previousLogin = element(by.css('div[title="' + username + ' (Auth0)"]'));

        accessBtn.isPresent().then(function () {
            accessBtn.click().then(function () {
                utils.waitForElement(loginPopupPanel, 'Login Pop up panel').then(function () {
                    browser.isElementPresent(oldUserLink).then(function (present) {
                        if (present == false) {
                            email.sendKeys(username);
                            pass.sendKeys(password);
                            loginbtn.click().then(function () {
                                browser.waitForAngular()
                            }).then(callback)
                        } else {
                            oldUserLink.click().then(function () {
                                email.sendKeys(username);
                                pass.sendKeys(password);
                                loginbtn.click().then(function () {
                                    browser.waitForAngular()
                                }).then(callback)
                            })
                        }

                    })
                })
            })
        },function (error) {
            console.log('Failed to find Access button');
            console.log(error);
        }).then(callback);
    };

    this.currentLogin = function() {
        var previousAccountUsed = element(by.css('div[data-strategy="auth0"]'));
        accessBtn.click();
        browser.sleep(1000);
        browser.isElementPresent(previousAccountUsed).then(function (present){
            if (present === true) {
                previousAccountUsed.click();
            };
        });
    };
};

module.exports = new LoginPage();
