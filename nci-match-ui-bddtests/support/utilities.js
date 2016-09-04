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
        return browser.wait(function (){
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

            expect(breadcrumb.get(i).getText()).to.eventually.include(expected);
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

    /** This function is used to convert null values into dashes
     *
      */
    this.dashifyIfEmpty = function(strVal){
        var retVal;
        if ( strVal == null ) {
            retVal = '-'
        }else {
            retVal = strVal
        }
        return retVal;
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

    /** This function returns the JSON response for api call. The url has to be provided
        url [String] Required: the url of the api. This call is made against the
        baseURL
     */
    this.callApi = function(service, param) {
        var self = this;
        var _entity;
        var uri;
        var port;
        var portMap = {
            'patient'   : '10240',
            'treatment' : '10235'
        };
        port = portMap[service];

        var baseUrl = browser.baseUrl;

        if (baseUrl.match('localhost')) {
            uri = browser.baseUrl.slice(0, -5) + ':' + port;
        }else {
            uri = browser.baseUrl;
        }

        var callUrl = uri + param;
        return{
            get: call,
            entity: getResponse
        };

        function getResponse(){
            return self._entity;
        }

        function call(){
            return rest(callUrl).then(
                function (response) {
                    self._entity = response.entity;
                }, function(error) {
                    console.log(error);
                }
            )
        }
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
        var url = browser.baseUrl;
        if (url.match('localhost')){
            url = url.slice(0,-5);
        }

        var portMap = {
            'patients' : 10240,
            'treatmentArms': 10235
        };

        var port = portMap[api];
        return url + ':' + port + '/' + api +'/' + id ;
    }

    this.getJSONifiedDetails = function (response){
        return JSON.parse(response);
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
    };

    this.getFirstNameFromEmail = function (email) {
        return email.split('.')[0];
    };

    this.capitalize = function (text){
        return text.toLocaleLowerCase().replace(/\b./, function(f) {return f.toLocaleUpperCase();})
    };
};

module.exports = new Utilities();
