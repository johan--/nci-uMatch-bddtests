# nci-uMatch-bddtests
BDD Tests for PEDMatch
[![Code Climate](https://codeclimate.com/github/CBIIT/nci-uMatch-bddtests/badges/gpa.svg)](https://codeclimate.com/github/CBIIT/nci-uMatch-bddtests)

The following cucumber tags are used in the project and have specific purposes.
```
@treatment_arm  - Triggered when nci-treatment-arm* projects are committed.
@patients       - Triggered when nci-patient-* projects are committed.
@rules          - Triggered when rules project is updated
@ui             - Triggered when nci-match-ui project is updated
@end_to_end     - Triggered upon completion of either @treatment_arm, @patients, or @rules AND @ui.   
@seed_data      - Triggered for all the three above projects. These contain tests that deal with creation of data that can and should be used for preparing data. 
```
