cordova.commandProxy.add("MPosControllerLabelPrinter", {
    MPosControllerLabelPrinter : (function(){
        this.mPosControllerLabelPrinterWrapper = new MPosControllerLabelPrinterWrapper();
    })(),
    openService: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.openService(successCallback, failureCallback, args); },
    closeService: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.closeService(successCallback, failureCallback, args); },
    selectInterface: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.selectInterface(successCallback, failureCallback, args); },
    selectCommandMode: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.selectCommandMode(successCallback, failureCallback, args); },
    directIO: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.directIO(successCallback, failureCallback, args); },
    isOpen: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.isOpen(successCallback, failureCallback, args); },
    getDeviceId: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.getDeviceId(successCallback, failureCallback, args); },
    // NOT IMPLEMENTED : START
    setTimeout: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setTimeout(successCallback, failureCallback, args); },
    setTransaction: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setTransaction(successCallback, failureCallback, args); },
    setReadMode: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setReadMode(successCallback, failureCallback, args); },
    getResult: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.getResult(successCallback, failureCallback, args); },
    convertHID: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.convertHID(successCallback, failureCallback, args); },
    // NOT IMPLEMENTED : END

    setStatusUpdateEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setStatusUpdateEvent(successCallback, failureCallback, args); },
    setDataOccurredEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setDataOccurredEvent(successCallback, failureCallback, args); },

    setTextEncoding: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setTextEncoding(successCallback, failureCallback, args); },
    setCharacterset: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setCharacterset(successCallback, failureCallback, args); },
    setPrintingType: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setPrintingType(successCallback, failureCallback, args); },
    setMargin: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setMargin(successCallback, failureCallback, args); },
    setBackFeedOption: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setBackFeedOption(successCallback, failureCallback, args); },
    setLength: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setLength(successCallback, failureCallback, args); },
    setWidth: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setWidth(successCallback, failureCallback, args); },
    setBufferMode: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setBufferMode(successCallback, failureCallback, args); },
    setSpeed: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setSpeed(successCallback, failureCallback, args); },
    setDensity: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setDensity(successCallback, failureCallback, args); },
    setOrientation: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setOrientation(successCallback, failureCallback, args); },
    setOffset: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setOffset(successCallback, failureCallback, args); },
    setCuttingPosition: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setCuttingPosition(successCallback, failureCallback, args); },
    setAutoCutter: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.setAutoCutter(successCallback, failureCallback, args); },
    
    printBuffer: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.printBuffer(successCallback, failureCallback, args); },
    checkPrinterStatus: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.checkPrinterStatus(successCallback, failureCallback, args); },
    drawTextDeviceFont: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawTextDeviceFont(successCallback, failureCallback, args); },
    drawTextVectorFont: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawTextVectorFont(successCallback, failureCallback, args); },
    drawCircle: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawCircle(successCallback, failureCallback, args); },
    drawImageFile: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawImageFile(successCallback, failureCallback, args); },
    drawImageWithBase64: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawImageWithBase64(successCallback, failureCallback, args); },
    drawBlock: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBlock(successCallback, failureCallback, args); },
    drawBarcode1D: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcode1D(successCallback, failureCallback, args); },
    drawBarcodeMaxiCode: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeMaxiCode(successCallback, failureCallback, args); },
    drawBarcodePDF417: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodePDF417(successCallback, failureCallback, args); },
    drawBarcodeQRCode: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeQRCode(successCallback, failureCallback, args); },
    drawBarcodeDataMatrix: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeDataMatrix(successCallback, failureCallback, args); },
    drawBarcodeAztec: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeAztec(successCallback, failureCallback, args); },
    drawBarcodeCode49: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeCode49(successCallback, failureCallback, args); },
    drawBarcodeCodaBlock: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeCodaBlock(successCallback, failureCallback, args); },
    drawBarcodeMicroPDF: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeMicroPDF(successCallback, failureCallback, args); },
    drawBarcodeIMB: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeIMB(successCallback, failureCallback, args); },
    drawBarcodeMSI: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeMSI(successCallback, failureCallback, args); },
    drawBarcodePlessey: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodePlessey(successCallback, failureCallback, args); },
    drawBarcodeTLC39: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeTLC39(successCallback, failureCallback, args); },
    drawBarcodeRSS: function(successCallback, failureCallback, args) { mPosControllerLabelPrinterWrapper.drawBarcodeRSS(successCallback, failureCallback, args); },
});

