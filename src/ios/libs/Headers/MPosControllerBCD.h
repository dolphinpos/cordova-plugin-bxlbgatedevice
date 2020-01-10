#import "MPosControllerDevices.h"
#import <UIKit/UIKit.h>

@interface MPosControllerBCD : MPosControllerDevices

- (MPOS_RESULT) setTextEncoding:(NSInteger)textEncoding;
- (MPOS_RESULT) setCharacterset:(NSInteger)characterset;
- (MPOS_RESULT) setInternationalCharacterset:(NSInteger)characterset;

- (MPOS_RESULT) storeImage:(UIImage*)data width:(NSInteger)width imageNumber:(NSInteger)imageNumber;
- (MPOS_RESULT) storeImageWithBase64:(NSString*)base64String width:(NSInteger)width imageNumber:(NSInteger)imageNumber;
- (MPOS_RESULT) storeImageFile:(NSString*)filename width:(NSInteger)width imageNumber:(NSInteger)imageNumber;
- (MPOS_RESULT) displayString:(NSString*)data;
- (MPOS_RESULT) displayString:(NSString*)data line:(NSInteger)line;
- (MPOS_RESULT) displayImage:(NSInteger)imageNumber xPos:(NSInteger)xPos yPos:(NSInteger)yPos;

- (MPOS_RESULT) clearImage:(BOOL)isAll imageNumber:(NSInteger)imageNumber;
- (MPOS_RESULT) clearScreen;

@end
