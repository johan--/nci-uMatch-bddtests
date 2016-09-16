/**
 * Created by raseel.mohamed on 6/3/16
 */

var utils = require ('../support/utilities');
var dashboard = require ('../pages/dashboardPage');

var LoginPage = function() {

    this.title = 'MATCHBox | Login';
    var accessBtn =  element(by.css('button[ng-click="login()"]'));

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
        var email =  element(by.id('a0-signin_easy_email'));
        var pass = element(by.id('a0-signin_easy_password'));
        var loginbtn = element(by.buttonText('Access'));
        var previousLogin = element(by.css('div[title="' + username + ' (Auth0)"]'));

        browser.isElementPresent(accessBtn).then(function () {
            accessBtn.click().then(function () {
                utils.waitForElement(loginPopupPanel, 'Login Pop up panel').then(function () {
                    browser.isElementPresent(previousLogin).then(function (present) {
                        if(present === true){
                            previousLogin.click().then(callback);
                        } else {
                            email.sendKeys(username);
                            pass.sendKeys(password);
                            loginbtn.click().then(callback);
                        }
                    })
                }, function () {
                    dashboard.goToPageName('dashboard');
                });
            });
        }); // Clicking NCI-Matchbox button
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
