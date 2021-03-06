/**
 * Created by raseel.mohamed on 6/3/16
 */

var rest = require('rest');
var Client = require('node-rest-client').Client;
var req = require('request-promise');
var moment = require('moment');

var Utilities = function () {
    var delay = {
        afterLogin: 500,
        afterPatientLoad: 3000
    };

    this.delay = delay;

    var nextButtonString = 'li[ng-if="::directionLinks"][ng-class="{disabled: noNext()||ngDisabled}"]'

    var client = new Client();

    this.checkTitle = function (browser, title) {
        return expect(browser.getTitle()).to.eventually.equal(title);
    };

    this.expectValue = function (el, expected, msg) {
        return el.getText().then(function (val) {
            return expect(val).to.eql(expected, msg + ' Mismatch');
        });
    };

    this.waitForElement = function (element, message) {
        return browser.wait(function () {
            return browser.isElementPresent(element)
        }, 120000, message + ' element is not visible.');
    };

    this.checkPresence = function (css_locator) {
        expect(browser.isElementPresent(element(by.css(css_locator)))).to.eventually.be.true;
    };

    /**
     * This function returns the element that has the provided text as the heading.
     * @param  {String} headingName The complete text of the heading ot the tab
     * @return {Element}             Element that corresponds to the heading
     */
    this.getSubTabHeadingElement = function(headingName){
        var returnElement = element(by.cssContainingText('uib-tab-heading', headingName));
        return returnElement
    };

    /** This function checks for the breadcrumb path that is provided. It returns the expectation's result.
     * @param path [String] in the format string1 / string2 /string3 and so forth
     *
     */
    this.checkBreadcrumb = function (path) {
        var pathArray = path.split(' / ');
        var breadcrumb = element.all(by.css('ol.breadcrumb li'));

        expect(breadcrumb.count()).to.eventually.equal(pathArray.length);

        for (var i = 0; i < pathArray.length; i++) {
            var expected = pathArray[i];

            expect(breadcrumb.get(i).getText()).to.eventually.include(expected);
        }
    };

    this.checkTableHeaders = function (elementArray, expectedArray) {
        expect(elementArray.count()).to.eventually.equal(expectedArray.length);
        for (var i = 0; i < expectedArray.length; i++) {
            var expected = expectedArray[i];
            expect(elementArray.get(i).getText()).to.eventually.equal(expected);
        }
    };


    this.checkElementArray = function (elementArray, expectedValues) {
        for (var i = 0; i < expectedValues.length; i++) {
            expect(elementArray.get(i).getText()).to.eventually.equal(expectedValues[i]);
        }
    };

    this.checkInclusiveElementArray = function (elementArray, expectedValues) {
        for (var i = 0; i < expectedValues.length; i++) {
            expect(elementArray.get(i).getText()).to.eventually.include(expectedValues[i]);
        }
    };

    this.checkIfElementListInExpectedArray = function (elemList, expectedArray) {
        elemList.getText().then(function (text) {
            for (var i = 0; i < text.length; i++) {
                expect(text).to.include(expectedArray[i]);
            }
            expect(text.length).to.eql(expectedArray.length);
        })
    };

    this.clickElementArray = function (elementArray, index) {
        elementArray.get(index).click();
    };

    /** This function is used to convert null values into dashes
     *
      */
    this.dashifyIfEmpty = function (strVal) {
        var retVal;
        if (strVal == null || strVal === undefined) {
            retVal = '-'
        } else {
            retVal = strVal.toString();
        }
        return retVal;
    };

    this.zerofyIfEmpty = function (strVal) {
        var retVal;
        if (strVal == null || strVal === undefined) {
            retVal = 0
        } else {
            retVal = strVal
        }
        return retVal;
    };

    this.dashifyIfZero = function (strVal) {
        var retVal;
        if (parseInt(strVal) === 0){
            return '-'
        }
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
     * @param elem = element under test. This element ideally should be the parent of <a> tag.
     */
    this.checkCosmicLink = function (elem) {
        elem.getText().then(function (linkText) {
            if (linkText.match(/COSM/)) {
                var regexp = /\bCOSM(\d{1,})\b/;
                var catchAll = regexp.exec(linkText);
                // catchAll[1] is the second element in the matched group that are numbers.
                var expectedString = 'http://grch37-cancer.sanger.ac.uk/cosmic/mutation/overview?id=' + catchAll[1] ;
                expect(elem.all(by.css('a')).get(0).getAttribute('href')).to.eventually.eql(expectedString);
            }
        })
    };

    this.checkCOSMText = function(text, parentElement) {
        var elem = parentElement.element(by.cssContainingText('a', text));
        var regexp = /\bCOSM(\d{1,})\b/;
        var catchAll = regexp.exec(linkText);
        var expectedString = 'http://grch37-cancer.sanger.ac.uk/cosmic/mutation/overview?id=' + catchAll[1] ;
        expect(elem.isPresent).to.eventually.eql(true);
        expect(elem.getAttribute('href')).to.eventually.eql(expectedString)
    };

    /**
     * Check whether the check box under scrutiny is selected or not.
     * @param {element} [elem] [Checkbox element whose status is being checked]
     * @param {boolean} [selectionStatus] [boolean that shows the status of the checkbox under scrutiny]
     */
    this.checkCheckBoxStatus = function (elem, selectionStatus) {
        expect(elem.isEnabled()).to.eventually.eql(selectionStatus);
    };

    /** Verify that the link exists and is a valid one to the gene
     * @param elem = element under test. This element ideally should be the direct parent of <a> tag.
     * http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=PIK3CA
     */
    this.checkGeneLink = function (elem) {
        elem.getText().then(function (linkText) {
            if (linkText.match(/\w/)) {
                var link;
                if(linkText === 'BAF47') {
                    link = 'SMARCB1';
                } else if (linkText === 'BRG1') {
                    link = 'SMARCA4';
                } else {
                    link = linkText
                }
                expect(elem.element(by.css('a')).getAttribute('href'))
                    .to
                    .eventually
                    .eql('http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=' + link, "Gene Link Mismatch");
            } else {
                // console.log(linkText);
                expect(elem.all(by.css('a')).count()).to.eventually.eql(0)
            }
        })
    };

    this.checkGeneText = function (text, parentElement) {
        var elem = parentElement.element(by.cssContainingText('a', text));
        elem.getText().then(function (completeLink) {
            if (completeLink.match(/GENE: /)) {
                var linkText = completeLink.slice (6)
                console.log(linkText)

                if (linkText.match (/\w/)) {
                    var link;
                    if (linkText === 'BAF47') {
                        link = 'SMARCB1';
                    } else if (linkText === 'BRG1') {
                        link = 'SMARCA4';
                    } else {
                        link = linkText
                    }
                    expect (elem.isPresent ())
                        .to
                        .eventually.eql (true);
                    expect (elem.getAttribute ('href'))
                        .to
                        .eventually
                        .eql ('http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=' + link, "Gene Link Mismatch");
                }
            }
        });
    };

    this.checkCOSFLink = function (elem) {
        elem.getText().then(function (linkText) {
            console.log(linkText);
            if (linkText.match(/COSF/)) {
                var regexp = /COSF(\d{1,})/;
                var catchAll = regexp.exec(linkText);
                var expectedString = 'http://grch37-cancer.sanger.ac.uk/cosmic/fusion/summary?id=' + catchAll[1];
                expect(elem.all(by.css('a')).get(0).getAttribute('href')).to.eventually.eql(expectedString);
            } else {
                expect(elem.all(by.css('a')).count()).to.eventually.eql(0)
            }
        })
    };

    this.checkCOSFText = function(text, parentElement) {
        var regexp = /COSF(\d{1,})/;
        var catchAll = regexp.exec(text);
        var elem = parentElement.element(by.cssContainingText('a', catchAll[0]));
        expect(elem.isPresent()).to.eventually.eql(true);
        var expectedString = 'http://grch37-cancer.sanger.ac.uk/cosmic/fusion/summary?id=' + catchAll[1];
        expect(elem.getAttribute('href')).to.eventually.eql(expectedString);
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
            // console.log(attributeArray);
            expect(attributeArray).to.include(value);
        });
    };

    this.checkAttribute = function(element, attribute, value) {
        return element.getAttribute(attribute).then(function(attribute) {
            expect(attribute).to.eql(value);
        });
    };

    /**
     * This function is a generic post request. Header and body of the request should be a hash
     * Usage:
     * utils.postRequest('https://ncimatch.auth0.com/oauth/ro', data, function(responseData){
     *     console.log(responseData)
     * });
     * @param url: [String] Required. Fully qualified URL
     * @param body: [Object] Optional. The object used as request body
     * @param fn: [Function] Callback
     */
    this.postRequest = function (url, body, fn) {
        var reqBody = body !== undefined ? body : {}
        // console.log(reqBody);
        var args = {
            data: reqBody,
            headers: { "content-type": "application/json" }
        };
        // console.log("Post URL: " + url);
        client.registerMethod("post", url, "POST");

        client.methods.post(args, function (dt, response) {
            // console.log(dt);
            fn(dt);
        });
    };

    /** This is a Get Request that builds the URL based on the baseUrl, service and the url to navigate to.
     *
     * @param {string} [service] should be a member of ['patient', 'treatment', 'ion']
     * @param {string} [parameters] forms the rest of the URL
     * @param {Object} [headerObject] Authorization headerObject used to send request [Optional]
     */
    this.getRequestWithService = function (service, parameters, headerObject) {
        var url = tierBasedURI(service) + parameters;
        var options = {
            uri: url,
            method: 'GET',
            headers: {},
            json: true
        };

        if (browser.params.useAuth0) {
            options['headers'] = headerObject !== undefined ? headerObject : { 'Authorization': browser.sysToken }
        }

        return req(options).then(function (resp) {
            return resp;
        }).catch(function (err) {
            console.log(err);
        });
    };

    this.putRequestWithService = function (service, uri, bodyParams, headerParams) {
        var headers = headerParams === undefined ? {} : headerParams;
        var url = tierBasedURI(service) + uri;
        var baseHeader = {
            "Content-Type": "application/json",
            "Accept": "application/json"
        };

        var reqHeader = Object.assign(baseHeader, headers)

        var options = {
            uri: url,
            method: 'PUT',
            headers: reqHeader,
            body: bodyParams,
            json: true
        };

        return req(options).then(function (response) {
            return response;
        }).catch(function (err) {
            console.log(err);
        })
    };

    /** This function returns the JSON response for api call. The url has to be provided
        url [String] Required: the url of the api. This call is made against the
        baseURL
     */
    this.callApi = function (service, param) {
        var self = this;

        var callUrl = tierBasedURI(service) + param;
        return {
            get: call,
            entity: getResponse
        };

        function getResponse() {
            return self._entity;
        }

        function call() {
            // console.log(callUrl);
            return rest(callUrl).then(
                function (response) {
                    self._entity = response.entity;
                }, function (error) {
                    console.log(error);
                }
            );
        }
    };

    this.putApi = function (service, param, jsonBody) {
        // var client = new Client();
        var callUrl = tierBasedURI(service) + param;

        var args = {
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            data: jsonBody
        };
        // console.log(callUrl);

        return client.put(callUrl, args, function (data, response) {
            console.log(response);
        });
    };

    this.getAllCounts = function (tableElement, rowElement) {
        var counter = 0;
        var rows = tableElement.all(by.css(rowElement));
        rows.count().then(function (c) {
            console.log(c);
        })
        // do {

        //   getCurrentCount(rows).then(function(c){
        //     counter = counter + c;
        //   });
        //     // counter = counter + getCurrentCount(rows);
        //     // console.log("counter reads now" + counter);
        //     // clickNextButton(tableElement);
        //    }
        // while (isLastPage(tableElement) !== true)
    };

    function getCurrentCount(rowElement) {
        var currentCount
        return rowElement.count().then(function (cnt) {
            console.log(cnt);
            currentCount = cnt;
            return currentCount
        })
    };

    function clickNextButton(tableElement) {
        tableElement.element(by.css(nextButtonString)).click().then(function () {
            browser.waitForAngular();
        })
    };

    function isLastPage(tableElement) {
        var nextButton = tableElement.element(by.css(nextButtonString));
        nextButton.getAttribute('class').then(function (attributes) {
            if (attributeArray.match('disabled')) {
                return true;
            } else {
                return false;
            }
        })
    };

    function tierBasedURI(service) {
        var uri;
        var baseUrl = browser.baseUrl;
        var portMap = {
            'patient': '10240',
            'treatment': '10235',
            'ion': '5000'
        }

        var port = portMap[service];

        if (baseUrl.match('localhost')) {
            uri = browser.baseUrl.slice(0, -5) + ':' + port;
        } else {
            uri = browser.baseUrl;
        }

        return uri;
    }

    this.checkIfLink = function (row, index) {
        var data = row.all(by.css('td')).get(index).all(by.css('span')).get(0);
        data.getAttribute('ng-if').then(function (attrib) {
            if (attrib === 'vm.isValidLink()') {
                data.all(by.css('a')).get(0).isPresent().then(function (status) {
                    expect(status).to.eql(true);
                });
            } else if (attrib === '!vm.isValidLink()') {
                data.all(by.css('a')).get(0).isPresent().then(function (status) {
                    expect(status).to.eql(false);
                });
            }
        });
    };

    this.moveAndCheckElement = function (webElementCollection, index, expectedValue) {
        browser.actions().mouseMove(webElementCollection.get(index)).perform().then(function () {
            expect(webElementCollection.get(index).getText()).to.eventually.eql(expectedValue);
        }, function (error) {
            console.log(error);
            console.log('Could not move to element at ' + index + ' with expected value ' + expectedValue);
        })
    };

    this.selectFromDropDown = function (dropDownCSSSelectorString, value) {
        return element(by.cssContainingText(dropDownCSSSelectorString, value)).click()
            .then(function () {
                browser.waitForAngular();
            });
    };

    function buildUrl(id, api) {
        var url = browser.baseUrl;
        if (url.match('localhost')) {
            url = url.slice(0, -5);
        }

        var portMap = {
            'patients': 10240,
            'treatmentArms': 10235
        };

        var port = portMap[api];
        return url + ':' + port + '/' + api + '/' + id;
    }

    this.getJSONifiedDetails = function (response) {
        return JSON.parse(response);
    };

    /**
     * This function will take the element description of the cell and compare it with the expected.
     * Converts all undefined values or empty values into zero
     * @param elem - list of elements in the row. In case of a row the input will be row.all(<selection criteria>)
     * @param expected
     */
    this.checkValueInTable = function (elem, expected) {
        elem.get(0).getText().then(function (column_value) {
            expect(column_value.toString()).to.equal(expected.toString());
        })
    };

    this.checkValueInPubMed = function (elem, expected) {
        elem.get(0).getText().then(function (column_value) {
            var actual = column_value.toString().split('\n').join(',');
            expect(actual).to.equal(expected.toString());
        })
    };

    this.returnValidUserCredentials = function (role) {
        var user_credentials = [];
        var email;
        var password;
        var name;

        switch (role) {
            case 'VR_Sender_mda':
                email = process.env.MDA_VARIANT_REPORT_SENDER_AUTH0_USERNAME;
                password = process.env.MDA_VARIANT_REPORT_SENDER_AUTH0_PASSWORD;
                name = 'mda-vr-sdr';
                break;

            case 'VR_Sender_mocha':
                email = process.env.MOCHA_VARIANT_REPORT_SENDER_AUTH0_USERNAME;
                password = process.env.MOCHA_VARIANT_REPORT_SENDER_AUTH0_PASSWORD;
                name = 'mocha-vr-sdr';
                break;

            case 'VR_Sender_dartmouth':
                email = process.env.DARTMOUTH_VARIANT_REPORT_SENDER_AUTH0_USERNAME;
                password = process.env.DARTMOUTH_VARIANT_REPORT_SENDER_AUTH0_PASSWORD;
                name = 'dartmouth-vr-sdr';
                break;

            case 'VR_Reviewer_mda':
                email = process.env.MDA_VARIANT_REPORT_REVIEWER_AUTH0_USERNAME;
                password = process.env.MDA_VARIANT_REPORT_REVIEWER_AUTH0_PASSWORD;
                name = 'mda-vr-rvr';
                break;

            case 'VR_Reviewer_mocha':
                email = process.env.MOCHA_VARIANT_REPORT_REVIEWER_AUTH0_USERNAME;
                password = process.env.MOCHA_VARIANT_REPORT_REVIEWER_AUTH0_PASSWORD;
                name = 'mocha-vr-rvr';
                break;

            case 'VR_Reviewer_dartmouth':
                email = process.env.DARTMOUTH_VARIANT_REPORT_REVIEWER_AUTH0_USERNAME;
                password = process.env.DARTMOUTH_VARIANT_REPORT_REVIEWER_AUTH0_PASSWORD;
                name = 'dartmouth-vr-rvr';
                break;

            case 'AR_Reviewer':
                email = process.env.ASSIGNMENT_REPORT_REVIEWER_AUTH0_USERNAME;
                password = process.env.ASSIGNMENT_REPORT_REVIEWER_AUTH0_PASSWORD;
                name = 'ar-vr';
                break;

            case 'admin':
                email = process.env.ADMIN_AUTH0_USERNAME;
                password = process.env.ADMIN_AUTH0_PASSWORD;
                name = 'admin';
                break;

            case 'system':
                email = process.env.SYSTEM_AUTH0_USERNAME;
                password = process.env.SYSTEM_AUTH0_PASSWORD;
                name = 'sy';
                break;

            case 'read_only':
                email = process.env.NCI_MATCH_READONLY_AUTH0_USERNAME;
                password = process.env.NCI_MATCH_READONLY_AUTH0_PASSWORD;
                name = 'readonly';
                break;

        }

        user_credentials.push(email, password, name);
        return user_credentials;
    };

    this.setUploadedFile = function (fieldName, fieldValue, getFileNm, errorMessage) {
        fieldName.sendKeys(fieldValue);
        if (fieldValue == '[object Object]') {
            var store = fieldName.getAttribute('value');
            getFileNm.then(function (value) {
                console.log(errorMessage + ' ' + value + " Value entered");
                expect(store).to.eventually.equal(value);
            });
        }
        else {
            console.log(errorMessage + ' ' + fieldValue + " Value entered");
            expect(fieldName.getAttribute('value')).to.eventually.equal((getFileNm));
        }
    };

    this.getDataByRepeater = function(tableElement, repeaterSelector, callback) {
        var rows = tableElement.all(by.repeater(repeaterSelector));

        var dataArray = [];
        var rowData;

        return rows.each(function (row, rowIndex) {
            row.all(by.tagName('td')).each(function(c, colIndex){
                c.getText().then(function (t) {
                    rowData = dataArray[rowIndex];
                    if (!rowData) {
                        rowData = [];
                        dataArray[rowIndex] = rowData;
                    }
                    rowData[colIndex] = t;
                });
            });
        })
        .then(function() {
             callback(dataArray);
        });
    };

    this.checkElementArrayisGene = function(elementArray){
        var compare = function(elem){
            return elem.getText().then(function (linkText) {
                if (linkText !== '-'){
                    return elem.element(by.css('a')).getAttribute('href').then(function(href){
                        return elem.getText().then(function(geneName){
                            expect(href).to.eql('http://grch37-cancer.sanger.ac.uk/cosmic/gene/overview?ln=' + geneName );
                        });
                    })
                }
            })
        };
        return elementArray.count().then(function(cnt){
            expect(cnt).to.be.above(0, 'No Gene element found');
            for(var i = 0; i < cnt; i++){
                compare(elementArray.get(i));
            }
        })
    };

    this.checkElementArrayisCosf = function(elementArray){
        var compare = function(elem){
            return elem.getText().then(function(geneName){
                if (geneName.match(/COSF/)) {
                    var startPos = geneName.indexOf ('COSF') + 4;
                    var stopPos  = geneName.indexOf ('_') === -1 ? geneName.length : geneName.indexOf ('_');
                    var slice    = geneName.slice (startPos, stopPos);
                    return elem.element(by.css('a')).getAttribute('href').then(function(href){
                        expect(href).to.eql('http://grch37-cancer.sanger.ac.uk/cosmic/fusion/summary?id=' + slice );
                    })
                } else {
                    return;
                }
            })
        };

        return elementArray.count().then(function(cnt){
            for(var i = 0; i < cnt; i++){
                compare(elementArray.get(i));
            }
        })
    };

    this.stripStudyId = function(taId){
        if(taId.match(/APEC1621(-)?/)){
            var len = taId.match(/APEC1621-/)? 9 : 8;
            return taId.slice(len);
        } else {
            return taId;
        }
    };

    this.checkExpectation = function(el, expected, message) {
        var expectedValue = expected;
        if (expected === null || expected === undefined) {
            expectedValue =  '-'
        }
        el.getText().then(function(actualText){
            expect(actualText).to.eql(expectedValue.toString(), message);
        });
    };

    this.returnFormattedDate = function(dateString) {
        return moment.utc(dateString).utc().format('LLL');
    };

    this.round = function (value, decimals) {
        if(value === null || value === undefined){
            return null
        } else {
            return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
        }
    };

    this.integerize = function(numString){
        if (numString === null || numString === undefined){
            return null
        } else {
            return Math.round(numString).toString();
        }
    };

    this.checkColor = function(el, status) {
        var green = ['POSITIVE', 'CONFIRMED'];
        var red = ['INDETERMINATE', 'REJECTED'];
        var orange = ['NEGATIVE', 'PENDING'];
        var color = 'color';

        if (this.includes(green, status)){
            color = 'color: green;';
        } else if (this.includes(red, status)) {
            color = 'color: red;';
        } else if (this.includes(orange, status)) {
            color = 'color: orange;';
        };

        this.checkAttribute(el, 'style', color);
    };

    this.includes = function(arr, elem) {
        if(arr.indexOf(elem) >= 0) {
            return true;
        } else {
            return false;
        }
    };

    this.extractLinks  = function(text, pattern){
        var linkArray = [];
        if (pattern === 'GENE'){
            linkArray = text.match(/GENE: \w.+?\b/g);
            if (linkArray === null){
                linkArray = [];
            }
        } else {
            var words = text.split(' ');
            for ( var i = 0; i < words.length; i++ ){
                if (words[i].match(pattern)){
                    linkArray.push(words[i]);
                }
            }
        }
        return linkArray
    };

    this.checkPubMedLink = function(el){
        var checkLink = function(testLink, index) {
            if (testLink.match(/^\d+(\n)?$/)){
                index = (typeof index !== 'undefined') ?  index : 0;
                var pubMedLinks = el.all(by.repeater('id in vm.publicMedIds'));
                expect(pubMedLinks.count()).to.eventually.be.greaterThan(0);
                expect(el.all(by.css('a')).get(index).getAttribute('href')).to.eventually.include('ncbi.nlm.nih.gov/pubmed/?term=' + testLink);
            } else {
                expect(el.element(by.css('a')).isPresent()).to.eventually.eql(false);
            }
        };
        el.getText().then(function (link) {
            if (link.match(/\n/)){
                var linkArr = link.split('\n');
                for(var i = 0 ; i < linkArr.length; i ++){
                    checkLink(linkArr[i], i);
                }
            } else {
                checkLink(link);
            }
        });
    };

    this.getMoiCount = function(response) {
        var result = {moi: 0, confirmedMoi: 0};

        var variants = ['snv_indels', 'copy_number_variants', 'gene_fusions'];
        for(var i = 0 ;i < variants.length; i ++ ){
            var variant = response[variants[i]];
            if (variant.length > 0) {
                console.log(variants[i])
                result.moi = result.moi + variant.length;
                var confirmed = variant.filter(function (v) {
                    return v.confirmed === true;
                });
                result.confirmedMoi = result.confirmedMoi + confirmed.length;
            }
        }
        return result;
    }
};

module.exports = new Utilities();
