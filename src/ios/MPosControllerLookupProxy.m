
#import "MPosControllerLookupProxy.h"
#import "MPosLookup.h"
#import "MPosDeviceInfo.h"
#import "MPosResults.h"
#import "MPosDefines.h"

@interface MPosControllerLookupProxy()
@property MPosLookup* lookup;
@end

@implementation MPosControllerLookupProxy

- (void)pluginInitialize{
    _lookup = [MPosLookup new];
}

- (void) refreshDeivcesList:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    [self.commandDelegate runInBackground:^{
        MPOS_RESULT result = MPOS_FAIL;
        CDVPluginResult* callbackResult  = nil;
        if([command.arguments count] < 1){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }

        NSInteger interferType = [[command.arguments objectAtIndex:0] integerValue];
        switch (interferType) {
            case MPOS_INTERFACE_WIFI:
            case MPOS_INTERFACE_ETHERNET:
            case MPOS_INTERFACE_BLUETOOTH:
                result = [self.lookup refreshDeviceList:interferType];
                break;
            default:
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_INTERFACE];
        }
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger: result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:MPOS_SUCCESS];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) getDeviceList:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSArray<MPosDeviceInfo*>* list = nil;
    NSInteger interferType = [[command.arguments objectAtIndex:0] integerValue];
    switch (interferType) {
        case MPOS_INTERFACE_WIFI:
        case MPOS_INTERFACE_ETHERNET:
        case MPOS_INTERFACE_BLUETOOTH:
            list = [_lookup getDeviceList:interferType];
            break;
        default:
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_INTERFACE];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
    }
    
    if([list count] <= 0){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* deviceInfoInJSON = @"";
    for (MPosDeviceInfo* item in list) {
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"{\"interfaceType\": "];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: [NSString stringWithFormat:@"%ld", (long)item.interfaceType]];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @","];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\"name\": "];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\""];
        switch (item.interfaceType) {
            case MPOS_INTERFACE_WIFI:
                if(![item.name length])
                    item.name = @"Wi-Fi Device";
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: item.name];
                break;
            case MPOS_INTERFACE_ETHERNET:
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"Ethernet Device"];
                break;
            case MPOS_INTERFACE_BLUETOOTH:
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: item.name];
                break;
        }
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\","];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\"address\": "];
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\""];
        switch (item.interfaceType) {
            case MPOS_INTERFACE_WIFI:
            case MPOS_INTERFACE_ETHERNET:
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: item.address];
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @":"];
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: [item.portNumber stringValue]];
                break;
            case MPOS_INTERFACE_BLUETOOTH:
                deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: item.macAddress];
                break;
        }
        deviceInfoInJSON = [deviceInfoInJSON stringByAppendingString: @"\"},"];
    }
    
    if([deviceInfoInJSON length]){
        deviceInfoInJSON = [deviceInfoInJSON substringToIndex:[deviceInfoInJSON length]-1];
        NSString* stringWithBracket = @"[";
        stringWithBracket = [stringWithBracket stringByAppendingString: deviceInfoInJSON];
        stringWithBracket = [stringWithBracket stringByAppendingString: @"]"];
        deviceInfoInJSON = stringWithBracket;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deviceInfoInJSON];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

@end
