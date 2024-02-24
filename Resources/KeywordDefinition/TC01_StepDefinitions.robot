*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    ../UtilsAndCustomLib/customLib.py
Resource	../UtilsAndCustomLib/utils.robot
Variables	../TestData/locators.yaml

*** Variables ***
${url}        https://www.posti.fi/en
${browser}    Chrome

*** Keywords ***
Navigate to posti shopping website
    Open Browser        ${url}            ${browser}
    Maximize Browser Window
    Click Application Element        ${PostiHomePage.accept_cookies}

Navigate to all stamps shopping page
    Scroll Element Into View     ${PostiHomePage.all_stamps_button}
    Click Application Element    ${PostiHomePage.all_stamps_button}
    Switch Window        NEW
    Wait Until Element Is Visible    ${StampsShoppingPage.products_section_title}         30        Stamps shopping page has not been loaded in 30 seconds
    ${subTitle}    Get Text          ${StampsShoppingPage.products_section_title}
    Should Be Equal As Strings        ${subTitle}         Stamps             Page title should have been Stamps but it is ${subTitle}

Get the name and price of first stamp and add to the cart
    ${stampName}             Get Text        ${StampsShoppingPage.first_stamp_name_on_page}
    ${stampPriceAsText}      Get Text        ${StampsShoppingPage.first_stamp_price_on_page}
    ${stampPrice}        Convert String To Decimal    ${stampPriceAsText}
    Click Application Element            ${StampsShoppingPage.first_stamp_add_to_cart_button}
    RETURN      ${stampName}       ${stampPrice}
    
Check the add to cart notification popup displayed correctly
    [Arguments]    ${stampName}
    wait until element is visible        ${StampsShoppingPage.add_To_Cart_Success_Notification}
    ${notificationText}        Get Text    ${StampsShoppingPage.add_To_Cart_Success_Notification}
    ${isNotificationCorrect}    Run Keyword And Return Status    Should Be Equal As Strings        ${notificationText}        "${stampName}" added to cart.
    IF    "${isNotificationCorrect}"=="False"
            Capture Page Screenshot
            Fail     Notification text should have been "${stampName}" added to cart.
    END
    Click Application Element            ${StampsShoppingPage.notification_close_icon}

Navigate to the cart page and check the products added to the cart
    [Arguments]       @{productNames}
    Click Application Element        ${StampsShoppingPage.cart_button}
    Wait Until Element Is Visible    ${CartPage.cart_page_title}        30         Cart page has not been loaded in 30 seconds
    ${cartPageTitle}    Get Text     ${CartPage.cart_page_title}
    Should Be Equal As Strings       ${cartPageTitle}        Cart        Page title should have been Cart but it is ${cartPageTitle}
    ${products}    Create List    
    ${productsOnPage}    Get Webelements    ${CartPage.product_names}
    FOR    ${element}    IN       @{productsOnPage}
           ${stampNameOnPage}    Get Text    ${element}
           ${stampNameOnPageTrimmedSpaces}     Trim Spaces      ${stampNameOnPage}  
           Append To List    ${products}       ${stampNameOnPageTrimmedSpaces}
    END 
    log         ${products}
    ${isProductsOnPage}    Run Keyword And Return Status    Lists Should Be Equal       ${products}     ${productNames}    ignore_order=True
    IF     "${isProductsOnPage}" == "False"
        Capture Page Screenshot
        Fail     Added products are not on the cart page
    END
    
Check the subtotal, delivery fee and total prices calculated correctly
    [Arguments]    @{productPrices}
    Wait Until Element Is Not Visible    ${CartPage.price_section_load_spinner}
    ${subTotalPrice}    Get The Sum Of Numbers    ${productPrices}
    ${subTotalPriceOnPageAsText}    Get Text      ${CartPage.sub_total_price}  
    ${subTotalOnPage}    Convert String To Decimal        ${subTotalPriceOnPageAsText}
    Should Be Equal As Numbers    ${subTotalPrice}        ${subTotalOnPage}        Subtotal price should have been ${subTotalPrice} but it is ${subTotalOnPage}
    ${deliveryFee}    Set Variable If    ${subTotalPrice}<=45.00     5.00     0.00
    ${deliveryFeeOnPageAsText}    Get Text    ${CartPage.delivery_fee}
    ${deliveryFeeOnPage}      Convert String To Decimal         ${deliveryFeeOnPageAsText}
    Should Be Equal As Numbers        ${deliveryFeeOnPage}    ${deliveryFee}        Delivery fee should have been ${deliveryFee} but it is ${deliveryFeeOnPage}
    ${totalPriceAsList}    Create List        ${subTotalPrice}        ${deliveryFeeOnPage}
    ${totalPrice}    Get The Sum Of Numbers        ${totalPriceAsList}
    ${totalPriceOnPageAsText}    Get Text    ${CartPage.total_price}
    ${totalPriceOnPage}    Convert String To Decimal        ${totalPriceOnPageAsText}
    Should Be Equal As Numbers      ${totalPrice}           ${totalPriceOnPage}     Total price should have been ${totalPrice} but it is ${totalPriceOnPage}

