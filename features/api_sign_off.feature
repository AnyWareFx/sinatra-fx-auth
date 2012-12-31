Feature: API Sign Off

  Scenario: API Sign Off

    Given I have a User Profile
    And   I sign on with valid credentials
    And   I am online
    When  the App signs me off
    Then  I am offline