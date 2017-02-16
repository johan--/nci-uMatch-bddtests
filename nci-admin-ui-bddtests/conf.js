/**
 * 
 */

exports.config = {
    baseUrl: 'http://localhost:9001',
    capabilities: {
        browserName: 'firefox'
    },
    // seleniumAddress: 'http://localhost:4444/wd/hub',
    specs: [
    'features/AD01_HomePage.feature'
    ],
    framework: 'custom',
    frameworkPath: require.resolve('protractor-cucumber-framework'),
    cucumberOpts: {
        require: [
                    'support/env.js',
                  	'features/step_definitions/*.js'
                  ],
        format: [
        			'pretty',
        			'json:../results/output.json'
				]
    },
    getPageTimeout: 60000,
  	allScriptsTimeout: 100000,
    onPrepare: function (){
    browser.manage().window().setSize(1600, 1000);

    // Disable animations so e2e tests run more quickly
    var disableNgAnimate = function() {
        angular.module('disableNgAnimate', []).run(['$animate',
            function($animate) {
                $animate.enabled(false);
            }
        ]);
    };
    browser.addMockModule('disableNgAnimate', disableNgAnimate);
    }
};
