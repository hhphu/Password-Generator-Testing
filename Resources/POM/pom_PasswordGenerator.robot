*** Settings ***
Documentation     Password Generator Page which contains all keywrods and related variables
Library           SeleniumLibrary
Library           Collections
Library           Process
Library           OperatingSystem
Resource          ../main.robot
Resource          ../setup.robot

*** Variables ***
${loc_bar_password_length}                  css=#passwordLengthRange
${loc_button_copy_password}                 css=.PasswordGenerator_btn_copy__k4Pr8
${loc_checkbox_lower_case}                  xpath=//label[@for="option-lowercase"]
${loc_checkbox_upper_case}                  xpath=//label[@for="option-uppercase"]
${loc_checkbox_has_numbers}                 xpath=//label[@for="option-numbers"]
${loc_checkbox_has_symbols}                 xpath=//label[@for="option-symbols"]
${loc_h2_customize_your_password}           css=.PasswordGenerator_pg_settings_headline__lzUJq
${loc_icon_copy_password}                   xpath=//button[@title='Copy Password']
${loc_icon_generate_password}               xpath=//button[@title='Generate password']
${loc_input_display_password}               css=#password
${loc_input_password_length}                css=#passwordLength



*** Keywords ***
Check for unselect conditions
    [Documentation]    This is to make sure at least one requirement is always selected
    ...    Return True if ${REQUIREMENTS} dictionary has at least 2 keys whose values are True, meaning we can remove a requirement
    ...    Return False if ${REQUIREMENTS} dictionary has less than 2 keys whose values are True, meaning we can not remove any requirement
    ${number_of_Trues}=    Set Variable    0
    FOR    ${value}    IN    @{REQUIREMENTS.values()}
        Log    Checking values of ${value}
        IF    ${value} == ${True}
            ${number_of_Trues}=    Set Variable    ${number_of_Trues}+1
        END
    END  
    IF   ${number_of_Trues} >= 2
        Return From Keyword    True
    ELSE
        Return From Keyword    False
    END
    Return From Keyword    ${number_of_Trues} >= 2
Check if password has
    [Arguments]        ${option}
    [Documentation]    check password against the provided requirement
    ${isOption}=    Get From Dictionary    ${REQUIREMENTS}    ${option}
    Return From Keyword    ${isOption}
    
Check if password meets requirement
    [Arguments]        ${option}
    [Documentation]    check password against the provided requirement. This includes length and whatever requirement set by users
    ...        Arguments: option= the selected option (Lowercase, Uppsercase, Numbers, Symbols)
    Check password length against the requirement
    ${isOption}=    Check if password has    ${option}   
    ${regex_option}=    Get From Dictionary    ${REGEX}    ${option}
    IF    ${isOption}
        Should Match Regexp    ${GENERATED_PASSWORD}    ${regex_option}
    ELSE
        Should Not Match Regexp    ${GENERATED_PASSWORD}    ${regex_option}    
    END

Check password against default requirements  
    [Documentation]    Check if password meets the default requirement when first landing on the page
    ...    Requirements: Length =6; isLowercase, isUppsercase
    Retrieve generated password
    # Check for default length = 6
    ${password_length}=    Get Length    ${GENERATED_PASSWORD}
    Should Be Equal As Integers    ${password_length}    6
    # Check if meets requirement Lowercase
    Check if password meets requirement    Lowercase
    # Check if meets requirement Uppercase
    Check if password meets requirement    Uppercase
    
Check password against requirements
    [Documentation]     Check to see if the generated passwords meet all the set requirements
    # Check password length
    Check password length against the requirement
    Check if password meets requirement    Lowercase
    Check if password meets requirement    Uppercase
    Check if password meets requirement    Numbers
    Check if password meets requirement    Symbols

Check password length against the requirement
    [Documentation]    Test the passwords' lengths and make sure they meet requirements
    ...    Arguments: input_length= value set by users
    Retrieve generated password   
    Get password length requirement
    ${generated_password_length}=    Get Length    ${GENERATED_PASSWORD}
    Should Be Equal As Integers    ${generated_password_length}    ${REQ_PASSWORD_LENGTH}

 
Click the "Copy Password" button
    [Documentation]    Click the blue "Copy Password" button 
    Wait Until Element Is Visible    ${loc_button_copy_password}   ${WAIT}    The "Copy Password" icon is not visible.
    Click Element    ${loc_button_copy_password}

