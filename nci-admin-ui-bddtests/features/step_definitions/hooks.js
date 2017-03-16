var fs = require('fs');


module.exports = function() {

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

    this.Before(function (callback) {
        console.log('IN before');
        browser.sleep(40).then(function(){
            if(process.env.ADMIN_UI_HOSTNAME === 'http://localhost:9001') {
                process.env.DYNAMO_ENDPOINT = 'http://localhost:8000'
            } else {
                process.env.DYNAMO_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
            }            
        }).then(callback);
    });
};