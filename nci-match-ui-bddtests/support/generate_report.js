var reporter = require('cucumber-html-reporter');

var options = {
    theme: 'bootstrap',
    jsonDir: '/tmp/ion_result/',
    output: '/tmp/ion_result/cucumber_report',
    reportSuiteAsScenarios: true,
    launchReport: false,
    ignoreBadJsonFile:true,
    name:'PEDMatch Cucumber Reports'
};

reporter.generate(options);