function MPosControllerLabelPrinterWrapper() 
{
    var nativeAPIs = new WinRT.BxlComponent.UwpWrapper.MPosDeviceLabelPrinterImpl();
    var selectInterface = function (successCallback, failureCallback, args) {
        var result = nativeAPIs.selectInterface(args[0]/*interface type*/, args[1]/*address*/);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var selectCommandMode = function (successCallback, failureCallback, args) {
        var result = nativeAPIs.selectCommandMode(args[0]/*command mode*/);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var openService = function (successCallback, failureCallback, args) {
        nativeAPIs.openService(args[0] /*deviceId*/, args[1]/*timeout in seconds*/).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var closeService = function (successCallback, failureCallback, args) {
        nativeAPIs.closeService(args[0]/*timeout in seconds*/).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var directIO = function (successCallback, failureCallback, args) {
        // Param : [ReadOnlyArray()]  byte[] data
        nativeAPIs.directIO(args[0]/* byte array */).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var isOpen = function (successCallback, failureCallback) { successCallback(nativeAPIs.isOpen()); };
    var getDeviceId = function (successCallback, failureCallback, args) { successCallback(nativeAPIs.getDeviceId()); };
    var printBuffer = function(successCallback, failureCallback, args) { 
        // Param : int numberOfCopies
        nativeAPIs.printBuffer(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setTransaction = function(successCallback, failureCallback, args) { 
        // Param : int transactionMode
        nativeAPIs.setTransaction(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var checkPrinterStatus = function(successCallback, failureCallback, args) { 
        nativeAPIs.checkPrinterStatus().then(
            function (result) {
                (result >=0 && result <= 9) ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setTextEncoding = function (successCallback, failureCallback, args) {
        // Param : int textEncoding
        var result = nativeAPIs.setTextEncoding(args[0]);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var setCharacterset = function(successCallback, failureCallback, args) { 
        // Param : int charset, int internationalCharset
        nativeAPIs.setCharacterset(args[0], args[1]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setPrintingType = function(successCallback, failureCallback, args) { 
        // Param : char printingType
        nativeAPIs.setPrintingType(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setMargin = function(successCallback, failureCallback, args) { 
        // Param : int horizontalMargin, int verticalMargin
        nativeAPIs.setMargin(args[0], args[1]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setBackFeedOption = function(successCallback, failureCallback, args) { 
        // Param : bool bEnable, int stepQuantity
        nativeAPIs.setBackFeedOption(args[0], args[1]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setLength = function(successCallback, failureCallback, args) { 
        // Param : int labelLength, int gapLength, char mediaType, int offsetLength
        nativeAPIs.setLength(args[0], args[1], args[2], args[3]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setWidth = function(successCallback, failureCallback, args) { 
        // Param : int labelWidth
        nativeAPIs.setWidth(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setBufferMode = function(successCallback, failureCallback, args) { 
        // Param : int doubleBufferEnable
        nativeAPIs.setBufferMode(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setSpeed = function(successCallback, failureCallback, args) { 
        // Param : int speed
        nativeAPIs.setSpeed(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setDensity = function(successCallback, failureCallback, args) { 
        // Param : int density
        nativeAPIs.setDensity(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setOrientation = function(successCallback, failureCallback, args) { 
        // Param : char orientation
        nativeAPIs.setOrientation(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setOffset = function(successCallback, failureCallback, args) { 
        // Param : int offset
        nativeAPIs.setOffset(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setCuttingPosition = function(successCallback, failureCallback, args) { 
        // Param : int cuttingPosition
        nativeAPIs.setCuttingPosition(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setAutoCutter = function(successCallback, failureCallback, args) { 
        // Param : bool enable, int period
        nativeAPIs.setAutoCutter(args[0], args[1]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setStatusUpdateEvent = function (successCallback, failureCallback, args) {
        nativeAPIs.onstatusupdateevent = args[0];
        if(!nativeAPIs.onstatusupdateevent)
            failureCallback();
    };
    var setDataOccurredEvent = function (successCallback, failureCallback, args) {
        nativeAPIs.ondataevent = args[0];
        if(!nativeAPIs.ondataevent)
            failureCallback();
    };

    var drawTextDeviceFont = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, char fontSelection, int fontWidth, 
        //         int fontHeight, nt rightSpace, int rotation, bool reverse, bool bold, bool rightToLeft, int alignment
        nativeAPIs.drawTextDeviceFont(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawTextVectorFont = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, char fontSelection, int fontWidth, int fontHeight, int rightSpace, int rotation,
        //         bool reverse, bool bold, bool italic, bool rightToLeft, int alignment
        nativeAPIs.drawTextVectorFont(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawCircle = function(successCallback, failureCallback, args) { 
        // Param : int xPos, int yPos, int sizeSelection, int multiplier
        nativeAPIs.drawCircle(args[0],args[1],args[2],args[3]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawImageFile = function(successCallback, failureCallback, args) { 
        // Param : string filePath, int xPos, int yPos, int width, int brightness, bool isDithering, bool isCompress
        nativeAPIs.drawImageFile(args[0],args[1],args[2],args[3],args[4],args[5],args[6]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawImageWithBase64 = function(successCallback, failureCallback, args) { 
        // Param : string base64String, int xPos, int yPos, int width, int brightness, bool isDithering, bool isCompress
        nativeAPIs.drawImageWithBase64(args[0],args[1],args[2],args[3],args[4],args[5],args[6]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBlock = function(successCallback, failureCallback, args) { 
        // Param : int startPosX, int startPosY, int endPosX, int endPosY, char option, int thickness
        nativeAPIs.drawBlock(args[0],args[1],args[2],args[3],args[4],args[5]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcode1D = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int barcodeType, int widthNarrow, int widthWide, int height, int hri, int quietZoneWidth, int rotation
        nativeAPIs.drawBarcode1D(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeMaxiCode = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int mode
        nativeAPIs.drawBarcodeMaxiCode(args[0],args[1],args[2],args[3]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodePDF417 = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int maximumRowCount, int maximumColumnCount, int errorCorrectionLevel, 
        //         int dataCompressionMethod, bool hri, int barcodeOriginPoint, int moduleWidth, int barHeight, int rotation
        nativeAPIs.drawBarcodePDF417(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeQRCode = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int size, int model, int errorCorrectionLevel, int rotation
        nativeAPIs.drawBarcodeQRCode(args[0],args[1],args[2],args[3],args[4],args[5],args[6]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeDataMatrix = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int size, bool reverse, int rotation
        nativeAPIs.drawBarcodeDataMatrix(args[0],args[1],args[2],args[3],args[4],args[5]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeAztec = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int size, bool extendedChannel, int errorCorrectionLevel, 
        //         bool menuSymbol, int numberOfSymbols, int optionalID, int rotation
        nativeAPIs.drawBarcodeAztec(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeCode49 = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int widthNarrow, int widthWide, int height, int hri, int startingMode, int rotation
        nativeAPIs.drawBarcodeCode49(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeCodaBlock = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int widthNarrow, int widthWide, int height, bool securityLevel,
        //         int numberOfCharactersPerRow, char mode, int numberOfRowToEncode
        nativeAPIs.drawBarcodeCodaBlock(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeMicroPDF = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int moduleWidth, int moduleHeight, int mode, int rotation
        nativeAPIs.drawBarcodeMicroPDF(args[0],args[1],args[2],args[3],args[4],args[5],args[6]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeIMB = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, bool hri, int rotation
        nativeAPIs.drawBarcodeIMB(args[0],args[1],args[2],args[3],args[4]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeMSI = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int narrowWidth, int wideWidth, int height, 
        //         int checkDigitSelection, bool printCheckDigit, int hri, int rotation
        nativeAPIs.drawBarcodeMicroPDF(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodePlessey = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int narrowWidth, int wideWidth, int height, bool printCheckDigit, int hri, int rotation
        nativeAPIs.drawBarcodePlessey(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeTLC39 = function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int narrowWidth, int wideWidth, int height, 
        //         int rowHeightOfMicroPDF417, int narrowWidthOfMicroPDF417, int rotation
        nativeAPIs.drawBarcodeTLC39(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var drawBarcodeRSS=  function(successCallback, failureCallback, args) { 
        // Param : string data, int xPos, int yPos, int barcodeType, int magnification, int separatorHeight, int barcodeHeight, int segmentWidth, int rotation
        nativeAPIs.drawBarcodeRSS(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    // NOT IMPLEMENTED : START
    var setTimeout = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var setReadMode = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var convertHID = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var getResult = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    // NOT IMPLEMENTED : END

    return {
        selectInterface: selectInterface, 
        selectCommandMode: selectCommandMode,
        openService: openService,
        closeService: closeService,
        isOpen : isOpen, 
        directIO : directIO, 
        getDeviceId : getDeviceId,
        setTransaction : setTransaction, 

        printBuffer : printBuffer, 
        checkPrinterStatus : checkPrinterStatus, 

        // NOT IMPLEMENTED : START
        setTimeout : setTimeout, 
        setReadMode : setReadMode, 
        getResult : getResult, 
        convertHID : convertHID, 
        // NOT IMPLEMENTED : END

        // SETTER : START
        setTextEncoding : setTextEncoding,
        setCharacterset : setCharacterset,
        setPrintingType : setPrintingType,
        setMargin : setMargin,
        setBackFeedOption : setBackFeedOption,
        setLength : setLength, 
        setWidth : setWidth, 
        setBufferMode : setBufferMode, 
        setSpeed : setSpeed, 
        setDensity : setDensity, 
        setOrientation : setOrientation,
        setOffset : setOffset, 
        setCuttingPosition : setCuttingPosition,
        setAutoCutter : setAutoCutter, 
        setStatusUpdateEvent : setStatusUpdateEvent, 
        setDataOccurredEvent : setDataOccurredEvent,
        // SETTER : END

        // DRAW : START
        drawTextDeviceFont : drawTextDeviceFont, 
        drawTextVectorFont : drawTextVectorFont, 
        drawCircle : drawCircle,
        drawImageFile : drawImageFile, 
        drawImageWithBase64 : drawImageWithBase64,
        drawBlock : drawBlock,
        drawBarcode1D : drawBarcode1D,
        drawBarcodeMaxiCode : drawBarcodeMaxiCode,
        drawBarcodePDF417 : drawBarcodePDF417,
        drawBarcodeQRCode : drawBarcodeQRCode,
        drawBarcodeDataMatrix : drawBarcodeDataMatrix,
        drawBarcodeAztec : drawBarcodeAztec,
        drawBarcodeCode49 : drawBarcodeCode49,
        drawBarcodeCodaBlock : drawBarcodeCodaBlock, 
        drawBarcodeMicroPDF : drawBarcodeMicroPDF, 
        drawBarcodeIMB : drawBarcodeIMB, 
        drawBarcodeMSI : drawBarcodeMSI,
        drawBarcodePlessey : drawBarcodePlessey, 
        drawBarcodeTLC39 : drawBarcodeTLC39, 
        drawBarcodeRSS:  drawBarcodeRSS,
        // DRAW : END
    }
}