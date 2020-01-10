
#import <Cordova/CDV.h>

@interface MPosControllerLookupProxy : CDVPlugin

- (void) refreshDeivcesList:(CDVInvokedUrlCommand *)command;
- (void) getDeviceList:(CDVInvokedUrlCommand *)command;

@end
