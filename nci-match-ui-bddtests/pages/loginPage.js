/**
 * Created by raseel.mohamed on 6/3/16
 */

var utils = require ('../support/utilities');
var dashboard = require ('../pages/dashboardPage');

var LoginPage = function() {

    this.title = 'MATCHBox | Login';
    var accessbtn =  element(by.css('button[type="submit"]'));

    this.goToLoginPage = function(){
        browser.get('/#/auth/login', 6000);
        browser.getCurrentUrl().then(function(url){
            if(url !== '/#/auth/login'){
                dashboard.logout;
            }
        });
    };

    this.login = function(username, password) {
        var email =  element(by.id('a0-signin_easy_email'));
        var pass = element(by.id('a0-signin_easy_password'));
        var loginbtn = element(by.buttonText('Access'));
        var previousLoginLink = element(by.linkText('Not your account?'));
        accessbtn.click(); // Clicking NCI-Matchbox button
        browser.sleep(1000);
        browser.isElementPresent(previousLoginLink).then(function (present){
            if (present === true) {
                previousLoginLink.click();
            }
        });
        utils.waitForElement(email, 'Email text area');
        email.sendKeys(username);
        pass.sendKeys(password);
        loginbtn.click();
    };

    this.currentLogin = function() {
        var previousAccountUsed = element(by.css('div[data-strategy="auth0"]'));
        accessbtn.click();
        browser.sleep(1000);
        browser.isElementPresent(previousAccountUsed).then(function (present){
            if (present === true) {
                previousAccountUsed.click();
            };
        });
    };
};

module.exports = new LoginPage();
