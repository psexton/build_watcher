Feature: Updating listeners

  Here's an overview of the entire process:

    1. ask the serial device for the number of projects it is tracking
    2. for each project:
       1. ask the serial device for its codefumes.com authentication information
       2. get the project's build status from codefumes.com
       3. send the status to the serial device

  Scenario: sending the project's build status
    Given the following projects are registered in the serial device:
      | public_key | private_key                              |
      | aaaa       | fR8slfR8slfR8slfR8slfR8slfR8slfR8slfR8sl |
      | bbbb       | fR8slfR8slfR8slfR8slfR8slfR8slfR8slfR8sl |
      | cccc       | fR8slfR8slfR8slfR8slfR8slfR8slfR8slfR8sl |
    And the projects have the following build statuses:
      | public_key | build_status |
      | aaaa       | running      |
      | bbbb       | passing      |
      | cccc       | failed       |
    When I run the update_listeners
    Then it should pass the following messages to the serial device:
      | message |
      | stuff1  |
      | stuff2  |
      | stuff3  |
