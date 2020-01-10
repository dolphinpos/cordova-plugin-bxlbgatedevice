
#import "MPosControllerLabelPrinterProxy.h"
#import "MPosControllerLabelPrinter.h"
#import "MPosResults.h"
#import "MPosDefines.h"

@interface MPosControllerLabelPrinterProxy()
@property MPosControllerLabelPrinter* printer;
@property NSInteger deviceId;
@property MPOS_COMMAND_MODE commandMode;
@property NSString* statusEventCallbackId;
@property NSString* dataEventCallbackId;
@end

@implementation MPosControllerLabelPrinterProxy

- (void)pluginInitialize{
    _printer = [MPosControllerLabelPrinter new];
    _dataEventCallbackId = nil;
    _statusEventCallbackId = nil;
    _deviceId = -1;
    _commandMode = MPOS_COMMAND_MODE_DEFAULT;
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
    if([deviceId integerValue] != [_printer getDeviceId])
        return;
    if ([[notification name] isEqualToString: @"StatusUpdateEvent"]){
        NSMutableArray *allKeys = [[[notification userInfo] allKeys] mutableCopy];
        for (NSString *key in allKeys) {
            if(![[_printer getNotificationKey] isEqualToString: key])
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
            if(![[_printer getNotificationKey] isEqualToString: key])
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
    NSInteger result = [_printer selectInterface:interfaceType address:address];
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
    NSInteger result = [_printer selectCommandMode:mode];
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
            result = [_printer openService];
        }else{
            NSInteger devId = [[command.arguments objectAtIndex:0] integerValue];
            if(devId < 1 || devId >= 10)
                devId = -1;
            if([command.arguments count] >= 2){
                NSInteger timeout = [[command.arguments objectAtIndex:1] integerValue];
                [_printer setTimeout:timeout];
            }
            result = [_printer openService:devId];
        }
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        
        _deviceId = [_printer getDeviceId];
        
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) closeService:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    [self.commandDelegate runInBackground:^{
        _dataEventCallbackId = nil;
        _statusEventCallbackId = nil;
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult  = nil;
        if([command.arguments count] == 0){
            [_printer closeService:0];
        }else{
            result = [_printer closeService:[[command.arguments objectAtIndex:0] integerValue]];
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
    
    NSInteger result = [_printer directIO: data];
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
    NSInteger result = [_printer setTransaction: mode];
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
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[_printer isOpen]];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) getDeviceId:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    CDVPluginResult* callbackResult  = nil;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:[_printer getDeviceId]];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) checkPrinterStatus:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult = nil;
        __block NSInteger printerStatus = 0;
        result = [self.printer checkPrinterStatus:^(NSInteger status) {
            printerStatus = status;
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:printerStatus];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) printBuffer:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger copies = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer printBuffer:copies];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printRawData:(CDVInvokedUrlCommand *)command{
    return [self directIO:command];
}

