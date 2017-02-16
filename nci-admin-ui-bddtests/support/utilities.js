var Utilities = function () {
    
    this.waitForElement = function(element, message) {
        return browser.wait(function(){
            return browser.isElementPresent(element);
        }, 120000, message  + ' is not found or visible.');
    }

}

module.exports = new Utilities();