Click the "Copy Password" icon
    [Documentation]    Click the "Copy Password" icon next to the displayed password
    Wait Until Element Is Visible    ${loc_icon_copy_password}    ${WAIT}    The "Copy Password" icon is not visible.
    Click Element    ${loc_icon_copy_password}

Click the "Generate Password" icon
    [Documentation]    Click the "Generate Password" icon
    Wait Until Element Is Visible    ${loc_icon_generate_password}    ${WAIT}    The "Generate Password" icon is not visible
    Click Element    ${loc_icon_generate_password}

Generate requirements combinations
    [Documentation]    Generate all possible requirements for the passwords and store them in the global variable ${REQUIREMENTS_COMBINATION}
    @{all_combinations}=    Evaluate    itertools.product(['True','False'], repeat =4)
    FOR    ${combo}    IN    @{all_combinations}
        Log    ${combo}
        ${requirement}=    Evaluate    dict(zip(["Lowercase","Uppercase","Numbers","Symbols"],${combo}))
        Append To List    ${REQUIREMENTS_COMBINATION}    ${requirement}
    END
    Log    ${REQUIREMENTS_COMBINATION}
    Set Suite Variable    ${REQUIREMENTS_COMBINATION}

Generate random password length
    [Documentation]    Generate random length for the password. The length is between 6 and 32
    ${random_length}=    Evaluate    random.randrange(6, 32)    modules=random
    Execute JavaScript    document.getElementById("passwordLength").value = "";
    Input Text    ${loc_input_password_length}    ${random_length}
    Check password length against the requirement 
Get Clipboard content using Python
    [Documentation]    Get the content copied from clipboard using Python
    ${rc}    ${output}=    Run and Return RC and Output    python3 -c "import pyperclip; print(pyperclip.paste())"
    Return from Keyword    ${output}

Get password length requirement
    [Documentation]  Retrieve the password length set by users to make sure the generated passwords meet the requirments.
    ...    Store the new length in the global variable ${REQ_PASSWORD_LENGTH} for easy access
    Wait Until Element Is Visible    ${loc_bar_password_length}    ${WAIT}    The password length field is not visible.
    ${REQ_PASSWORD_LENGTH}=    Get Value    ${loc_bar_password_length}
    Set Suite Variable    ${REQ_PASSWORD_LENGTH}
    
Navigate to Password Generator page
    [Documentation]     Navigate to the Password Generator page
    ${password_generator_url}=      Catenate    SEPARATOR=/         ${URL}      password-generator
    Go to                           ${password_generator_url}
    Verify Password Generator page loaded

Retrieve generated password
    [Documentation]    Retrieve the generated passwords displayed on the website
    Wait Until Element Is Visible    ${loc_input_display_password}    ${WAIT}    The input field displaying password is not visible.
    ${GENERATED_PASSWORD}=     Get Value    ${loc_input_display_password}
    Set Suite Variable    ${GENERATED_PASSWORD}

Set random password requirements
    [Documentation]    Rnadomly select a requirement from ${REQUIREMENTS_COMBINATION} for Testing
    ${random_index}=    Evaluate    random.randrange(0, 15)    modules=random
    ${requirements}=    Get From List    ${REQUIREMENTS_COMBINATION}    ${random_index}
    FOR    ${key}    IN    @{requirements}
        Log    ${key}
        IF    '${requirements}[${key}]' == '${True}'
            Set requirement    ${key}
        ELSE
            Unset requirement    ${key}
        END
    END

Set requirement
    [Arguments]        ${option}
    [Documentation]    Check box of the selected option
    ...    Arguments: option= the selected option (Lowercase, Uppsercase, Numbers, Symbols)
    ${isRequirementSet}=    Check if password has    ${option}
    IF     ${isRequirementSet} == False
        IF    '${option}' == 'Lowercase'
            Wait Until Element Is Visible    ${loc_checkbox_lower_case}    ${WAIT}    The Lowercase checkbox is not available.
            Click Element                    ${loc_checkbox_lower_case}
            Set To Dictionary                ${REQUIREMENTS}    Lowercase    True
        ELSE IF    '${option}' == 'Uppercase'
            Wait Until Element Is Visible    ${loc_checkbox_upper_case}    ${WAIT}    The Uppercase checkbox is not available.
            Click Element                    ${loc_checkbox_upper_case}
            Set To Dictionary                ${REQUIREMENTS}    Uppercase    True
        ELSE IF    '${option}' == 'Numbers'
            Wait Until Element Is Visible    ${loc_checkbox_has_numbers}    ${WAIT}    The Numbers checkbox is not available.
            Click Element                    ${loc_checkbox_has_numbers}
            Set To Dictionary                ${REQUIREMENTS}    Numbers    True
        ELSE IF    '${option}' == 'Symbols'
            Wait Until Element Is Visible    ${loc_checkbox_has_symbols}    ${WAIT}    The Symbols checkbox is not available.
            Click Element                    ${loc_checkbox_has_symbols}
            Set To Dictionary                ${REQUIREMENTS}    Symbols    True
        END
    ELSE
        Log    Requirement ${option} has been already set
    END
    Log     REQUIREMENT: ${REQUIREMENTS}
    
