/********* MyFatoorahPaymentPlug.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MFSDK/MFSDK.h>

@interface MyFatoorahPaymentPlug : CDVPlugin {
  // Member variables go here.
  MFCustomer *customer;

}

- (void)presentPaymentModule:(CDVInvokedUrlCommand*)command;
- (void)testMethod:(CDVInvokedUrlCommand*)command;
- (void)payNow:(CDVInvokedUrlCommand*)command;
@end

@implementation MyFatoorahPaymentPlug


- (void)presentPaymentModule:(CDVInvokedUrlCommand*)command
{

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

                                                                
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Added merchant account"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)testMethod:(CDVInvokedUrlCommand*)command
{
                                                                
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"testMethod  account"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)payNow:(CDVInvokedUrlCommand*)command{

    [MFOrderStatusRequest sharedInstance].delegateOrderStatus = self;
    [self populateCustomerPayment];

    NSMutableArray *productlistLocal = [[NSMutableArray alloc]init];
    MFProductDetails *productDetail = [[MFProductDetails alloc]init];

    productDetail.productName = @"ABC";
    productDetail.productPrice = 0.54;
    productDetail.productQuntity = 1;
    
    [productlistLocal addObject:productDetail];
    [[MFPaymentRequest sharedInstance] payfor_BOTHWithCustomer:customer productList:productlistLocal subTotal:productDetail.productPrice paymentCurrrency:@"KWD"];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"payNow method"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)populateCustomerPayment{
    
    customer = [[MFCustomer alloc]init];
    customer.customerName = @"customer name "; //Required
    customer.customerEmailAddress = @"email address";//Required
    customer.customerMobileNo = @"mobile no";//Required
    customer.customerGender = @"";
    customer.customerDOB = @"";
    customer.customerCivilID = @"";
    customer.customerArea = @"";
    customer.customerBlockNo = @"";
    customer.customerStreet = @"";
    customer.customerAvenue = @"";
    customer.customerBuildingNo = @"";
    customer.customerFloorNo = @"";
    customer.customerApartment = @"";
    
}


//Delegate method to be called when payment is succeed
- (void)getOrderPaymentStatusSucessWithOrdetStatus:(MFOrderStatusRequestResponse *)ordetStatus{
    
    NSLog(@"order is success");
    
}

//Delegate method to be called when payment is Fails
- (void)getOrderPaymentStatusFailedWithOrdetStatus:(MFOrderStatusRequestResponse *)ordetStatus{
    NSLog(@"order is failed");
}


@end
