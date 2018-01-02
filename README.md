# nci-uMatch-bddtests
BDD Tests for PEDMatch
[![Code Climate](https://codeclimate.com/github/BIAD/nci-uMatch-bddtests/badges/gpa.svg)](https://codeclimate.com/github/BIAD/nci-uMatch-bddtests)
[![Issue Count](https://codeclimate.com/github/BIAD/nci-uMatch-bddtests/badges/issue_count.svg)](https://codeclimate.com/github/BIAD/nci-uMatch-bddtests)

The following cucumber tags are used in the project and have specific purposes.
```
@treatment_arm  - Triggered when nci-treatment-arm* projects are committed.
@patients       - Triggered when nci-patient-* projects are committed.
@rules          - Triggered when rules project is updated
@ui             - Triggered when nci-match-ui project is updated
@end_to_end     - Triggered upon completion of either @treatment_arm, @patients, or @rules AND @ui.   
@seed_data      - Triggered for all the three above projects. These contain tests that deal with creation of data that can and should be used for preparing data. 
```

To run the test using parallel cucumber
```
bundle exec parallel_cucumber features/ -o '-r features/step_definitions/ -r features/support/ -t <tag_name> --format json --out <output location> --expand' -n 2
```
