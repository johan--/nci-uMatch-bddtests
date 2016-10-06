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
    var dashboardLink = element(by.linkText('Dashboard'));
    var loginPopupPanel = element(by.css('.a0-onestep'));
    var previousAccountUsed = element(by.css('div[data-strategy="auth0"]'));
    var userLoggedin = element(by.css('span.welcome')); // This is the span that says 'Welcome <Username>'

    this.navBarHeading = element(by.css('div.sticky-navbar h2'));

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

    this.login = function(username, password, callback) {
        browser.isElementPresent(userLoggedin).then(function(logIn){
            if (logIn === true) {
                dashboardLink.click().then(function(){
                    utils.waitForElement(element(by.css('.sticky-navbar')), 'Top Menu Bar')
                }).then(callback)
            } else {
                browser.isElementPresent(accessBtn).then(function (buttonPresent) {
                    if (buttonPresent === true) {
                        accessBtn.click().then(function () {
                            utils.waitForElement(loginPopupPanel, 'Login Popup panel').then(function () {
                                browser.isElementPresent(previousAccountUsed).then(function(previousLogin){
                                    if (previousAccountUsed == true){
                                        previousAccountUsed.click().then(function () {
                                            browser.waitForAngular();
                                        }).then(callback);
                                    } else {
                                        utils.waitForElement(email).then(function () {
                                            email.sendKeys(username);
                                            pass.sendKeys(password);
                                            loginbtn.click().then(function () {
                                                browser.waitForAngular();
                                            }).then(callback);
                                        });
                                    }
                                })
                            })
                        })
                    }
                })
            }
        })
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
