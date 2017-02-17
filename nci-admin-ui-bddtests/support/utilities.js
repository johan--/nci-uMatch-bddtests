var Utilities = function () {
    
    this.waitForElement = function(element, message) {
        return browser.wait(function(){
            return browser.isElementPresent(element);
        }, 120000, message  + ' is not found or visible.');
    };

    this.checkTitle = function (browser, title) {
    	return expect(browser.getTitle()).to.eventually.equal(title);
    };

}

module.exports = new Utilities();