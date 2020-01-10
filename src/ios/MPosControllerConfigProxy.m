
#import "MPosControllerConfigProxy.h"
#import "MPosControllerConfig.h"
#import "MPosResults.h"
#import "MPosDefines.h"


@interface MPosControllerConfigProxy()
@property NSInteger deviceId;
@property MPOS_COMMAND_MODE commandMode;
@property MPosControllerConfig* config;
@property NSString* dataEventCallbackId;
@property NSString* statusEventCallbackId;
@end

@implementation MPosControllerConfigProxy

- (void)pluginInitialize{
    _config = [MPosControllerConfig new];
    _commandMode = MPOS_COMMAND_MODE_DEFAULT;
    _deviceId = -1;
    _dataEventCallbackId = nil;
    _statusEventCallbackId = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNotificationHandler:) name: @"DataEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNotificationHandler:) name: @"StatusUpdateEvent" object:nil];
}

- (void) setStatusUpdateEvent:(CDVInvokedUrlCommand*)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    _statusEventCallbackId = command.callbackId;
    NSLog(@"[setStatusUpdateEvent] _statusEventCallbackId = %@", _statusEventCallbackId);
    if(![_statusEventCallbackId length]){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
}

- (void) setDataOccurredEvent:(CDVInvokedUrlCommand*)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    _dataEventCallbackId = command.callbackId;
    NSLog(@"[setDataOccurredEvent] _dataEventCallbackId = %@", _dataEventCallbackId);
    if(![_dataEventCallbackId length]){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
}

- (void) deviceNotificationHandler:(NSNotification*) notification{
    NSNumber* deviceId = (NSNumber*)[notification object];
    if([deviceId integerValue] != [_config getDeviceId])
        return;
    if ([[notification name] isEqualToString: @"StatusUpdateEvent"]){
        NSMutableArray *allKeys = [[[notification userInfo] allKeys] mutableCopy];
        for (NSString *key in allKeys) {
            if(![[_config getNotificationKey] isEqualToString: key])
                continue;
            NSInteger status = [[[notification userInfo] objectForKey: key] integerValue];
            if([self.statusEventCallbackId length]){
                NSLog(@"[%@] [%@] id = %ld, status = %ld", NSStringFromClass([self class]), [notification name], (long)[deviceId integerValue], (long)status);
                NSString* statusInJSON = @"";
                statusInJSON = [statusInJSON stringByAppendingString: @"[{\"deviceid\": "];
                statusInJSON = [statusInJSON stringByAppendingString: [NSString stringWithFormat:@"%ld", (long)[deviceId integerValue]]];
                statusInJSON = [statusInJSON stringByAppendingString: @",\"status\": "];
                statusInJSON = [statusInJSON stringByAppendingString: [NSString stringWithFormat:@"%ld", (long)status]];
                statusInJSON = [statusInJSON stringByAppendingString: @"}]"];
                CDVPluginResult* callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:statusInJSON];
                [callbackResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:callbackResult callbackId: self.statusEventCallbackId];
            }
        }
    }
    else if ([[notification name] isEqualToString: @"DataEvent"]){
        NSMutableArray *allKeys = [[[notification userInfo] allKeys] mutableCopy];
        for (NSString *key in allKeys) {
            if(![[_config getNotificationKey] isEqualToString: key])
                continue;
            NSData* data = [[notification userInfo] objectForKey: key];
            if([self.dataEventCallbackId length]){
                NSLog(@"[%@] [%@] id = %ld, data = %@", NSStringFromClass([self class]), [notification name], (long)[deviceId integerValue], data);
                NSString* devDataInJSON = @"";
                // device id
                devDataInJSON = [devDataInJSON stringByAppendingString: @"[{\"deviceid\": "];
                devDataInJSON = [devDataInJSON stringByAppendingString: [NSString stringWithFormat:@"%ld", (long)[deviceId integerValue]]];
                devDataInJSON = [devDataInJSON stringByAppendingString: @",\"data\": ["];
                // device data
                UInt8* bytesArray = (UInt8*)data.bytes;
                for(int i = 0; i < [data length]; i++){
                    devDataInJSON = [devDataInJSON stringByAppendingString: [NSString stringWithFormat:@"%ld", (long)bytesArray[i]]];
                    if(i != [data length]-1){
                        devDataInJSON = [devDataInJSON stringByAppendingString: @","];
                    }else{
                        devDataInJSON = [devDataInJSON stringByAppendingString: @"]"];
                    }
                }
                devDataInJSON = [devDataInJSON stringByAppendingString: @"}]"];
                CDVPluginResult* callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:devDataInJSON];
                [callbackResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:callbackResult callbackId: self.dataEventCallbackId];
            }
        }
    }
}

