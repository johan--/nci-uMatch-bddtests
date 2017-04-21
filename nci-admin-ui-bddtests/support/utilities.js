var req = require('request-promise');

var Utilities = function () {

    this.waitForElement = function(elem, message) {
        return browser.wait(function(){
            return browser.isElementPresent(elem);
        }, 120000, message  + ' is not found or visible.');
    };

    this.checkTitle = function (browser, title) {
    	return expect(browser.getTitle()).to.eventually.equal(title);
    };

    /**
     * Gets all the values for the attributes and checks if the value provided is set.
     * @param element
     * @param attribute
     * @param value
     */
    this.checkElementIncludesAttribute = function (element, attribute, value) {
        return element.getAttribute(attribute).then(function (allAttributes) {
            var attributeArray = allAttributes.split(' ');
            expect(attributeArray).to.include(value);
        });
    };

    this.getIndexOfElement = function(elementList, text) {
        return elementList.count().then(function(cnt){
            for (var i=0; i < cnt; i++) {
                return elementList.get(i).getText().then(function(elemText){
                    if (elemText === text) {
                        return i;
                    }
                })
            }
        })
    }

    this.getIdToken = function(){
        var data = {
            "client_id": process.env.AUTH0_CLIENT_ID ,
            "username": process.env.ADMIN_UI_AUTH0_USERNAME,
            "password": process.env.ADMIN_UI_AUTH0_PASSWORD,
            "grant_type": 'password',
            "scope": 'openid email roles',
            "connection":  process.env.AUTH0_DATABASE
        };

        var options = {
            method: 'POST',
            uri: 'https://ncimatch.auth0.com/oauth/ro',
            body: data,
            json: true,
            headers: { "content-type": "application/json" }
        }

        return req(options).then(function(body){
            return body.id_token;
        }).catch(function(err){
            console.log(err);
            return;
        })
    }

    this.getTAsFromTreatmentArm = function(idToken, url){
        console.log('Get URL: ' + url);
        var options = {
            uri: url,
            method: 'GET',
            headers: {'Authorization': `Bearer ${idToken}`},
            json: true
        };

        return req(options).then(function (resp) {
            return resp;
        }).catch(function (err) {
            console.log(err);
        });
    }
}

module.exports = new Utilities();
