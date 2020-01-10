
#import <Foundation/Foundation.h>
#import "MPosResults.h"
#import "MPosDefines.h"
#import "MPosDeviceInfo.h"

@interface MPosLookup : NSObject

- (MPOS_RESULT) refreshDeviceList:(NSInteger)intefaceType;
- (NSArray<MPosDeviceInfo*>*) getDeviceList:(NSInteger)intefaceType;
//- (MPOS_RESULT) refreshWifiDevicesList;
//- (MPOS_RESULT) refreshEthernetDevicesList;
//- (MPOS_RESULT) refreshBluetoothDevicesList;
//- (NSArray<MPosDeviceInfo*>*) getWifiDevicesList;
//- (NSArray<MPosDeviceInfo*>*) getEthernetDevicesList;
//- (NSArray<MPosDeviceInfo*>*) getBluetoothDevicesList;

@end
