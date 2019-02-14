/********* MyFatoorahPaymentPlug.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MFSDK/MFSDK.h>

@interface MyFatoorahPaymentPlug : CDVPlugin<MFPaymentRequestDelegate,MFOrderStatusRequestDelegate> {
    // Member variables go here.
    MFCustomer *customer;
    CDVInvokedUrlCommand *callBackCommand;
    
}

- (void)initialisePaymentDetails:(CDVInvokedUrlCommand*)command;
- (void)payNow:(CDVInvokedUrlCommand*)command;
@end

@implementation MyFatoorahPaymentPlug


- (void)initialisePaymentDetails:(CDVInvokedUrlCommand*)command {
    BOOL isTestMode = ([command.arguments[0] valueForKey:@"isTestMode"] != nil && [[command.arguments[0] valueForKey:@"isTestMode"] integerValue] == 0)  ? false:true;
    NSLog(@"isTestMode ====%d",isTestMode);
    if ([(NSMutableDictionary *)[command.arguments[0] allKeys] count] > 0 ) {
        [MFSettings.sharedInstance setMerchantWithMerchantCodeWithMerchantCode:[command.arguments[0] valueForKey:@"merchantCode"]
                                                                  merchantName:[command.arguments[0] valueForKey:@"merchantName"]
                                                              merchantUserName:[command.arguments[0] valueForKey:@"merchantUserName"]
                                                              merchantPassword:[command.arguments[0] valueForKey:@"merchantPassword"]
                                                           merchantReferenceID:[command.arguments[0] valueForKey:@"merchantReferenceID"]
                                                             merchantReturnURL:[command.arguments[0] valueForKey:@"merchantReturnURL"]
                                                              merchantErrorUrl:[command.arguments[0] valueForKey:@"merchantErrorUrl"]
                                                                          udf1:[command.arguments[0] valueForKey:@"udf1"]
                                                                          udf2:[command.arguments[0] valueForKey:@"udf2"]
                                                                          udf3:[command.arguments[0] valueForKey:@"udf3"]
                                                                          udf4:[command.arguments[0] valueForKey:@"udf4"]
                                                                          udf5:[command.arguments[0] valueForKey:@"udf5"]
                                                                    isTestMode:isTestMode];
    } else  {
        [MFSettings.sharedInstance setMerchantWithMerchantCodeWithMerchantCode:@"999999"
                                                                  merchantName:@"Web Pay"
                                                              merchantUserName:@"testapi@myfatoorah.com"
                                                              merchantPassword:@"E55D0"
                                                           merchantReferenceID:@"201454542102"
                                                             merchantReturnURL:@"https://www.google.co.in"
                                                              merchantErrorUrl:@"https://www.yahoo.com"
                                                                          udf1:@""
                                                                          udf2:@""
                                                                          udf3:@""
                                                                          udf4:@""
                                                                          udf5:@""
                                                                    isTestMode:YES];
    }
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Added merchant account"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)payNow:(CDVInvokedUrlCommand*)command{
    [MFOrderStatusRequest sharedInstance].delegateOrderStatus = self;
    [self populateCustomerPayment:[command.arguments[0] valueForKey:@"customerDetails"]];
    NSMutableArray *productlistLocal = [[NSMutableArray alloc]init];
    MFProductDetails *productDetail = [[MFProductDetails alloc]init];
    callBackCommand = command;
    productDetail.productName = [[command.arguments[0] valueForKey:@"productDetails"] valueForKey:@"productName"];
    productDetail.productPrice = [[[command.arguments[0] valueForKey:@"productDetails"] valueForKey:@"productPrice"] doubleValue];
    productDetail.productQuntity = [[[command.arguments[0] valueForKey:@"productDetails"] valueForKey:@"productQuantity"] integerValue];
    [productlistLocal addObject:productDetail];
    [MFPaymentRequest sharedInstance].delegatePayment = self;
    [[MFPaymentRequest sharedInstance] payfor_BOTHWithCustomer:customer productList:productlistLocal subTotal:productDetail.productPrice paymentCurrrency:@"KWD"];
}

- (void)populateCustomerPayment:(NSDictionary *)dict{
    customer = [[MFCustomer alloc]init];
    customer.customerName = [dict objectForKey:@"customerName"]; //Required
    customer.customerEmailAddress = [dict objectForKey:@"customerEmailAddress"];//Required
    customer.customerMobileNo = [dict objectForKey:@"customerMobileNo"];//Required
    customer.customerGender = [dict objectForKey:@"customerGender"];
    customer.customerDOB = [dict objectForKey:@"customerDOB"];
    customer.customerCivilID = [dict objectForKey:@"customerCivilID"];
    customer.customerArea = [dict objectForKey:@"customerArea"];
    customer.customerBlockNo = [dict objectForKey:@"customerBlockNo"];
    customer.customerStreet = [dict objectForKey:@"customerStreet"];
    customer.customerAvenue = [dict objectForKey:@"customerAvenue"];
    customer.customerBuildingNo = [dict objectForKey:@"customerBuildingNo"];
    customer.customerFloorNo = [dict objectForKey:@"customerFloorNo"];
    customer.customerApartment = [dict objectForKey:@"customerApartment"];
}


//Delegate method to be called when payment is succeed
- (void)getOrderPaymentStatusSucessWithOrdetStatus:(MFOrderStatusRequestResponse *)ordetStatus{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self getDictFromPaymentResponse:ordetStatus]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callBackCommand.callbackId];
    NSLog(@"order is success");
    
}

- (void)paymentSucss{
    NSLog(@"paymentSucss is success");
}

- (void)errorMessageWithError:(NSString * _Nonnull)error{
    NSLog(@"order is failed errorMessageWithError");
}

//Delegate method to be called when payment is Fails
- (void)getOrderPaymentStatusFailedWithOrdetStatus:(MFOrderStatusRequestResponse *)ordetStatus {
    NSLog(@"order is failed");
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:[self getDictFromPaymentResponse:ordetStatus]];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callBackCommand.callbackId];
}

- (NSDictionary *)getDictFromPaymentResponse:(MFOrderStatusRequestResponse *)orderResponse{
    NSDictionary *paymentResponseDict = [NSDictionary dictionaryWithObjectsAndKeys: orderResponse.authenticationID, @"Authentication_Id",
                                         orderResponse.grossAmount, @"Gross_amount",
                                         orderResponse.orderID, @"Net_amount",
                                         orderResponse.paymode, @"OrderID",
                                         orderResponse.paymode, @"Pay_mode",
                                         orderResponse.payTxnID, @"PayTxn_Id",
                                         orderResponse.referenceID, @"Reference_Id",
                                         orderResponse.responseCode,@"Response_code",
                                         orderResponse.responseMessage,@"Response_message",
                                         orderResponse.result,@"Result",
                                         orderResponse.translationID,@"Translation_Id",
                                         orderResponse.postDate,@"Post_date",
                                         orderResponse.udf1,@"Udf1",
                                         orderResponse.udf2,@"Udf2",
                                         orderResponse.udf3,@"Udf3",
                                         orderResponse.udf4,@"Udf4",
                                         orderResponse.udf5,@"@Udf5",
                                         nil];
    return paymentResponseDict;
}
@end

