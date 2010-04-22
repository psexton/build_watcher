Feature: Updating listeners

  Here's an overview of the entire process:

    1. ask the serial device for the number of projects it is tracking
    2. for each project:
       1. ask the serial device for its codefumes.com authentication information
       2. get the project's build status from codefumes.com
       3. send the status to the serial device

  Scenario: sending the project's build status
    Given there are 3 projects set up at Codefumes.com
    And the projects have the following build statuses:
      | build_status |
      | running      |
      | successful   |
      | failed       |
    And the projects are all being tracked on the serial device
    When I run update_listeners
    Then it broadcasts the project build status via the serial port for each project
    And the projects are removed
