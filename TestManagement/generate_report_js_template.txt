var reporter = require('cucumber-html-reporter');

var options = {
    theme: 'bootstrap',
    jsonDir: '**json_folder**',
    output: '**json_folder**/**html_name**',
    reportSuiteAsScenarios: true,
    launchReport: false,
    ignoreBadJsonFile:true,
    name:'**report_name**'
};

reporter.generate(options);