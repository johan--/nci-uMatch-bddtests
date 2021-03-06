/**
 * Created by raseel.mohamed some time ago in March 2017
 */
exports.config = {
    baseUrl: process.env.ADMIN_UI_HOSTNAME,
    // directConnect: true,
    capabilities: {
        browserName: 'firefox'
    },
    specs: [
    'features/AD01_HomePage.feature',
    'features/AD02_Upload.feature',
    'features/AD03_Wizard.feature',
    'features/AD04_Editor.feature'
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
    browser.manage().window().setSize(3200, 1800);

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
