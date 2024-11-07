*** Settings ***
Resource            ../Resources/main.robot
Test Setup          Start Web Test
Test Teardown       End Web Test

Library    Telnet

*** Test Cases ***
Test the "Copy Password" icon function
    [Documentation]    Test the "Copy Password" icon next to the displayed password
    ...    Check the displayed passwords against the content copied in clipboard, making sure they match
    Navigate to Password Generator page
    Retrieve generated password
    Click the "Copy Password" icon
    Verify correct password is copied to clipboard

Test the "Copy Password" button function
    [Documentation]    Test the "Copy Password" button next to the displayed password
    ...    Check the displayed passwords against the content copied in clipboard, making sure they match
    Navigate to Password Generator page
    Retrieve generated password
    Click the "Copy Password" button
    Verify correct password is copied to clipboard

Test the "Generate Password" icon function
    [Documentation]    Test the "Generate" icon function next to the "Copy Password" icon
    ...    It should refresh the displayed password
    Navigate to Password Generator page
    Retrieve generated password
    Click the "Generate Password" icon
    Verify a new password is generated

Test the password length requirement
    [Documentation]    Test the password lenght requirements, which are set by users.
    ...    The range is: 6<= PasswordLength <=32
    Navigate to Password Generator page
    Test various password lengths by entering value

Test "Numbers" checkbox function
    [Documentation]    Solely test the password against the requirement when the "Numbers" checkbox is selected/unselected
    [Tags]    
    Navigate to Password Generator page
    Set requirement        Numbers
    Unset requirement      Lowercase
    Unset requirement      Uppercase
    Check password against requirements
    # This confirms that when there's only 1 requirement, the option cannot be unselected
    Unset requirement      Numbers
    Check password against requirements

Test "Symbols" checkbox function
    [Documentation]    Solely test the password against the requirement when the "Symbol" checkbox is selected/unselected
    [Tags]    
    Navigate to Password Generator page
    Set requirement        Symbols
    Unset requirement      Lowercase
    Unset requirement      Uppercase
    Check password against requirements
    # This confirms that when there's only 1 requirement, the option cannot be unselected
    Unset requirement      Symbols
    Check password against requirements

Test "Lowercase" checkbox function
    [Documentation]    Solely test the password against the requirement when the "Lowercase" checkbox is selected/unselected
    [Tags]    
    Navigate to Password Generator page
    Unset requirement      Uppercase
    Check password against requirements
    # This confirms that when there's only 1 requirement, the option cannot be unselected
    Unset requirement      Lowercase
    Check password against requirements

Test "Uppercase" checkbox function
    [Documentation]    Solely test the password against the requirement when the "Uppercase" checkbox is selected/unselected
    [Tags]    
    Navigate to Password Generator page
    Unset requirement      Lowercase
    Check password against requirements
    # This confirms that when there's only 1 requirement, the option cannot be unselected
    Unset requirement      Uppercase
    Check password against requirements

Test different combinations of password requirements
    [Documentation]    Combine different password requirements to make sure all features work well altogether.
    [Tags]    current
    Navigate to Password Generator page
    Generate requirements combinations
    FOR    ${counter}    IN RANGE    0    50  
        Set random password requirements
        Generate random password length
        Check password against requirements
    END
