
#import <Cordova/CDV.h>

@interface MPosControllerPrinterProxy : CDVPlugin

- (void) setPagemode:(CDVInvokedUrlCommand *)command;
- (void) setPagemodePrintArea:(CDVInvokedUrlCommand *)command;
- (void) setPagemodeDirection:(CDVInvokedUrlCommand *)command;
- (void) setPagemodePosition:(CDVInvokedUrlCommand *)command;
- (void) setTextEncoding:(CDVInvokedUrlCommand *)command;
- (void) setCharacterset:(CDVInvokedUrlCommand *)command;
- (void) setInternationalCharacterset:(CDVInvokedUrlCommand *)command;
- (void) printText:(CDVInvokedUrlCommand *)command;
- (void) cutPaper:(CDVInvokedUrlCommand *)command;
- (void) openDrawer:(CDVInvokedUrlCommand *)command;
- (void) asbEnable:(CDVInvokedUrlCommand *)command;
- (void) checkPrinterStatus:(CDVInvokedUrlCommand *)command;
- (void) checkBattStatus:(CDVInvokedUrlCommand *)command;
- (void) getModelName:(CDVInvokedUrlCommand *)command;
- (void) getFirmwareVersion:(CDVInvokedUrlCommand *)command;
- (void) printQRCode:(CDVInvokedUrlCommand *)command;
- (void) printPDF417:(CDVInvokedUrlCommand *)command;
- (void) printGS1Databar:(CDVInvokedUrlCommand *)command;
- (void) printDataMatrix:(CDVInvokedUrlCommand *)command;
- (void) print1DBarcode:(CDVInvokedUrlCommand *)command;
- (void) printBitmap:(CDVInvokedUrlCommand *)command;
- (void) printBitmapFile:(CDVInvokedUrlCommand *)command;
- (void) printBitmapWithBase64:(CDVInvokedUrlCommand *)command;
- (void) printPdfFile:(CDVInvokedUrlCommand *)command;
- (void) printLine:(CDVInvokedUrlCommand *)command;
- (void) printBox:(CDVInvokedUrlCommand *)command;
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
