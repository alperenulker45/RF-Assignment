*** Settings ***
Documentation    Validation of total and delivery fees
...              Validation of Finnish postal code
Library          SeleniumLibrary
Resource         ../Resources/KeywordDefinition/TC01_StepDefinitions.robot

Suite Setup        Navigate to posti shopping website
Suite Teardown     Close Browser

*** Variables ***
${streetAddress}    Alvar Aallontie
${postCode}         27500
${city}             Kauttua

*** Test Cases ***
TC01-Add Products To The Cart And Checkout
    Navigate To All Stamps Shopping Page
    ${stamp_1_Name}    ${stamp_1_Price}    Get the name and price of first stamp and add to the cart
    Check The Add To Cart Notification Popup Displayed Correctly             ${stamp_1_Name}
    Navigate to the cart page and check the products added to the cart       ${stamp_1_Name}
    Check the subtotal, delivery fee and total prices calculated correctly   ${stamp_1_Price}
    Navigate to All Stamps Shopping Page From Cart Page
    ${stamp_2_Name}    ${stamp_2_Price}    Get the name and price of second stamp and add to the cart
    Check The Add To Cart Notification Popup Displayed Correctly             ${stamp_2_Name}
    Navigate to the cart page and check the products added to the cart       ${stamp_1_Name}        ${stamp_2_Name}
    Check the subtotal, delivery fee and total prices calculated correctly   ${stamp_1_Price}       ${stamp_2_Price}
    Navigate to the checkout page from cart page
    ${name}    ${surname}    ${invalidPostalCode}    ${telephone}    ${mail}    Generate Random Data for billing form with invalid post code   
    Fill the billing form with invalid post code         ${name}    ${surname}    ${invalidPostalCode}    ${telephone}    ${mail}
    Check the warning for invalid postal code displayed
    Fill the street address and validate the postcode and city    ${streetAddress}        ${postCode}        ${city}
    Save the billing form on checkout page        



    
    




    


