/**
 * Created by raseel.mohamed on 6/3/16
 */

var rest = require('rest');


var Utilities = function() {

    this.checkTitle = function(browser, title) {
        return expect(browser.getTitle()).to.eventually.equal(title);
    };

    this.checkElementValue = function(css_locator, expected) {
        expect(element(by.css(css_locator)).getText()).to.eventually.equal(expected);
    };

    this.waitForElement = function(element, message) {
        browser.wait(function (){
           return browser.isElementPresent(element)
        }, 10000, message + ' element is not visible.');
    };

    this.checkPresence = function(css_locator) {
        expect(browser.isElementPresent(element(by.css(css_locator)))).to.eventually.be.true;
    };

    /** This function checks for the breadcrumb path that is provided. It returns the expectation's result.
     * @param path [String] in the format string1 / string2 /string3 and so forth
     *
     */
    this.checkBreadcrumb = function(path) {
        var pathArray = path.split(' / ');
        var breadcrumb = element.all(by.css('ol.breadcrumb li'));

        expect(breadcrumb.count()).to.eventually.equal(pathArray.length);

        for (var i = 0; i < pathArray.length; i++){
            var expected = pathArray[i];

            expect(breadcrumb.get(i).getText()).to.eventually.equal(expected);
        }
    };

    this.checkTableHeaders = function (elementArray, expectedArray) {
        expect(elementArray.count()).to.eventually.equal(expectedArray.length);
        for(var i = 0; i < expectedArray.length; i++){
            var expected = expectedArray[i];
            expect(elementArray.get(i).getText()).to.eventually.equal(expected);
        }
    };


    this.checkElementArray = function(elementArray, expectedValues){
        for(var i = 0; i < expectedValues.length ; i++){
            expect(elementArray.get(i).getText()).to.eventually.equal(expectedValues[i]);
        }
    };

    this.clickElementArray = function(elementArray, index){
        elementArray.get(index).click();
    };

    /**
     * Gets all the values for the attributes and checks if the value provided is set.
     * @param element
     * @param attribute
     * @param value
     */
    this.checkElementIncludesAttribute = function (element, attribute, value) {
        element.getAttribute(attribute).then(function (allAttributes) {
            var attributeArray = allAttributes.split(' ');
            expect(attributeArray).to.include(value);
        });
    };

    /** This function returns a hash of details available from the Treatment Arm Based on the id provided
     * @author: Rick Zakharov, Raseel Mohamed
     * @param id [String] id 
     * @param api [String] the api being called. 
     * returns [String]
     */

    this.callApiForDetails = function (id, api ){
        var routeUrl = buildUrl(id, api);
        
        var self = this;
        return{
            get: get,
            entity: getEntity
        };
        var _entity;
        function getEntity(){
            return self._entity;
        }
        function get(){
            return rest(routeUrl).then(
                function (response) {
                    self._entity = response.entity;
                },
                function (error) {
                    console.log(error);
                }
            )
        }
    };

    function buildUrl(id, api) {
        if (browser.baseUrl.match('localhost')){
            var url = browser.baseUrl.slice(0,-4);
        }

        var portMap = {
            'patients' : 10240,
            'treatmentArms': 10235
        };

        var port = portMap[api];
        return url + port + '/' + api +'/' + id ;
    }

    this.getTreatmentArmIdDetails = function (response){
        var treatmentArm =  JSON.parse(response);
        return treatmentArm;
    };

    /**
     * This function will take the element description of the cell and compare it with the expected.
     * Converts all undefined values or empty values into zero
     * @param elem - list of elements in the row. In case of a row the input will be row.all(<selection criteria>)
     * @param expected
     */
    this.checkValueInTable = function(elem, expected){
        if (expected === undefined){
            expected = 0;
        }
        elem.get(0).getText().then(function (column_value) {
            if ((column_value === '-') || (column_value === '')){
                column_value = 0;
            }
            expect(column_value).to.equal(expected);
        })
    }
};

module.exports = new Utilities();