- (void) selectInterface:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 2){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    MPOS_INTERACE_TYPE interfaceType = (MPOS_INTERACE_TYPE)[[command.arguments objectAtIndex:0] integerValue];
    NSString* address = [command.arguments objectAtIndex:1];
    NSInteger result = [_config selectInterface:interfaceType address:address];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) selectCommandMode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    MPOS_COMMAND_MODE mode = (MPOS_COMMAND_MODE)[[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_config selectCommandMode:mode];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    _commandMode = mode;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) openService:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult  = nil;
        if([command.arguments count] == 0){
            result = [_config openService];
        }else{
            if([command.arguments count] >= 2){
                NSInteger timeout = [[command.arguments objectAtIndex:1] integerValue];
                [_config setTimeout:timeout];
            }
            result = [_config openService:[[command.arguments objectAtIndex:0] integerValue]];
        }
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        _deviceId = [_config getDeviceId];
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) closeService:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    [self.commandDelegate runInBackground:^{
        _dataEventCallbackId = nil;
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult  = nil;
        if([command.arguments count] == 0){
            [_config closeService:0];
        }else{
            result = [_config closeService:[[command.arguments objectAtIndex:0] integerValue]];
        }
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) directIO:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSArray* array = [command.arguments objectAtIndex:0];
    NSMutableData* data = [NSMutableData data];
    for(int i = 0; i < array.count; i++){
        NSNumber* number = [array objectAtIndex:i];
        unsigned char byte = number.integerValue;
        [data appendBytes:&byte length:1];
    }
    
    NSInteger result = [_config directIO: data];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setTransaction:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger mode = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_config setTransaction: mode];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) isOpen:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    CDVPluginResult* callbackResult  = nil;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[_config isOpen]];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) getDeviceId:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    __block CDVPluginResult* callbackResult = nil;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:[_config getDeviceId]];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) searchDevices:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        __block CDVPluginResult* callbackResult  = nil;
        NSInteger result = [self.config searchDevices:^(NSArray<NSNumber*>* list) {
            if([list count]){
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:list];
                [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
                return;
            }
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }];
}

