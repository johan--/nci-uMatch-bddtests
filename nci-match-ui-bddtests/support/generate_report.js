var reporter = require('cucumber-html-reporter');

var options = {
    theme: 'bootstrap',
    jsonDir: '/home/travis/build/BIAD/nci-uMatch-bddtests/results/',
    output: '/home/travis/build/BIAD/nci-uMatch-bddtests/results/cucumber_report.html',
    reportSuiteAsScenarios: true,
    launchReport: false,
    ignoreBadJsonFile:true,
    name:'PEDMatch Cucumber Reports'
};

reporter.generate(options);
