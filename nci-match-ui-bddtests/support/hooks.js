var Hooks = function () {
    var fs = require('fs');

    this.BeforeScenario = function(scenario, next) {
              
    };

    this.After(function(scenario, callback){
        if (scenario.isFailed()){
            browser.takeScreenShot().then(function (png) {
                scenario.attach(png, 'image/png', callback);
            }, function(err) {
                   callback(err);
            });
        } else {
            callback();
        }
    });


    
};
