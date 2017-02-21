var Utilities = function () {
    
    this.waitForElement = function(element, message) {
        return browser.wait(function(){
            return browser.isElementPresent(element);
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
}

module.exports = new Utilities();