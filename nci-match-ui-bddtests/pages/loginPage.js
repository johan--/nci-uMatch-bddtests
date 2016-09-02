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
            if(url !== browser.baseUrl + '/#/auth/login'){
                dashboard.logout;
            }
        });
    };

    this.login = function (username, password, flag) {
        var email =  element(by.id('a0-signin_easy_email'));
        var pass = element(by.id('a0-signin_easy_password'));
        var loginbtn = element(by.buttonText('Access'));
        var previousLogin = element.all(by.css('div[title="' + username + ' (Auth0)"]'));
        var previousLoginLink =  element(by.linkText('Not your account?'));
        accessBtn.click().then(function () {
            browser.waitForAngular();
        }); // Clicking NCI-Matchbox button

        browser.isElementPresent(previousLoginLink).then(function (present){
            console.log("the value of present = " + present);
            if(flag === true){
                browser.getPageSource().then(function (source) {
                    console.log(source);
                });
            }
            
            if (present === true) {
                console.log("clicking");
                previousLogin.click().then(function () {
                    browser.waitForAngular();
                });
            } else {
                console.log("entering values");

                email.sendKeys(username);
                pass.sendKeys(password);
                loginbtn.click().then(function () {
                    browser.waitForAngular();
                });
            }
        });
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
