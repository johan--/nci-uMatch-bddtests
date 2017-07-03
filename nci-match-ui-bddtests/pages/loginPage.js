/**
 * Created by raseel.mohamed on 6/3/16
 */

var utils = require('../support/utilities');
var dashboard = require('../pages/dashboardPage');

var LoginPage = function() {

    this.title = 'MATCHBox | Login';
    var email =  element(by.id('a0-signin_easy_email'));
    var pass = element(by.id('a0-signin_easy_password'));
    var loginbtn = element(by.buttonText('Access'));
    var accessBtn = element(by.css('div[ng-controller="AuthController"]')).element(by.css('button[ng-click="login()"]'));
    var previousUser = element(by.css('.a0-zocial.a0-block.a0-guest'));
    var notYourAccount = element(by.css('.a0-centered.a0-all'));
    var oldUserLink = element(by.xpath(".//*[@id='a0-onestep']/div[2]/div/form/div[1]/a"));
    var dashboardLink = element(by.linkText('Dashboard'));
    var loginPopupPanel = element(by.css('.a0-onestep'));
    var previousAccountUsed = element(by.css('div[data-strategy="auth0"]'));
    var userLoggedin = element(by.css('span.welcome')); // This is the span that says 'Welcome <Username>'
    this.navBarHeading = element(by.css('div.sticky-navbar h2'));
    this.logoutButton = element(by.css('a[ng-click="logout()"]'));

    this.goToLoginPage = function(){
        browser.get('/#/auth/login', 1000).then(function () {
            browser.waitForAngular();
        });
        browser.getCurrentUrl().then(function(url){
            if(url !== (browser.baseUrl + '/#/auth/login')){
                dashboard.logout();
            }
        });
    };

    this.login = function(username, password, callback) {
        browser.isElementPresent(userLoggedin).then(function(loggedIn){
            if (loggedIn === true) {
                logoutUser().then(function(){
                    browser.get('/#/auth/login', 1000).then(function() {
                        clickAccessAndLogin(username, password)
                    });
                }).then(callback);
            } else {
                clickAccessAndLogin(username, password).then(callback);
            }
        });
    };

    this.beLoggedIn = function(username, password, name) {
        return browser.get('/#/auth/login', 1000).then(function(){
            browser.waitForAngular();
        }).then(function(){
            return browser.getCurrentUrl().then(function(url){
                return element(by.css('.user-name')).isPresent().then(function(present){
                    if (present === false){
                        return clickAccessAndLogin(username, password);
                    } else {
                        element(by.css('.user-name')).getText().then(function(nm){
                            if (nm.includes(name)){
                                // console.log("Same user continuing")
                                return browser.get('/#/dashboard', 1000);
                            } else {
                                // console.log("Different User Logging out")
                                return element(by.css('a[ng-click="logout()"]')).click().then(function(){
                                    return browser.get('/#/auth/login', 1000).then(function() {
                                        return clickAccessAndLogin(username, password)
                                    });
                                })
                            }
                        })
                    }
                })
            });
        });
    };

    function logoutUser(){
        return logoutLink.click().then(function(){
            browser.waitForAngular();
        })
    }

    function clickAccessAndLogin(username, password) {
        return accessBtn.click().then(function(){
            browser.sleep(1000).then(function(){
                browser.isElementPresent(previousAccountUsed).then(function(previouslyLoggedIn){
                    if (previouslyLoggedIn === true) {
                        //if the previous user is same as current user click sign in
                        previousAccountUsed.getText().then(function(previousUserId){
                            if (previousUserId === username){
                                previousAccountUsed.click().then(function(){

                                });
                            } else{
                                browser.sleep(500).then(function(){
                                    notYourAccount.click().then(function(){
                                    enterDetails(username, password);
                                    });
                                });
                            }
                        });
                    } else {
                        enterDetails(username, password);
                    }
                })
            })
        })
    }

    function enterDetails(username, password) {
        var data = {
            "client_id": process.env.AUTH0_CLIENT_ID ,
            "username": username,
            "password": password,
            "grant_type": 'password',
            "scope": 'openid email roles',
            "connection":  process.env.AUTH0_DATABASE
        };

        var sysdata = {
            "client_id": process.env.AUTH0_CLIENT_ID ,
            "username": process.env.SYSTEM_AUTH0_USERNAME,
            "password": process.env.SYSTEM_AUTH0_PASSWORD,
            "grant_type": 'password',
            "scope": 'openid email roles',
            "connection":  process.env.AUTH0_DATABASE
        };
        return utils.waitForElement(email, 'Email Text box').then(function () {
            utils.postRequest('https://ncimatch.auth0.com/oauth/ro', data, function(responseData){
                // console.log(responseData.id_token);
                browser.idToken = 'Bearer ' + responseData.id_token;
            });

            utils.postRequest('https://ncimatch.auth0.com/oauth/ro', sysdata, function(responseData){
                browser.sysToken = 'Bearer ' + responseData.id_token;
            });

            email.sendKeys(username);
            pass.sendKeys(password);
            loginbtn.click();
        });
    }

    this.currentLogin = function() {
        var previousAccountUsed = element(by.css('div[data-strategy="auth0"]'));
        accessBtn.click();
        browser.sleep(1000);
        browser.isElementPresent(previousAccountUsed).then(function (present){
            if (present === true) {
                previousAccountUsed.click();
            }
        });
    };
};

module.exports = new LoginPage();
