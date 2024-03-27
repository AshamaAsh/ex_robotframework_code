*** Settings ***
#Documentation    Suite description
Library     SeleniumLibrary        timeout=10      implicit_wait=10
Library         DateTime
Library         RequestsLibrary
Library         Collections
Resource     ../../Keywords/login/kw_login.robot
#Test Teardown     Close Browser

*** Test Cases ***
Login page can use account to login
    [Documentation]     ref#0
    Given Go to web
        When Input username                  exampleusername
        And Input password                   examplepassword
        And Click signin
    Then Enter to website

