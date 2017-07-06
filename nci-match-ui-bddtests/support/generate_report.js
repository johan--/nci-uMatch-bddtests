var reporter = require('cucumber-html-reporter');

var options = {
    theme: 'bootstrap',
    jsonDir: '/home/travis/build/CBIIT/nci-uMatch-bddtests/results/',
    output: '/home/travis/build/CBIIT/nci-uMatch-bddtests/results/cucumber_report.html',
    reportSuiteAsScenarios: true,
    launchReport: false,
    ignoreBadJsonFile:true,
    name:'PEDMatch Cucumber Reports'
};

reporter.generate(options);
