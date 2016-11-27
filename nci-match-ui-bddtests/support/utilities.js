/**
 * Created by raseel.mohamed on 6/3/16
 */

var rest = require('rest');
var Client = require('node-rest-client').Client;


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
        }, 15000, message + ' element is not visible.');
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

    this.checkInclusiveElementArray = function(elementArray, expectedValues){
        for(var i = 0; i < expectedValues.length ; i++){
            expect(elementArray.get(i).getText()).to.eventually.include(expectedValues[i]);
        }
    };

    this.checkIfElementListInExpectedArray = function(elemList, expectedArray){
        elemList.getText().then(function (text) {
            for(var i = 0; i < text.length; i++){
                expect(text).to.include(expectedArray[i]);
            }
            expect(text.length).to.eql(expectedArray.length);
        })
    };

    this.clickElementArray = function(elementArray, index){
        elementArray.get(index).click();
    };

    /** This function is used to convert null values into dashes
     *
      */
    this.dashifyIfEmpty = function(strVal){
        var retVal;
        if ( strVal == null || strVal === undefined ) {
            retVal = '-'
        }else {
            retVal = strVal
        }
        return retVal;
    };

    this.zerofyIfEmpty = function(strVal){
        var retVal;
        if ( strVal == null || strVal === undefined ) {
            retVal = 0
        }else {
            retVal = strVal
        }
        return retVal;
    };

    /** finds the index of the element that matches css and the end text that is provided.
     * @param elem = list of all the elements that match the locator
     * @param name = The text of the element.
     */
    this.getElementIndex = function (elem, name) {
        return elem.getText().then(function (nameArray) {
            return nameArray.indexOf(name)
        })
    };

    /** Verified that if the element has cosmicID value then it should be a link and should point to the proper href value
     * @param elem = element under test. This element ideally should be the direct parent of <a> tag.
     */
    this.checkCosmicLink = function (elem) {
        elem.getText().then(function (linkText) {
            if (linkText.match(/COSM/)){
                var id = linkText.substr('COSM'.length)
                expect(elem.all(by.css('a')).get(0).getAttribute('href')).to.eventually.eql('http://grch37-cancer.sanger.ac.uk/cosmic/mutation/overview?id=' + id)
            } else {
                expect(elem.all(by.css('a')).count()).to.eventually.eql(0)
            }
        })
    };

    /** Verify that the link exists and is a valid one to the gene
     * @param elem = element under test. This element ideally should be the direct parent of <a> tag.
     * http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=PIK3CA
     */
    this.checkGeneLink = function(elem) {
        elem.getText().then(function (linkText) {
            if (linkText.match(/\w/)){
                expect(elem.all(by.css('a')).get(0).getAttribute('href')).to.eventually.eql('http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=' + linkText);
            } else {
                console.log(linkText);
                expect(elem.all(by.css('a')).count()).to.eventually.eql(0)
            }
        })
    };

    this.checkCOSFLink = function(elem) {
        elem.getText().then(function (linkText) {
            if (linkText.match(/COSF/)){
                var id = linkText.substr('COSF'.length);
                expect(elem.all(by.css('a')).get(0).getAttribute('href')).to.eventually.eql('http://grch37-cancer.sanger.ac.uk/cosmic/mutation/overview?id=' + id)
            } else {
                expect(elem.all(by.css('a')).count()).to.eventually.eql(0)
            }
        })
    }

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
            'treatment' : '10235',
            'ion'       : '5000'
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
            console.log(callUrl)
            return rest(callUrl).then(
                function (response) {
                    self._entity = response.entity;
                }, function(error) {
                    console.log(error);
                }
            )
        }
    };

    this.putApi = function(service, param, jsonBody){
        var client = new Client();
        var portMap = {
            'patient'   : '10240',
            'treatment' : '10235',
            'ion'       : '5000'
        };
        var port = portMap[service];
        var baseUrl = browser.baseUrl;

        if (baseUrl.match('localhost')) {
            uri = browser.baseUrl.slice(0, -5) + ':' + port;
        }else {
            uri = browser.baseUrl;
        }

        var callUrl = uri + param;

        var args = {
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            data: jsonBody
        };
        console.log(callUrl)

        return client.put(callUrl, args, function (data, response) {
            console.log(response);
        })
    };

    this.checkIfLink = function(row, index){
        var data = row.all(by.css('td')).get(index).all(by.css('span')).get(0);
        data.getAttribute('ng-if').then(function (attrib) {
            if (attrib === 'vm.isValidLink()'){
                data.all(by.css('a')).get(0).isPresent().then(function (status) {
                    expect(status).to.eql(true);
                });
            } else if (attrib === '!vm.isValidLink()'){
                data.all(by.css('a')).get(0).isPresent().then(function (status) {
                    expect(status).to.eql(false);
                });
            }
        });
    };

    this.moveAndCheckElement = function(webElementCollection, index, expectedValue){
        browser.actions().mouseMove(webElementCollection.get(index)).perform().then(function () {
            expect(webElementCollection.get(index).getText()).to.eventually.eql(expectedValue);
        }, function (error) {
            console.log(error);
            console.log('Could not move to element at ' + index + ' with expected value ' + expectedValue);
        })
    };

    this.selectFromDropDown = function(tablePanel, value){
        var dropdown = tablePanel.all(by.model('paginationOptions.itemsPerPage')).get(0);
        dropdown.all(by.cssContainingText('option', value)).get(0).click();
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
