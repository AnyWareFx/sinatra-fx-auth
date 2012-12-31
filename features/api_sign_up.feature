Feature: API Sign Up

  Scenario: API Valid Sign Up

    When the App signs me up with valid credentials
    Then the App receives a 201 response code
    And  the App receives an Auth Token


  Scenario: API Sign Up with Duplicate Email

    When the App tries to sign me up with a duplicate email
    Then the App receives a 409 response code
    And  the App receives a duplicate email error



  Scenario: API Sign Up with Invalid Email

    When the App tries to sign me up with an invalid email address
    Then the App receives a 412 response code
    And  the App receive an invalid email error


  # TODO Return 422 for semantic error?
  Scenario: API Sign Up with Missing Email

    When the App tries to sign me up with a missing email address
    Then the App receives a 412 response code
    And  the App receives a missing email error



  Scenario: API Sign Up with Missing Password

    When the App tries to sign me up with a missing password
    Then the App receives a 412 response code
    And  the App receives a missing password error
