var reporter = require('cucumber-html-reporter');

var options = {
    theme: 'bootstrap',
    jsonDir: '~/build/CBIIT/nci-uMatch-bddtests/results/',
    output: '~/build/CBIIT/nci-uMatch-bddtests/results/cucumber_report.html',
    reportSuiteAsScenarios: true,
    launchReport: false
};

reporter.generate(options);