Unset requirement
    [Arguments]        ${option}
    [Documentation]    Check box of the selected option
    ...    Arguments: option= the selected option (Lowercase, Uppsercase, Numbers, Symbols)
    ${isRequirementSet}=    Check if password has    ${option}
    ${canUnselect}=    Check for unselect conditions
    
    IF    '${canUnselect} and ${isRequirementSet}'
        IF    '${option}' == 'Lowercase'
            Wait Until Element Is Visible    ${loc_checkbox_lower_case}    ${WAIT}    The Lowercase checkbox is not available.
            Click Element                    ${loc_checkbox_lower_case}
            Set To Dictionary                ${REQUIREMENTS}    Lowercase    False
        ELSE IF    '${option}' == 'Uppercase'
            Wait Until Element Is Visible    ${loc_checkbox_upper_case}    ${WAIT}    The Uppercase checkbox is not available.
            Click Element                    ${loc_checkbox_upper_case}
            Set To Dictionary                ${REQUIREMENTS}    Uppercase    False
        ELSE IF    '${option}' == 'Numbers'
            Wait Until Element Is Visible    ${loc_checkbox_has_numbers}    ${WAIT}    The Numbers checkbox is not available.
            Click Element                    ${loc_checkbox_has_numbers}
            Set To Dictionary                ${REQUIREMENTS}    Numbers    False
        ELSE IF    '${option}' == 'Symbols'
            Wait Until Element Is Visible    ${loc_checkbox_has_symbols}    ${WAIT}    The Symbols checkbox is not available.
            Click Element                    ${loc_checkbox_has_symbols}
            Set To Dictionary                ${REQUIREMENTS}    Symbols    False
        END
    ELSE
        Log    Cannot uncheck ${option} as there must be at least one requirement set.
    END
    Log     REQUIREMENT: ${REQUIREMENTS}

Test various password lengths by entering value
    [Documentation]    Test various length for the passwords by entering values into the input field
    FOR    ${length}    IN RANGE    0    50
        Log    Testing password length of ${length}
        Wait Until Element Is Visible    ${loc_input_password_length}    ${WAIT}    Password length field is not visible
        Execute JavaScript    document.getElementById("passwordLength").value = "";
        Input Text    ${loc_input_password_length}    ${length}
        Check password length against the requirement 
    END

Verify correct password is copied to clipboard
    [Documentation]    Compare the password copied to clipboard and the password displayed on the website. They should match. 
    #${copied_text}=    Execute JavaScript    return navigator.clipboard.readText();
    ${copied_text}=    Get Clipboard content using Python
    Should Not Be Empty    ${copied_text}    ${copied_text} is empty.
    Should Be Equal As Strings    ${copied_text}   ${GENERATED_PASSWORD}


Verify Password Generator page loaded
    [Documentation]     Verify the Password Generator page successfully loaded by making sure the "Customize your password" header is visible.
    Wait Until Element Is Visible   ${loc_h2_customize_your_password}    ${WAIT}     "Customize your password" header is not visible  
    # Check default passwords requirements when first landing on the page.
    Check password against default requirements    
       

Verify a new password is generated
    [Documentation]    Verify a new password if generated.
    ...     Also check the validity of the generated password, ie making sure:
    ...        1. The length stays the same
    ...        2. The new password is not the same as the old password.
    ${old_password}=    Set Variable     ${GENERATED_PASSWORD}
    Retrieve generated password
    Should Not Be Equal As Strings    ${old_password}    ${GENERATED_PASSWORD}    The new password is the same as the old one.