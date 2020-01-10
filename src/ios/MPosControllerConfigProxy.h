
#import <Cordova/CDV.h>

@interface MPosControllerConfigProxy : CDVPlugin

- (void) searchDevices:(CDVInvokedUrlCommand *)command;
- (void) reInitCustomDeviceType:(CDVInvokedUrlCommand *)command;
- (void) addCustomDevice:(CDVInvokedUrlCommand *)command;
- (void) deleteCustomDevice:(CDVInvokedUrlCommand *)command;
- (void) getCustomDevices:(CDVInvokedUrlCommand *)command;
- (void) getUSBDevice:(CDVInvokedUrlCommand *)command;
- (void) getBgateSerialNumber:(CDVInvokedUrlCommand *)command;
- (void) getSerialConfig:(CDVInvokedUrlCommand *)command;
- (void) setSerialConfig:(CDVInvokedUrlCommand *)command;

- (void) selectInterface:(CDVInvokedUrlCommand *)command;
- (void) selectCommandMode:(CDVInvokedUrlCommand *)command;
- (void) openService:(CDVInvokedUrlCommand *)command;
- (void) closeService:(CDVInvokedUrlCommand *)command;
- (void) directIO:(CDVInvokedUrlCommand *)command;
- (void) setTransaction:(CDVInvokedUrlCommand *)command;
- (void) isOpen:(CDVInvokedUrlCommand *)command;
- (void) getDeviceId:(CDVInvokedUrlCommand *)command;

@end