- (void) reInitCustomDeviceType:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSInteger devTypeValue = [[command.arguments objectAtIndex:0] integerValue];
    switch (devTypeValue) {
        case MPOS_DEVICE_LABEL_PRINTER:
        case MPOS_DEVICE_PRINTER:
        case MPOS_DEVICE_MSR:
        case MPOS_DEVICE_SCANNER:
        case MPOS_DEVICE_RFID:
        case MPOS_DEVICE_DALLASKEY:
        case MPOS_DEVICE_NFC:
        case MPOS_DEVICE_DISPLAY:
        case MPOS_DEVICE_USB_TO_SERIAL:
        case MPOS_DEVICE_SCALE:
            break;
        default:
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
    }
    
    MPOS_DEVICE_TYPE devType = (MPOS_DEVICE_TYPE)devTypeValue;
    NSInteger result = [_config reInitCustomDeviceType:devType];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) addCustomDevice:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 3){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger devTypeValue = [[command.arguments objectAtIndex:0] integerValue];
    switch (devTypeValue) {
        case MPOS_DEVICE_LABEL_PRINTER:
        case MPOS_DEVICE_PRINTER:
        case MPOS_DEVICE_MSR:
        case MPOS_DEVICE_SCANNER:
        case MPOS_DEVICE_RFID:
        case MPOS_DEVICE_DALLASKEY:
        case MPOS_DEVICE_NFC:
        case MPOS_DEVICE_DISPLAY:
        case MPOS_DEVICE_USB_TO_SERIAL:
        case MPOS_DEVICE_SCALE:
            break;
        default:
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
    }
    
    MPOS_DEVICE_TYPE devType = (MPOS_DEVICE_TYPE)devTypeValue;
    NSString* vid = [command.arguments objectAtIndex:1];
    NSString* pid = [command.arguments objectAtIndex:2];
    NSInteger result = [_config addCustomDevice:devType vid:vid pid:pid];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) deleteCustomDevice:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 3){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger devTypeValue = [[command.arguments objectAtIndex:0] integerValue];
    switch (devTypeValue) {
        case MPOS_DEVICE_LABEL_PRINTER:
        case MPOS_DEVICE_PRINTER:
        case MPOS_DEVICE_MSR:
        case MPOS_DEVICE_SCANNER:
        case MPOS_DEVICE_RFID:
        case MPOS_DEVICE_DALLASKEY:
        case MPOS_DEVICE_NFC:
        case MPOS_DEVICE_DISPLAY:
        case MPOS_DEVICE_USB_TO_SERIAL:
        case MPOS_DEVICE_SCALE:
            break;
        default:
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
    }
    
    MPOS_DEVICE_TYPE devType = (MPOS_DEVICE_TYPE)devTypeValue;
    NSString* vid = [command.arguments objectAtIndex:1];
    NSString* pid = [command.arguments objectAtIndex:2];
    NSInteger result = [_config deleteCustomDevice:devType vid:vid pid:pid];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) getCustomDevices:(CDVInvokedUrlCommand*)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    __block CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        NSInteger devTypeValue = [[command.arguments objectAtIndex:0] integerValue];
        switch (devTypeValue) {
            case MPOS_DEVICE_LABEL_PRINTER:
            case MPOS_DEVICE_PRINTER:
            case MPOS_DEVICE_MSR:
            case MPOS_DEVICE_SCANNER:
            case MPOS_DEVICE_RFID:
            case MPOS_DEVICE_DALLASKEY:
            case MPOS_DEVICE_NFC:
            case MPOS_DEVICE_DISPLAY:
            case MPOS_DEVICE_USB_TO_SERIAL:
            case MPOS_DEVICE_SCALE:
                break;
            default:
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
                [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
                return;
        }
        
        MPOS_DEVICE_TYPE devType = (MPOS_DEVICE_TYPE)devTypeValue;
        NSInteger result = [self.config getCustomDevices:devType vidPidListBlock:^(NSArray<NSString*>* list) {
            if([list count]){
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:list];
                [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
                return;
            }
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }];

}

- (void) getUSBDevice:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    __block CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        NSInteger deviceId = [[command.arguments objectAtIndex:0] integerValue];
        NSInteger result = [self.config getUSBDevice:deviceId vidPidBlock:^(NSString* vidPid) {
            if([vidPid length]){
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:vidPid];
                [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
                return;
            }
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }];
}

- (void) getBgateSerialNumber:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    __block CDVPluginResult* callbackResult  = nil;
    [self.commandDelegate runInBackground:^{
        NSInteger result = [self.config getBgateSerialNumber:^(NSString* sn) {
            if([sn length]){
                callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:sn];
                [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
                return;
            }
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }];
}

- (void) getSerialConfig:(CDVInvokedUrlCommand *)command{
    __block CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        NSInteger deviceId = [[command.arguments objectAtIndex:0] integerValue];
        NSInteger result = [self.config getSerialConfig:deviceId serialConfigBlock:^(NSArray<NSNumber*>* serialConfig) {
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray: serialConfig];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }];
}

- (void) setSerialConfig:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 5){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger deviceId = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger baudRate = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger dataBit = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger stopBit = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger parityBit = [[command.arguments objectAtIndex:4] integerValue];
    
    NSInteger result = MPOS_FAIL;
    if([command.arguments count] == 5){
        result = [self.config setSerialConfig:deviceId baudRate:baudRate dataBit:dataBit stopBit:stopBit parityBit:parityBit];
    }else{
        NSInteger flowControl = [[command.arguments objectAtIndex:5] integerValue];
        result = [self.config setSerialConfiguration:deviceId baudRate:baudRate dataBit:dataBit stopBit:stopBit parityBit:parityBit flowControl:flowControl];
    }
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}


@end
