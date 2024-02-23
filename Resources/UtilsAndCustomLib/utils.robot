*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Click application element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}		20
    Wait Until Element Is Enabled    ${locator}		10
    Click Element    ${locator}
    
Input text to the field
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible     ${locator}
    wait until element is enabled     ${locator}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

