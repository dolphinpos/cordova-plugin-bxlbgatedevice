
#import <Cordova/CDV.h>

@interface MPosControllerLabelPrinterProxy : CDVPlugin

- (void) checkPrinterStatus:(CDVInvokedUrlCommand *)command;
- (void) printBuffer:(CDVInvokedUrlCommand *)command;
- (void) printRawData:(CDVInvokedUrlCommand *)command;
//  GETTER APIs
- (void) getModelName:(CDVInvokedUrlCommand *)command;
- (void) getFirmwareVersion:(CDVInvokedUrlCommand *)command;
//  SETTER APIs
- (void) setCharacterset:(CDVInvokedUrlCommand *)command;
- (void) setTextEncoding:(CDVInvokedUrlCommand *)command;
- (void) setPrintingType:(CDVInvokedUrlCommand *)command;
- (void) setMargin:(CDVInvokedUrlCommand *)command;
- (void) setBackFeedOption:(CDVInvokedUrlCommand *)command;
- (void) setLength:(CDVInvokedUrlCommand *)command;
- (void) setWidth:(CDVInvokedUrlCommand *)command;
- (void) setBufferMode:(CDVInvokedUrlCommand *)command;
- (void) setSpeed:(CDVInvokedUrlCommand *)command;
- (void) setDensity:(CDVInvokedUrlCommand *)command;
- (void) setOrientation:(CDVInvokedUrlCommand *)command;
- (void) setOffset:(CDVInvokedUrlCommand *)command;
- (void) setCuttingPosition:(CDVInvokedUrlCommand *)command;
- (void) setAutoCutter:(CDVInvokedUrlCommand *)command;
// PRINTING APIs
- (void) drawImage:(CDVInvokedUrlCommand *)command;
- (void) drawImageFile:(CDVInvokedUrlCommand *)command;
- (void) drawImageWithBase64:(CDVInvokedUrlCommand *)command;
- (void) drawTextDeviceFont:(CDVInvokedUrlCommand *)command;
- (void) drawTextVectorFont:(CDVInvokedUrlCommand *)command;
- (void) drawBarcode1D:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeMaxiCode:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodePDF417:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeQRCode:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeDataMatrix:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeAztec:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeCode49:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeCodaBlock:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeMicroPDF:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeIMB:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeMSI:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodePlessey:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeTLC39:(CDVInvokedUrlCommand *)command;
- (void) drawBarcodeRSS:(CDVInvokedUrlCommand *)command;
- (void) drawBlock:(CDVInvokedUrlCommand *)command;
- (void) drawCircle:(CDVInvokedUrlCommand *)command;
- (void) setStatusUpdateEvent:(CDVInvokedUrlCommand *)command;
- (void) setDataOccurredEvent:(CDVInvokedUrlCommand *)command;

- (void) selectInterface:(CDVInvokedUrlCommand *)command;
- (void) selectCommandMode:(CDVInvokedUrlCommand *)command;
- (void) openService:(CDVInvokedUrlCommand *)command;
- (void) closeService:(CDVInvokedUrlCommand *)command;
- (void) directIO:(CDVInvokedUrlCommand *)command;
- (void) setTransaction:(CDVInvokedUrlCommand *)command;
- (void) isOpen:(CDVInvokedUrlCommand *)command;
- (void) getDeviceId:(CDVInvokedUrlCommand *)command;

@end
