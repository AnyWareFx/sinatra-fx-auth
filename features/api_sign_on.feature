Feature: API Sign On

  Scenario: API Valid Credentials

    Given I have a User Profile
    And   I am offline
    When  the App signs me on with valid credentials
    Then  the App receives a 201 response code
    And   the App receives an Auth Token
#    And   I am online



  Scenario: API Invalid Credentials

    Given I have a User Profile
    And   I am offline
    When  the App tries to sign me on with invalid credentials
    Then  the App receives a 401 response code
    And   the App receives an Invalid User error
#    And   I am offline



  Scenario: API Locked Account

    Given I have a User Profile
    And   I am offline
    When  the App tries to sign me on with invalid credentials
    And   the App tries to sign me on with invalid credentials
    And   the App tries to sign me on with invalid credentials
    Then  the App receives a 423 response code
    And   the App receives a Locked User error
#    And   I am locked out



  Scenario: API Locked Valid Sign On Attempt

    Given I have a Locked User Profile
    When  the App signs me on with valid credentials
    Then  the App receives a 423 response code
    And   the App receives a Locked User error
#    And   I am locked out



  Scenario: API Locked Invalid Sign On Attempt

    Given I have a Locked User Profile
    When  the App tries to sign me on with invalid credentials
    Then  the App receives a 423 response code
    And   the App receives a Locked User error
#    And   I am locked out



  Scenario: API Online Valid Sign On Attempt

    Given I have a User Profile
    When  the App signs me on with valid credentials
    And   the App signs me on with valid credentials
    Then  the App receives a 200 response code
    And   the App receives an Auth Token
#    And   I am online


  # TODO FIX ME - How should this respond?
  Scenario: API Online Invalid Sign On Attempt

    Given I have a User Profile
    When  the App signs me on with valid credentials
    And   the App tries to sign me on with invalid credentials
    Then  the App receives a 401 response code
#    And   I am online
