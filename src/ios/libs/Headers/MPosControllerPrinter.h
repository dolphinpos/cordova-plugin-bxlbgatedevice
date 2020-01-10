#import <UIKit/UIKit.h>
#import "MPosControllerDevices.h"
#import "MPosDefines.h"


@interface MPosControllerPrinter : MPosControllerDevices

- (MPOS_RESULT) setPagemode:(NSInteger)mode;
- (MPOS_RESULT) setPagemodePrintArea:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger)height;
- (MPOS_RESULT) setPagemodeDirection:(NSInteger)direction;
- (MPOS_RESULT) setPagemodePosition:(NSInteger)x y:(NSInteger)y;

- (MPOS_RESULT) setTextEncoding:(NSInteger)textEncoding;
- (MPOS_RESULT) setCharacterset:(NSInteger)characterset;
- (MPOS_RESULT) setInternationalCharacterset:(NSInteger)characterset;

- (MPOS_RESULT) printText:(NSString*)string;
- (MPOS_RESULT) printText:(NSString*)string fontAttributes:(MPOS_FONT_ATTRIBUTES)fontAttributes;
- (MPOS_RESULT) cutPaper;
- (MPOS_RESULT) cutPaper:(NSInteger)cutType;
- (MPOS_RESULT) openDrawer:(NSInteger)pinNumber;
- (MPOS_RESULT) asbEnable:(BOOL)enable;

//- (MPOS_RESULTS) checkPrinterStatus:(blockType3)statusReceiver;
- (MPOS_RESULT) checkPrinterStatus:(void(^)(NSInteger))statusBlock;
- (MPOS_RESULT) checkBattStatus:(void(^)(NSInteger))statusBlock;
- (MPOS_RESULT) getModelName: (void(^)(NSString*))modelNameBlock;
- (MPOS_RESULT) getFirmwareVersion: (void(^)(NSString*))firmwareVersionBlock;

- (MPOS_RESULT) getPrintBufferSize:(void(^)(NSInteger))bufferSizeBlock;
- (MPOS_RESULT) clearPrintBuffer:(void(^)(NSInteger))bufferClearResultBlock;


- (MPOS_RESULT) printQRCode: (NSString*)data model:(NSInteger)model alignment:(NSInteger) alignment moduleSize:(NSInteger)moduleSize eccLevel:(NSInteger) eccLevel;
- (MPOS_RESULT) printPDF417:(NSString*) data symbol:(NSInteger)symbol alignment:(NSInteger)alignment columnNumber:(NSInteger)columnNumber rowNumber:(NSInteger)rowNumber moduleWidth:(NSInteger) moduleWidth moduleHeight:(NSInteger)moduleHeight eccLevel:(NSInteger) eccLevel;
- (MPOS_RESULT) printGS1Databar:(NSString*)data symbol:(NSInteger) symbol alignment:(NSInteger)alignment moduleSize:(NSInteger)moduleSize;
- (MPOS_RESULT) printDataMatrix:(NSString*)data alignment:(NSInteger) alignment moduleSize:(NSInteger) moduleSize;
- (MPOS_RESULT) print1DBarcode:(NSString*)data symbology:(NSInteger)symbology width:(NSInteger)width height:(NSInteger)height alignment:(NSInteger)alignment textPostion:(NSInteger)textPosition;
- (MPOS_RESULT) printBitmap:(UIImage*)imgObj width:(NSInteger)width alignment:(NSInteger)alignment brightness:(NSInteger)brightness isDithering:(BOOL)isDithering isCompress:(BOOL)isCompress;
- (MPOS_RESULT) printBitmapFile:(NSString*)filePath width:(NSInteger)width alignment:(NSInteger)alignment brightness:(NSInteger)brightness isDithering:(BOOL)isDithering isCompress:(BOOL)isCompress;
- (MPOS_RESULT) printBitmapWithBase64:(NSString*)base64String width:(NSInteger)width alignment:(NSInteger)alignment brightness:(NSInteger)brightness isDithering:(BOOL)isDithering isCompress:(BOOL)isCompress;
- (MPOS_RESULT) printPdfFile:(NSString*)filePath startPage:(NSInteger)startPage endPage:(NSInteger)endPage width:(NSInteger)width
                      alignment:(NSInteger)alignment brightness:(NSInteger)brightness isDithering:(BOOL)isDithering isCompress:(BOOL)isCompress;


- (MPOS_RESULT) printLine: (NSInteger)x1 y1:(NSInteger)y1 x2:(NSInteger)x2 y2:(NSInteger)y2 thickness:(NSInteger)thickness;
- (MPOS_RESULT) printBox: (NSInteger)x1 y1:(NSInteger)y1 x2:(NSInteger)x2 y2:(NSInteger)y2 thickness:(NSInteger)thickness;

@end
