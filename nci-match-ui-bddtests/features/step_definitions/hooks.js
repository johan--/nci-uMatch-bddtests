var fs = require('fs');


module.exports = function() {

    this.After(function (scenario, callback) {
        if (scenario.isFailed()) {
            console.log(':1 # Scenario:', scenario.getUri());
            fs.appendFile('flake.txt', scenario.getName() + "\n");
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

      //this.AfterFeatures(function () {
      //    var Reporter = require('cucumber-html-report');
      //    var options = {
      //        source: process.cwd() + '/../results/output.json',
      //        dest:   '/../results',
      //        name:   'report.html',
      //        title:  'Results in html'
      //    };
      //
      //    var report = new Reporter(options);
      //    report.createReport();
      //})
};
