*** Settings ***
Documentation   Test Setup and Tear Down for the automation suites
Library         SeleniumLibrary
Resource        main.robot

*** Variables ***
     

*** Keywords ***
Start Web Test
    [Documentation]     Test setup: Navigate to homepage on a specified website
    Open Browser        ${URL}      ${BROWSER}    #options=${OPTIONS}
    Maximize Browser Window

End Web Test
    [Documentation]    Test Teardown: Close the browser once all the test cases are run.
    # Reset ${PASSWORD_LENGTH} & &{REQUIREMENTS} key-values to their original state
    ${PASSWORD_LENGTH}=    Set Variable    6
    Set Suite Variable    ${PASSWORD_LENGTH}
    &{REQUIREMENTS}=     Create Dictionary        Lowercase=True     Uppercase=True    Numbers=False    Symbols=False  
    Set Suite Variable     ${REQUIREMENTS}
    Sleep   10s
    Close Browser


