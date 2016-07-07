var fs = require('fs');


module.exports = function() {

    this.After(function (scenario, callback) {
        if (scenario.isFailed()) {
            browser.takeScreenshot().then(function (png) {
                var img = new Buffer(png, 'base64').toString('binary');
                scenario.attach(img, 'image/png', callback);
            }, function(err){
                callback(err);
            });
        }
        else {
            callback();
        }
    });

    this.AfterFeatures(function () {
        var Reporter = require('cucumber-html-report');
        var options = {
            source: process.env.WORKSPACE + '/nci-uMatch-bddtests/nci-match-ui-bddtests/results/result.json',
            dest:   process.env.WORKSPACE + '/nci-uMatch-bddtests/nci-match-ui-bddtests/results/reports',
            name:   'report.html',
            title:  'Results in html'
        };

        var report = new Reporter(options);
        report.createReport();
    })
};
