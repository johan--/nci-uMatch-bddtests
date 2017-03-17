/**
 * This is where all the before and after hooks live. 
 * 
 */

var fs = require('fs');


module.exports = function() {

    /**
     * Failure in a scenarion should trigger a screen shot to be included in the results json file
     * @param  {Scenario} scenario        [description]
     * @return callback to the next scenario
     */
    this.After(function (scenario, callback) {
        if (scenario.isFailed()) {
            browser.takeScreenshot().then(function (png) {
                var img = new Buffer(png, 'base64');
                scenario.attach(img, 'image/png', callback);
            }, function(err){
                callback(err);
            });
        }
        else {
            callback();
        }
    });

    /**
     * Setting up the envoronment values based on the HOSTNAME in the conf.js file. 
     * 
     */
    this.Before(function (callback) {
        browser.sleep(40).then(function(){
            if(process.env.ADMIN_UI_HOSTNAME === 'http://localhost:9001') {
                process.env.DYNAMO_ENDPOINT = 'http://localhost:8000';
            } else {
                process.env.DYNAMO_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com';
            }            
        }).then(callback);
    });
};