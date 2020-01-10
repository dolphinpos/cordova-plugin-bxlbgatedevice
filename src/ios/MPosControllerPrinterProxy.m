
#import "MPosControllerPrinterProxy.h"
#import "MPosControllerPrinter.h"
#import "MPosResults.h"
#import "MPosDefines.h"


@interface MPosControllerPrinterProxy()
@property NSInteger deviceId;
@property MPOS_COMMAND_MODE commandMode;
@property MPosControllerPrinter* printer;
@property NSString* statusEventCallbackId;
@property NSString* dataEventCallbackId;
@end

@implementation MPosControllerPrinterProxy

- (void)pluginInitialize{
    _printer = [MPosControllerPrinter new];
    _statusEventCallbackId = nil;
    _dataEventCallbackId = nil;
    _deviceId = -1;
    _commandMode = MPOS_COMMAND_MODE_DEFAULT;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNotificationHandler:) name: @"DataEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceNotificationHandler:) name: @"StatusUpdateEvent" object:nil];
}

- (void) setStatusUpdateEvent:(CDVInvokedUrlCommand*)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    _statusEventCallbackId = command.callbackId;
    //_statusEventCallbackId = [[command.arguments objectAtIndex:0] callbackId];
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
    //_dataEventCallbackId = [[command.arguments objectAtIndex:0] callbackId];
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
            if(devId < 10 || devId >= 20)
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
        _statusEventCallbackId = nil;
        _dataEventCallbackId = nil;
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

