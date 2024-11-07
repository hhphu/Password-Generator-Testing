*** Settings ***
Documentation     Base Page Object that all other page objects inherit from. Contains functionality that is common to all page objects and global variables
Library           SeleniumLibrary
Library           Collections
Resource          ../main.robot

*** Variables ***
${BROWSER}               chrome
${GENERATED_PASSWORD}    ''
&{REQUIREMENTS}          Lowercase=True    Uppercase=True    Numbers=False    Symbols=False
@{REQUIREMENTS_COMBINATION}    
${REQ_PASSWORD_LENGTH}   6
${REGEX_UPPERCASE}       [A-Z]
${REGEX_LOWERCASE}       [a-z]
${REGEX_NUMBERS}         [0-9]
${REGEX_SYMBOLS}         [!@#$%^&*\\(\\)_+\\{\\}\\[\\]:;"'<>?,.\\/\\|`~-]
&{REGEX}                 Lowercase=${REGEX_LOWERCASE}    Uppercase=${REGEX_UPPERCASE}    Numbers=${REGEX_NUMBERS}    Symbols=${REGEX_SYMBOLS}
${URL}                   https://www.security.org/
${WAIT}                  30s