Navigate to all stamps shopping page from cart page
    Click application element     ${CartPage.stamps_button_header}
    Wait Until Element Is Visible    ${StampsShoppingPage.products_section_title}         30        Stamps shopping page has not been loaded in 30 seconds
    ${subTitle}    Get Text          ${StampsShoppingPage.products_section_title}
    Should Be Equal As Strings       ${subTitle}         Stamps             Page title should have been Stamps but it is ${subTitle}
    
Get the name and price of second stamp and add to the cart
    ${stampName}             Get Text        ${StampsShoppingPage.second_stamp_name_on_page}
    ${stampPriceAsText}      Get Text        ${StampsShoppingPage.second_stamp_price_on_page}
    ${stampPrice}        Convert String To Decimal    ${stampPriceAsText}
    Click Application Element            ${StampsShoppingPage.second_stamp_add_to_cart_button}
    RETURN      ${stampName}       ${stampPrice}

Navigate to the checkout page from cart page
    Click Application Element        ${CartPage.checkout_button}
    Wait Until Element Is Visible    ${Checkoutpage.your_information_title}
    ${formTitle}    Get Text         ${Checkoutpage.your_information_title}
    Should Be Equal As Strings       ${formTitle}        Your information        Form title should have been Your Information but it is ${formTitle}

Generate random data for billing form with invalid post code
    ${name}                 Generate Random String    10     [LETTERS]
    ${lastName}             Generate Random String    10     [LETTERS]
    ${invalidPostalCode}    Generate Random String    5      [NUMBERS][LETTERS]
    ${invalidPostalCode2}   Generate Random String    6      [NUMBERS] 
    ${telephone}            Generate Random String    8      [NUMBERS]
    ${mail}                 Generate Random String    5      [LETTERS]
    ${mailFormat}           Set Variable         ${mail}@mail.com
    RETURN     ${name}      ${lastName}        ${invalidPostalCode}     ${invalidPostalCode2}          ${telephone}          ${mailFormat}

Fill the billing form with invalid post code
    [Arguments]    ${name}    ${surname}    ${postCode}    ${telephone}    ${mail}
    Input Text To The Field        ${Checkoutpage.billing_form_first_name}        ${name}
    Input Text To The Field        ${Checkoutpage.billing_form_last_name}         ${surname}
    Input Text To The Field        ${Checkoutpage.billing_form_postal_code}       ${postCode}
    Input Text To The Field        ${Checkoutpage.billing_form_telephone}         ${telephone}
    Input Text To The Field        ${Checkoutpage.billing_form_email}             ${mail}

Check the warning for invalid postal code displayed
    ${isWarningMessageDisplayed}    Run Keyword And Return Status    Element Should Be Visible        ${Checkoutpage.postal_code_warning_message}
    IF         "${isWarningMessageDisplayed}"=="False"
        Capture Page Screenshot    
        Fail     Warning message for invalid post code has not been displayed
    END

Fill the street address and validate the postcode and city
    [Arguments]    ${streetAddress}    ${postCode}    ${city}
    Execute javascript             window.scrollTo(0, -document.body.scrollHeight)
    Click Application Element      ${Checkoutpage.billing_form_street_address_box}
    Input Text To The Field        ${Checkoutpage.billing_form_street_address}       ${streetAddress}
    Sleep    2
    Press Keys       ${Checkoutpage.billing_form_street_address}         ENTER
    ${postCodeAutoFilled}    Get Element Attribute    ${Checkoutpage.billing_form_postal_code}        value 
    ${cityAutoFilled}        Get Element Attribute    ${Checkoutpage.billing_form_city}               value
    Should Be Equal As Strings        ${postCodeAutoFilled}            ${postCode}     
    Should Be Equal As Strings        ${cityAutoFilled}                ${city}

Save the billing form on checkout page
    Click Application Element            ${Checkoutpage.save_and_continue_button}
    Wait Until Element Is Visible        ${Checkoutpage.billing_form_summary_after_save}

    
    
    

    
    

    
    


 