- (void) setPagemode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger mode = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setPagemode:mode];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setPagemodePrintArea:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 4){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger x = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger width = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger result = [_printer setPagemodePrintArea:x y:y width:width height:height];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setPagemodeDirection:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger direction = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setPagemodeDirection:direction];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setPagemodePosition:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 2){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger x = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger result = [_printer setPagemodePosition:x y:y];
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
        case 866: encoding = MPOS_CODEPAGE_PC866;       break;
        case 852: encoding = MPOS_CODEPAGE_PC852;       break;
        case 858: encoding = MPOS_CODEPAGE_PC858;       break;
        case 862: encoding = MPOS_CODEPAGE_PC862;       break;
        case 1253: encoding = MPOS_CODEPAGE_WPC1253;    break;
        case 1254: encoding = MPOS_CODEPAGE_WPC1254;    break;
        case 1257: encoding = MPOS_CODEPAGE_WPC1257;    break;
        case 1251: encoding = MPOS_CODEPAGE_WPC1251;    break;
        case 737: encoding = MPOS_CODEPAGE_PC737;       break;
        case 775: encoding = MPOS_CODEPAGE_PC775;       break;
        case 1255: encoding = MPOS_CODEPAGE_WPC1255;    break;
        case 34: encoding = MPOS_CODEPAGE_THAI11;       break;
        case 31: encoding = MPOS_CODEPAGE_THAI14;       break;
        case 39: encoding = MPOS_CODEPAGE_THAI16;       break;
        case 35: encoding = MPOS_CODEPAGE_THAI18;       break;
        case 23: encoding = MPOS_CODEPAGE_THAI42;       break;
        case 855: encoding = MPOS_CODEPAGE_PC855;       break;
        case 857: encoding = MPOS_CODEPAGE_PC857;       break;
        case 928: encoding = MPOS_CODEPAGE_PC928;       break;
        case 1258: encoding = MPOS_CODEPAGE_WPC1258;    break;
        case 1250: encoding = MPOS_CODEPAGE_WPC1250;    break;
        case 28605: encoding = MPOS_CODEPAGE_LATIN9;    break;
        case 49: encoding = MPOS_CODEPAGE_TCVN3;        break;
        case 50: encoding = MPOS_CODEPAGE_TCVN3_CAPITAL;break;
        case 51: encoding = MPOS_CODEPAGE_VISCII;       break;
        case 864: encoding = MPOS_CODEPAGE_PC864;       break;
        case 1256: encoding = MPOS_CODEPAGE_WPC1256;    break;
        case 42: encoding = MPOS_CODEPAGE_KHMER;        break;
        case 27: encoding = MPOS_CODEPAGE_FARSI;        break;
        case 28: encoding = MPOS_CODEPAGE_FARSI;        break;
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

- (void) setCharacterset:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger characterSet = [[command.arguments objectAtIndex:0] integerValue];
    switch (characterSet) {
        case 437: characterSet = MPOS_CODEPAGE_PC437;       break;
        case 850: characterSet = MPOS_CODEPAGE_PC850;       break;
        case 860: characterSet = MPOS_CODEPAGE_PC860;       break;
        case 863: characterSet = MPOS_CODEPAGE_PC863;       break;
        case 865: characterSet = MPOS_CODEPAGE_PC865;       break;
        case 1252: characterSet = MPOS_CODEPAGE_WPC1252;    break;
        case 866: characterSet = MPOS_CODEPAGE_PC866;       break;
        case 852: characterSet = MPOS_CODEPAGE_PC852;       break;
        case 858: characterSet = MPOS_CODEPAGE_PC858;       break;
        case 862: characterSet = MPOS_CODEPAGE_PC862;       break;
        case 1253: characterSet = MPOS_CODEPAGE_WPC1253;    break;
        case 1254: characterSet = MPOS_CODEPAGE_WPC1254;    break;
        case 1257: characterSet = MPOS_CODEPAGE_WPC1257;    break;
        case 1251: characterSet = MPOS_CODEPAGE_WPC1251;    break;
        case 737: characterSet = MPOS_CODEPAGE_PC737;       break;
        case 775: characterSet = MPOS_CODEPAGE_PC775;       break;
        case 1255: characterSet = MPOS_CODEPAGE_WPC1255;    break;
        case 34: characterSet = MPOS_CODEPAGE_THAI11;       break;
        case 31: characterSet = MPOS_CODEPAGE_THAI14;       break;
        case 39: characterSet = MPOS_CODEPAGE_THAI16;       break;
        case 35: characterSet = MPOS_CODEPAGE_THAI18;       break;
        case 23: characterSet = MPOS_CODEPAGE_THAI42;       break;
        case 855: characterSet = MPOS_CODEPAGE_PC855;       break;
        case 857: characterSet = MPOS_CODEPAGE_PC857;       break;
        case 928: characterSet = MPOS_CODEPAGE_PC928;       break;
        case 1258: characterSet = MPOS_CODEPAGE_WPC1258;    break;
        case 1250: characterSet = MPOS_CODEPAGE_WPC1250;    break;
        case 28605: characterSet = MPOS_CODEPAGE_LATIN9;    break;
        case 49: characterSet = MPOS_CODEPAGE_TCVN3;        break;
        case 50: characterSet = MPOS_CODEPAGE_TCVN3_CAPITAL;break;
        case 51: characterSet = MPOS_CODEPAGE_VISCII;       break;
        case 864: characterSet = MPOS_CODEPAGE_PC864;       break;
        case 1256: characterSet = MPOS_CODEPAGE_WPC1256;    break;
        case 42: characterSet = MPOS_CODEPAGE_KHMER;        break;
        case 27: characterSet = MPOS_CODEPAGE_FARSI;        break;
        case 28: characterSet = MPOS_CODEPAGE_FARSI;        break;
            // EAST ASIA
        case 949: characterSet = MPOS_CODEPAGE_KS5601;      break;
        case 932: characterSet = MPOS_CODEPAGE_SHIFTJIS;    break;
        case 950: characterSet = MPOS_CODEPAGE_BIG5;        break;
        case 936: characterSet = MPOS_CODEPAGE_GB2312;      break;
        case 54936: characterSet = MPOS_CODEPAGE_GB18030;   break;
        default:
            characterSet = MPOS_CODEPAGE_PC437;
            break;
    }
    NSInteger result = [_printer setCharacterset:characterSet];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) setInternationalCharacterset:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger characterSet = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger result = [_printer setInternationalCharacterset:characterSet];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printText:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* text = [command.arguments objectAtIndex:0];
    NSInteger result = MPOS_FAIL;
    if([command.arguments count] == 1){
        result = [_printer printText: text];
    }else{
        NSDictionary* fontAttDict = [command.arguments objectAtIndex:1];
        MPOS_FONT_ATTRIBUTES fontAtt;
        fontAtt.height = (MPOS_FONT_SIZE_HEIGHT)[fontAttDict[@"height"]integerValue];
        fontAtt.width = (MPOS_FONT_SIZE_WIDTH)[fontAttDict[@"width"]integerValue];
        fontAtt.alignment = (MPOS_ALIGNMENT)[fontAttDict[@"alignment"] integerValue];
        fontAtt.fontType = (MPOS_FONT_TYPE)[fontAttDict[@"fontType"] integerValue];
        fontAtt.underLine = (MPOS_FONT_UNDERLINE)[fontAttDict[@"underline"] integerValue];
        fontAtt.bold = [fontAttDict[@"bold"] boolValue];
        fontAtt.color = [fontAttDict[@"color"] boolValue];
        fontAtt.reverse = [fontAttDict[@"reverse"] boolValue];
        fontAtt.codepage = [fontAttDict[@"codePage"] integerValue];
        
        switch (fontAtt.codepage) {
            case 437: fontAtt.codepage = MPOS_CODEPAGE_PC437;       break;
            case 850: fontAtt.codepage = MPOS_CODEPAGE_PC850;       break;
            case 860: fontAtt.codepage = MPOS_CODEPAGE_PC860;       break;
            case 863: fontAtt.codepage = MPOS_CODEPAGE_PC863;       break;
            case 865: fontAtt.codepage = MPOS_CODEPAGE_PC865;       break;
            case 1252: fontAtt.codepage = MPOS_CODEPAGE_WPC1252;    break;
            case 866: fontAtt.codepage = MPOS_CODEPAGE_PC866;       break;
            case 852: fontAtt.codepage = MPOS_CODEPAGE_PC852;       break;
            case 858: fontAtt.codepage = MPOS_CODEPAGE_PC858;       break;
            case 862: fontAtt.codepage = MPOS_CODEPAGE_PC862;       break;
            case 1253: fontAtt.codepage = MPOS_CODEPAGE_WPC1253;    break;
            case 1254: fontAtt.codepage = MPOS_CODEPAGE_WPC1254;    break;
            case 1257: fontAtt.codepage = MPOS_CODEPAGE_WPC1257;    break;
            case 1251: fontAtt.codepage = MPOS_CODEPAGE_WPC1251;    break;
            case 737: fontAtt.codepage = MPOS_CODEPAGE_PC737;       break;
            case 775: fontAtt.codepage = MPOS_CODEPAGE_PC775;       break;
            case 1255: fontAtt.codepage = MPOS_CODEPAGE_WPC1255;    break;
            case 34: fontAtt.codepage = MPOS_CODEPAGE_THAI11;       break;
            case 31: fontAtt.codepage = MPOS_CODEPAGE_THAI14;       break;
            case 39: fontAtt.codepage = MPOS_CODEPAGE_THAI16;       break;
            case 35: fontAtt.codepage = MPOS_CODEPAGE_THAI18;       break;
            case 23: fontAtt.codepage = MPOS_CODEPAGE_THAI42;       break;
            case 855: fontAtt.codepage = MPOS_CODEPAGE_PC855;       break;
            case 857: fontAtt.codepage = MPOS_CODEPAGE_PC857;       break;
            case 928: fontAtt.codepage = MPOS_CODEPAGE_PC928;       break;
            case 1258: fontAtt.codepage = MPOS_CODEPAGE_WPC1258;    break;
            case 1250: fontAtt.codepage = MPOS_CODEPAGE_WPC1250;    break;
            case 28605: fontAtt.codepage = MPOS_CODEPAGE_LATIN9;    break;
            case 49: fontAtt.codepage = MPOS_CODEPAGE_TCVN3;        break;
            case 50: fontAtt.codepage = MPOS_CODEPAGE_TCVN3_CAPITAL;break;
            case 51: fontAtt.codepage = MPOS_CODEPAGE_VISCII;       break;
            case 864: fontAtt.codepage = MPOS_CODEPAGE_PC864;       break;
            case 1256: fontAtt.codepage = MPOS_CODEPAGE_WPC1256;    break;
            case 42: fontAtt.codepage = MPOS_CODEPAGE_KHMER;        break;
            case 27: fontAtt.codepage = MPOS_CODEPAGE_FARSI;        break;
            case 28: fontAtt.codepage = MPOS_CODEPAGE_FARSI;        break;
            // EAST ASIA
            case 949: fontAtt.codepage = MPOS_CODEPAGE_KS5601;      break;
            case 932: fontAtt.codepage = MPOS_CODEPAGE_SHIFTJIS;    break;
            case 950: fontAtt.codepage = MPOS_CODEPAGE_BIG5;        break;
            case 936: fontAtt.codepage = MPOS_CODEPAGE_GB2312;      break;
            case 54936: fontAtt.codepage = MPOS_CODEPAGE_GB18030;   break;
            default:
                fontAtt.codepage = MPOS_CODEPAGE_PC437;
                break;
        }
        result = [_printer printText:text fontAttributes:fontAtt];
    }
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) cutPaper:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    CDVPluginResult* callbackResult  = nil;
    NSInteger result = MPOS_FAIL;
    if([command.arguments count] == 0){
        result = [_printer cutPaper: MPOS_PRINTER_CUTPAPER];
    }else{
        switch ([[command.arguments objectAtIndex:0] integerValue]){
            case MPOS_PRINTER_FEEDCUT:
                result = [_printer cutPaper: MPOS_PRINTER_FEEDCUT];
                break;
            default:
                result = [_printer cutPaper: MPOS_PRINTER_CUTPAPER];
                break;
        }
    }
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) openDrawer:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    switch ([[command.arguments objectAtIndex:0] integerValue]){
        case MPOS_CASHDRAWER_PIN2:
            result = [_printer openDrawer:MPOS_CASHDRAWER_PIN2];
            break;
        case MPOS_CASHDRAWER_PIN5:
            result = [_printer openDrawer:MPOS_CASHDRAWER_PIN5];
            break;
        default:
            result = MPOS_FAIL_INVALID_PARAMETER;
            break;
    }
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) asbEnable:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 1){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    result = [_printer asbEnable: [[command.arguments objectAtIndex:0] boolValue]];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printQRCode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 5){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger model = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger moduleSize = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger eccLevel = [[command.arguments objectAtIndex:4] integerValue];

    result = [_printer printQRCode:data model:model alignment:alignment moduleSize:moduleSize eccLevel:eccLevel];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printPDF417:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 8){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger symbol = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger columnNumber = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger rowNumber = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger moduleWidth = [[command.arguments objectAtIndex:5] integerValue];
    NSInteger moduleHeight = [[command.arguments objectAtIndex:6] integerValue];
    NSInteger eccLevel = [[command.arguments objectAtIndex:7] integerValue];

    result = [_printer printPDF417:data symbol:symbol alignment:alignment columnNumber:columnNumber rowNumber:rowNumber moduleWidth:moduleWidth moduleHeight:moduleHeight eccLevel:eccLevel];
    
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printGS1Databar:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 4){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger symbol = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger moduleSize = [[command.arguments objectAtIndex:3] integerValue];

    result = [_printer printGS1Databar:data symbol:symbol alignment:alignment moduleSize:moduleSize];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printDataMatrix:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 3){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }

    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger alignment = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger moduleSize = [[command.arguments objectAtIndex:2] integerValue];
    
    result = [_printer printDataMatrix:data alignment:alignment moduleSize:moduleSize];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) print1DBarcode:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 6){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* data = [command.arguments objectAtIndex:0];
    NSInteger symbology = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger width = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger height = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger textPostion = [[command.arguments objectAtIndex:5] integerValue];
    
    result = [_printer print1DBarcode:data symbology:symbology width:width height:height alignment:alignment textPostion:textPostion];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printBitmap:(CDVInvokedUrlCommand *)command{
    CDVPluginResult* callbackResult = nil;
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_NOT_SUPPORT];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printBitmapFile:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 6){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    
    NSString* filePath = [command.arguments objectAtIndex:0];
    NSInteger width = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger brightness = [[command.arguments objectAtIndex:3] integerValue];
    BOOL isDithering = [[command.arguments objectAtIndex:4] boolValue];
    BOOL isCompress = [[command.arguments objectAtIndex:5] boolValue];

    result = [_printer printBitmapFile:filePath width:width alignment:alignment brightness:brightness isDithering:isDithering isCompress:isCompress];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printBitmapWithBase64:(CDVInvokedUrlCommand*)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 6){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSString* imageInBase64 = [command.arguments objectAtIndex:0];
    NSInteger width = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger brightness = [[command.arguments objectAtIndex:3] integerValue];
    BOOL isDithering = [[command.arguments objectAtIndex:4] boolValue];
    BOOL isCompress = [[command.arguments objectAtIndex:5] boolValue];

    result = [_printer printBitmapWithBase64:imageInBase64 width:width alignment:alignment brightness:brightness isDithering:isDithering isCompress:isCompress];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printPdfFile:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 8){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSString* filePath = [command.arguments objectAtIndex:0];
    NSInteger startPage = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger endPage = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger width = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger alignment = [[command.arguments objectAtIndex:4] integerValue];
    NSInteger brightness = [[command.arguments objectAtIndex:5] integerValue];
    BOOL isDithering = [[command.arguments objectAtIndex:6] boolValue];
    BOOL isCompress = [[command.arguments objectAtIndex:7] boolValue];
    
    result = [_printer printPdfFile:filePath startPage:startPage endPage:endPage width:width
                          alignment:alignment brightness:brightness isDithering:isDithering isCompress:isCompress];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printLine:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 5){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger x1 = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y1 = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger x2 = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger y2 = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger thickness = [[command.arguments objectAtIndex:4] integerValue];
    result = [_printer printLine:x1 y1:y1 x2:x2 y2:y2 thickness:thickness];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

- (void) printBox:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@] number of arguments = %ld", command.methodName, (long)[command.arguments count]);
    NSInteger result = MPOS_FAIL;
    CDVPluginResult* callbackResult  = nil;
    if([command.arguments count] < 5){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:MPOS_FAIL_INVALID_PARAMETER];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    NSInteger x1 = [[command.arguments objectAtIndex:0] integerValue];
    NSInteger y1 = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger x2 = [[command.arguments objectAtIndex:2] integerValue];
    NSInteger y2 = [[command.arguments objectAtIndex:3] integerValue];
    NSInteger thickness = [[command.arguments objectAtIndex:4] integerValue];
    result = [_printer printBox:x1 y1:y1 x2:x2 y2:y2 thickness:thickness];
    if(result != MPOS_SUCCESS){
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
        return;
    }
    callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
}

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

- (void) checkBattStatus:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult = nil;
        __block NSInteger batteryStatus = 0;
        result = [self.printer checkBattStatus:^(NSInteger status){
            batteryStatus = status;
        }];
        if(result != MPOS_SUCCESS){
            callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:result];
            [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
            return;
        }
        callbackResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:batteryStatus];
        [self.commandDelegate sendPluginResult:callbackResult callbackId:command.callbackId];
    }];
}

- (void) checkPrinterStatus:(CDVInvokedUrlCommand *)command{
    NSLog(@"[%@]", command.methodName);
    [self.commandDelegate runInBackground:^{
        NSInteger result = MPOS_FAIL;
        CDVPluginResult* callbackResult = nil;
        __block NSInteger printerStatus = 0;
        result = [self.printer checkPrinterStatus:^(NSInteger status){
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

@end