//  GETTER APIs
- (void) getModelName:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult = nil;
        __block NSString* name = 0;
        result = [self.printer getModelName:^(NSString* modelName) {
            name = modelName;
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:name];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) getFirmwareVersion:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult = nil;
        __block NSString* version = 0;
        result = [self.printer getFirmwareVersion:^(NSString* firmwareVersion) {
            version = firmwareVersion;
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

//  SETTER APIs
- (void) setCharacterset:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 2){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger charSet = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger internationalcharSet = [[command.arguments objectAtIndex:1] integerValue];
    
    switch (charSet) {
        case 437: charSet = MPOS_CODEPAGE_PC437;       break;
        case 850: charSet = MPOS_CODEPAGE_PC850;       break;
        case 860: charSet = MPOS_CODEPAGE_PC860;       break;
        case 863: charSet = MPOS_CODEPAGE_PC863;       break;
        case 865: charSet = MPOS_CODEPAGE_PC865;       break;
        case 1252: charSet = MPOS_CODEPAGE_WPC1252;    break;
        case 857: charSet = MPOS_CODEPAGE_PC857;       break;
        case 737: charSet = MPOS_CODEPAGE_PC737;       break;
        case 1250: charSet = MPOS_CODEPAGE_WPC1250;    break;
        case 1253: charSet = MPOS_CODEPAGE_WPC1253;    break;
        case 1254: charSet = MPOS_CODEPAGE_WPC1254;    break;
        case 855: charSet = MPOS_CODEPAGE_PC855;       break;
        case 862: charSet = MPOS_CODEPAGE_PC862;       break;
        case 866: charSet = MPOS_CODEPAGE_PC866;       break;
        case 1251: charSet = MPOS_CODEPAGE_WPC1251;    break;
        case 1255: charSet = MPOS_CODEPAGE_WPC1255;    break;
        case 928: charSet = MPOS_CODEPAGE_PC928;       break;
        case 864: charSet = MPOS_CODEPAGE_PC864;       break;
        case 775: charSet = MPOS_CODEPAGE_PC775;       break;
        case 1257: charSet = MPOS_CODEPAGE_WPC1257;    break;
        case 858: charSet = MPOS_CODEPAGE_PC858;       break;
            // EAST ASIA
        case 949: charSet = MPOS_CODEPAGE_KS5601;      break;
        case 932: charSet = MPOS_CODEPAGE_SHIFTJIS;    break;
        case 950: charSet = MPOS_CODEPAGE_BIG5;        break;
        case 936: charSet = MPOS_CODEPAGE_GB2312;      break;
        case 54936: charSet = MPOS_CODEPAGE_GB18030;   break;
        default:
            charSet = MPOS_CODEPAGE_PC437;
            break;
    }
    NSInteger result = [_printer setCharacterset:charSet internationalCharset:internationalcharSet];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];

}
- (void) setTextEncoding:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger encoding = [[command.arguments objectAtIndex:0] integerValue];
    switch (encoding) {
        case 437: encoding = MPOS_CODEPAGE_PC437;       break;
        case 850: encoding = MPOS_CODEPAGE_PC850;       break;
        case 860: encoding = MPOS_CODEPAGE_PC860;       break;
        case 863: encoding = MPOS_CODEPAGE_PC863;       break;
        case 865: encoding = MPOS_CODEPAGE_PC865;       break;
        case 1252: encoding = MPOS_CODEPAGE_WPC1252;    break;
        case 857: encoding = MPOS_CODEPAGE_PC857;       break;
        case 737: encoding = MPOS_CODEPAGE_PC737;       break;
        case 1250: encoding = MPOS_CODEPAGE_WPC1250;    break;
        case 1253: encoding = MPOS_CODEPAGE_WPC1253;    break;
        case 1254: encoding = MPOS_CODEPAGE_WPC1254;    break;
        case 855: encoding = MPOS_CODEPAGE_PC855;       break;
        case 862: encoding = MPOS_CODEPAGE_PC862;       break;
        case 866: encoding = MPOS_CODEPAGE_PC866;       break;
        case 1251: encoding = MPOS_CODEPAGE_WPC1251;    break;
        case 1255: encoding = MPOS_CODEPAGE_WPC1255;    break;
        case 928: encoding = MPOS_CODEPAGE_PC928;       break;
        case 864: encoding = MPOS_CODEPAGE_PC864;       break;
        case 775: encoding = MPOS_CODEPAGE_PC775;       break;
        case 1257: encoding = MPOS_CODEPAGE_WPC1257;    break;
        case 858: encoding = MPOS_CODEPAGE_PC858;       break;
            // EAST ASIA
        case 949: encoding = MPOS_CODEPAGE_KS5601;      break;
        case 932: encoding = MPOS_CODEPAGE_SHIFTJIS;    break;
        case 950: encoding = MPOS_CODEPAGE_BIG5;        break;
        case 936: encoding = MPOS_CODEPAGE_GB2312;      break;
        case 54936: encoding = MPOS_CODEPAGE_GB18030;   break;
        default:
            encoding = MPOS_CODEPAGE_PC437;
            break;
    }
    NSInteger result = [_printer setTextEncoding:encoding];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setPrintingType:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* typeValue = [command.arguments objectAtIndex:0];
    char type = MPOS_LABEL_PRINTING_TYPE_DIRECT_THERMAL;
    if([typeValue isEqualToString:@"t"])          type = MPOS_LABEL_PRINTING_TYPE_THERMAL_TRANSFER;
    else if([typeValue isEqualToString:@"d"])     type = MPOS_LABEL_PRINTING_TYPE_DIRECT_THERMAL;
    NSInteger result = [_printer setPrintingType: type];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setMargin:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 2){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger horizontalMargin = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger verticalMargin = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger result = [_printer setMargin:horizontalMargin verticalMargin:verticalMargin];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setBackFeedOption:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 2){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    BOOL enable = [[command.arguments objectAtIndex:0] boolValue];
    NSInteger stepQuantity = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger result = [_printer setBackFeedOption:enable stepQuantity:stepQuantity];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setLength:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 4){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger labelLength = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger gapLength = [[command.arguments objectAtIndex:1] integerValue];
    NSString* mediaType = [command.arguments objectAtIndex:2];
    char type = MPOS_LABEL_MEDIA_TYPE_GAP;
    if([mediaType isEqualToString:@"G"])    type = MPOS_LABEL_MEDIA_TYPE_GAP;
    if([mediaType isEqualToString:@"C"])    type = MPOS_LABEL_MEDIA_TYPE_CONTINUOUS;
    if([mediaType isEqualToString:@"B"])    type = MPOS_LABEL_MEDIA_TYPE_BLACK_MARK;
    NSInteger offsetLength = [[command.arguments objectAtIndex:3] integerValue];
    
    NSInteger result = [_printer setLength:labelLength gapLength:gapLength mediaType:type offsetLength:offsetLength];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}


