
#import <Foundation/Foundation.h>
#import "MPosResults.h"
#import "MPosDefines.h"

@interface MPosControllerDevices : NSObject

-(MPOS_RESULT) setTimeout:(NSInteger)timeoutInSecond;
-(MPOS_RESULT) selectInterface:(MPOS_INTERACE_TYPE)interfaceType address:(NSString*)address;
-(MPOS_RESULT) selectCommandMode:(MPOS_COMMAND_MODE)commandMode;
-(MPOS_RESULT) openService;
-(MPOS_RESULT) openService:(NSInteger)deviceID;
-(MPOS_RESULT) closeService:(NSInteger)timeout;
-(MPOS_RESULT) directIO:(NSData*) data;
-(MPOS_RESULT) setTransaction:(NSInteger) mode;
-(MPOS_RESULT) setReadMode:(NSInteger) mode;
-(BOOL) isOpen;
-(NSInteger) getDeviceId;
-(NSInteger) getResult;
-(NSString*) getNotificationKey;
+(void) setEnableLog:(BOOL)printLog saveFile:(BOOL)saveFile saveToHex:(BOOL)saveToHex;

@end