- (void) setWidth:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger width = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setWidth:width];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setBufferMode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    BOOL dobleBufferMode = [[command.arguments objectAtIndex:0] boolValue];
    NSInteger result = [_printer setBufferMode:dobleBufferMode];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setSpeed:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger speed = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setSpeed:speed];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setDensity:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger density = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setDensity:density];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setOrientation:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* orientationValue = [command.arguments objectAtIndex:0];
    char orientation = MPOS_LABEL_PRINTING_DIRECTION_TOP_TO_BOTTOM;
    if([orientationValue isEqualToString:@"T"])    orientation = MPOS_LABEL_PRINTING_DIRECTION_TOP_TO_BOTTOM;
    if([orientationValue isEqualToString:@"B"])    orientation = MPOS_LABEL_PRINTING_DIRECTION_BOTTOM_TO_TOP;
    
    NSInteger result = [_printer setOrientation:orientation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setOffset:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger offset = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setOffset:offset];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setCuttingPosition:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSInteger position = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setCuttingPosition:position];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setAutoCutter:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    BOOL enable = [[command.arguments objectAtIndex:0] boolValue];
    if(enable){
        NSInteger cuttingPeriod = [[command.arguments objectAtIndex:1] integerValue];
        NSInteger result = [_printer setAutoCutter:enable cuttingPeriod: cuttingPeriod];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }else{
        NSInteger result = [_printer directIO:[NSData dataWithBytes:"CUTn\x0d\x0a" length:6]];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

// PRINTING APIs
- (void) drawImageWithBase64:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 7){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* imageInBase64 = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger width = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger brightness = [[command.arguments objectAtIndex:4] integerValue];
    BOOL dither = [[command.arguments objectAtIndex:5] boolValue];
    BOOL compress = [[command.arguments objectAtIndex:6] boolValue];
    
    NSInteger result = [_printer drawImageWithBase64:imageInBase64 xPos:x yPos:y width:width brightness:brightness isDithering:dither isCompress:compress];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawImage:(CDVInvokedUrlCommand *)command{
    CDVPluginResult* callbackResult = nil;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_NOT_SUPPORT];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawImageFile:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 7){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* filePath = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger width = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger brightness = [[command.arguments objectAtIndex:4] integerValue];
    BOOL dither = [[command.arguments objectAtIndex:5] boolValue];
    BOOL compress = [[command.arguments objectAtIndex:6] boolValue];
    
    NSInteger result = [_printer drawImageFile:filePath xPos:x yPos:y width:width brightness:brightness isDithering:dither isCompress:compress];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawTextDeviceFont:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 12){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    char font = MPOS_LABEL_DEVICE_FONT_6PT;
    NSString* fontValue = [command.arguments objectAtIndex:3];
    if([fontValue isEqualToString:@"0"])          font = MPOS_LABEL_DEVICE_FONT_6PT;
    else if([fontValue isEqualToString:@"1"])     font = MPOS_LABEL_DEVICE_FONT_8PT;
    else if([fontValue isEqualToString:@"2"])     font = MPOS_LABEL_DEVICE_FONT_10PT;
    else if([fontValue isEqualToString:@"3"])     font = MPOS_LABEL_DEVICE_FONT_12PT;
    else if([fontValue isEqualToString:@"4"])     font = MPOS_LABEL_DEVICE_FONT_15PT;
    else if([fontValue isEqualToString:@"5"])     font = MPOS_LABEL_DEVICE_FONT_20PT;
    else if([fontValue isEqualToString:@"6"])     font = MPOS_LABEL_DEVICE_FONT_30PT;
    else if([fontValue isEqualToString:@"7"])     font = MPOS_LABEL_DEVICE_FONT_14PT;
    else if([fontValue isEqualToString:@"8"])     font = MPOS_LABEL_DEVICE_FONT_18PT;
    else if([fontValue isEqualToString:@"9"])     font = MPOS_LABEL_DEVICE_FONT_24PT;
    else if([fontValue isEqualToString:@"a"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN1;
    else if([fontValue isEqualToString:@"b"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN2;
    else if([fontValue isEqualToString:@"c"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN3;
    else if([fontValue isEqualToString:@"d"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN4;
    else if([fontValue isEqualToString:@"e"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN5;
    else if([fontValue isEqualToString:@"f"])     font = MPOS_LABEL_DEVICE_FONT_KOREAN6;
    else if([fontValue isEqualToString:@"m"])     font = MPOS_LABEL_DEVICE_FONT_GB2312;
    else if([fontValue isEqualToString:@"n"])     font = MPOS_LABEL_DEVICE_FONT_BIG5;
    else if([fontValue isEqualToString:@"j"])     font = MPOS_LABEL_DEVICE_FONT_SHIFT_JIS;
    NSInteger width = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger rightSpace = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:7] integerValue];
    BOOL reverse = [[command.arguments objectAtIndex:8] boolValue];
    BOOL bold = [[command.arguments objectAtIndex:9] boolValue];
    BOOL rightToLeft = [[command.arguments objectAtIndex:10] boolValue];
    NSInteger alignment = [[command.arguments objectAtIndex:11] integerValue];
    
    NSInteger result = [_printer drawTextDeviceFont:data xPos:x yPos:y fontSelection:font fontWidth:width fontHeight:height rightSpace:rightSpace rotation:rotation reverse:reverse bold:bold rightToLeft:rightToLeft alignment:alignment];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawTextVectorFont:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 13){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    char font = MPOS_LABEL_VECTOR_FONT_ASCII;
    NSString* fontValue = [command.arguments objectAtIndex:3];
    if([fontValue isEqualToString:@"U"])          font = MPOS_LABEL_VECTOR_FONT_ASCII;
    else if([fontValue isEqualToString:@"K"])     font = MPOS_LABEL_VECTOR_FONT_KS5601;
    else if([fontValue isEqualToString:@"B"])     font = MPOS_LABEL_VECTOR_FONT_BIG5;
    else if([fontValue isEqualToString:@"G"])     font = MPOS_LABEL_VECTOR_FONT_GB2312;
    else if([fontValue isEqualToString:@"J"])     font = MPOS_LABEL_VECTOR_FONT_SHIFT_JIS;
    else if([fontValue isEqualToString:@"a"])     font = MPOS_LABEL_VECTOR_FONT_OCR_A;
    else if([fontValue isEqualToString:@"b"])     font = MPOS_LABEL_VECTOR_FONT_OCR_B;
    NSInteger width = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger rightSpace = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:7] integerValue];
    BOOL reverse = [[command.arguments objectAtIndex:8] boolValue];
    BOOL bold = [[command.arguments objectAtIndex:9] boolValue];
    BOOL italic = [[command.arguments objectAtIndex:10] boolValue];
    BOOL rightToLeft = [[command.arguments objectAtIndex:11] boolValue];
    NSInteger alignment = [[command.arguments objectAtIndex:12] integerValue];

    NSInteger result = [_printer drawTextVectorFont:data xPos:x yPos:y fontSelection:font fontWidth:width fontHeight:height rightSpace:rightSpace rotation:rotation reverse:reverse bold:bold italic:italic rightToLeft:rightToLeft alignment:alignment];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcode1D:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 10){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger type = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger hri = [[command.arguments objectAtIndex:7] integerValue];
    NSInteger quietZoneWidth = [[command.arguments objectAtIndex:8] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:9] integerValue];
    
    NSInteger result = [_printer drawBarcode1D:data xPos:x yPos:y barcodeType:type widthNarrow:widthNarrow widthWide:widthWide height:height hri:hri quietZoneWidth:quietZoneWidth rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeMaxiCode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 4){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger mode = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger result = [_printer drawBarcodeMaxiCode:data xPos:x yPos:y mode:mode];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodePDF417:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 12){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger maximumRowCount = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger maximumColumnCount = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger errorCorrectionLevel = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger dataCompressionMethod = [[command.arguments objectAtIndex:6] integerValue];
    BOOL hri = [[command.arguments objectAtIndex:7] boolValue];
    NSInteger startPosition = [[command.arguments objectAtIndex:8] integerValue];
    NSInteger moduleWidth = [[command.arguments objectAtIndex:9] integerValue];
    NSInteger barHeight = [[command.arguments objectAtIndex:10] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:11] integerValue];
    
    NSInteger result = [_printer drawBarcodePDF417:data xPos:x yPos:y maximumRowCount:maximumRowCount maximumColumnCount:maximumColumnCount errorCorrectionLevel:errorCorrectionLevel dataCompressionMethod:dataCompressionMethod hri:hri startPosition:startPosition moduleWidth:moduleWidth barHeight:barHeight rotation:rotation];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeQRCode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 7){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger size = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger model = [[command.arguments objectAtIndex:4] integerValue];
    if(model == 1 || model == 49) model = MPOS_LABEL_QRCODE_MODEL_1;
    if(model == 2 || model == 50) model = MPOS_LABEL_QRCODE_MODEL_2;
    NSInteger eccLevel = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:6] integerValue];
    
    NSInteger result = [_printer drawBarcodeQRCode:data xPos:x yPos:y size:size model:model eccLevel:eccLevel rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeDataMatrix:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 6){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger size = [[command.arguments objectAtIndex:3] integerValue];
    BOOL reverse = [[command.arguments objectAtIndex:4] boolValue];
    NSInteger rotation = [[command.arguments objectAtIndex:5] integerValue];
    
    NSInteger result = [_printer drawBarcodeDataMatrix:data xPos:x yPos:y size:size reverse:reverse rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeAztec:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 10){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger size = [[command.arguments objectAtIndex:3] integerValue];
    BOOL extendedChannel = [[command.arguments objectAtIndex:4] boolValue];
    NSInteger eccLevel = [[command.arguments objectAtIndex:5] integerValue];
    BOOL menuSymbol = [[command.arguments objectAtIndex:6] boolValue];
    NSInteger numberOfSymbols = [[command.arguments objectAtIndex:7] integerValue];
    NSString* optionalID = [command.arguments objectAtIndex:8];
    NSInteger rotation = [[command.arguments objectAtIndex:9] integerValue];
    
    NSInteger result = [_printer drawBarcodeAztec:data xPos:x yPos:y size:size extendedChannel:extendedChannel eccLevel:eccLevel menuSymbol:menuSymbol numberOfSymbols:numberOfSymbols optionalID:optionalID rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeCode49:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 9){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger hri = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger startingMode = [[command.arguments objectAtIndex:7] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:8] integerValue];

    NSInteger result = [_printer drawBarcodeCode49:data xPos:x yPos:y widthNarrow:widthNarrow widthWide:widthWide height:height hri:hri startingMode:startingMode rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeCodaBlock:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 10){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    BOOL securityLevel = [[command.arguments objectAtIndex:6] boolValue];
    NSInteger dataColumns = [[command.arguments objectAtIndex:7] integerValue];
    
    char mode = MPOS_LABEL_CODABLOCK_MODE_A;
    NSString* modeValue = [command.arguments objectAtIndex:8];
    if([modeValue isEqualToString:@"A"]) mode = MPOS_LABEL_CODABLOCK_MODE_A;
    else if([modeValue isEqualToString:@"E"]) mode = MPOS_LABEL_CODABLOCK_MODE_E;
    else if([modeValue isEqualToString:@"F"]) mode = MPOS_LABEL_CODABLOCK_MODE_F;
    NSInteger rowsToEncode = [[command.arguments objectAtIndex:9] integerValue];
    
    NSInteger result = [_printer drawBarcodeCodaBlock:data xPos:x yPos:y widthNarrow:widthNarrow widthWide:widthWide height:height securityLevel:securityLevel dataColumns:dataColumns mode:mode rowsToEncode:rowsToEncode];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeMicroPDF:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 7){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger moduleWidth = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger mode = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:6] integerValue];

    NSInteger result = [_printer drawBarcodeMicroPDF:data xPos:x yPos:y moduleWidth:moduleWidth height:height mode:mode rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeIMB:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 5){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    BOOL hri = [[command.arguments objectAtIndex:3] boolValue];
    NSInteger rotation = [[command.arguments objectAtIndex:4] integerValue];

    NSInteger result = [_printer drawBarcodeIMB:data xPos:x yPos:y hri:hri rotation:rotation];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeMSI:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 10){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger checkDigit = [[command.arguments objectAtIndex:6] integerValue];
    BOOL printCheckDigit = [[command.arguments objectAtIndex:7] boolValue];
    NSInteger hri = [[command.arguments objectAtIndex:8] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:9] integerValue];

    NSInteger result = [_printer drawBarcodeMSI:data xPos:x yPos:y widthNarrow:widthNarrow widthWide:widthWide height:height checkDigit:checkDigit printCheckDigit:printCheckDigit hri:hri rotation:rotation];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}


- (void) drawBarcodePlessey:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 9){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    BOOL printCheckDigit = [[command.arguments objectAtIndex:6] boolValue];
    NSInteger hri = [[command.arguments objectAtIndex:7] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:8] integerValue];

    NSInteger result = [_printer drawBarcodePlessey:data xPos:x yPos:y widthNarrow:widthNarrow widthWide:widthWide height:height printCheckDigit:printCheckDigit hri:hri rotation:rotation];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBarcodeTLC39:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 9){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger widthNarrow = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger widthWide = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger rowHeightOfMicroPDF417 = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger narrowWidthOfMicroPDF417 = [[command.arguments objectAtIndex:7] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:8] integerValue];

    NSInteger result = [_printer drawBarcodeTLC39:data xPos:x yPos:y widthNarrow:widthNarrow widthWide:widthWide height:height rowHeightOfMicroPDF417:rowHeightOfMicroPDF417 narrowWidthOfMicroPDF417:narrowWidthOfMicroPDF417 rotation:rotation];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}


- (void) drawBarcodeRSS:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 9){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger x = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger barcodeType = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger magnification = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger separatorHeight = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger segmentWidth = [[command.arguments objectAtIndex:7] integerValue];
    NSInteger rotation = [[command.arguments objectAtIndex:8] integerValue];

    NSInteger result = [_printer drawBarcodeRSS:data xPos:x yPos:y barcodeType:barcodeType magnification:magnification separatorHeight:separatorHeight height:height segmentWidth:segmentWidth rotation:rotation];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawBlock:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 6){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSInteger x1 = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y1 = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger x2 = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger y2 = [[command.arguments objectAtIndex:3] integerValue];
    char option = MPOS_LABEL_DRAW_BLOCK_OPTION_LINE_OVERWRITING;
    NSString* optionValue = [command.arguments objectAtIndex:4];
    if([optionValue isEqualToString:@"O"])          option = MPOS_LABEL_DRAW_BLOCK_OPTION_LINE_OVERWRITING;
    else if([optionValue isEqualToString:@"E"])     option = MPOS_LABEL_DRAW_BLOCK_OPTION_LINE_EXCLUSIVE_OR;
    else if([optionValue isEqualToString:@"D"])     option = MPOS_LABEL_DRAW_BLOCK_OPTION_LINE_DELETE;
    else if([optionValue isEqualToString:@"S"])     option = MPOS_LABEL_DRAW_BLOCK_OPTION_SLOPE;
    else if([optionValue isEqualToString:@"B"])     option = MPOS_LABEL_DRAW_BLOCK_OPTION_BOX;
    NSInteger thick = [[command.arguments objectAtIndex:5] integerValue];

    NSInteger result = [_printer drawBlock:x1 startPosY:y1 endPosX:x2 endPosY:y2 option:option thickness:thick];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) drawCircle:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 4){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSInteger x = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger size = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger multiplier = [[command.arguments objectAtIndex:3] integerValue];

    NSInteger result = [_printer drawCircle:x startPosY:y size:size multiplier:multiplier];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

@end
