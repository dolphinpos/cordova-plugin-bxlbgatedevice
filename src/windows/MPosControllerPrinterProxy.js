cordova.commandProxy.add("MPosControllerPrinter", {
    MPosControllerPrinter : (function(){
        this.mPosControllerPrinterWrapper = new MPosControllerPrinterWrapper();
    })(),
    // COMMON
    openService: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.openService(successCallback, failureCallback, args); },
    closeService: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.closeService(successCallback, failureCallback, args); },
    selectInterface: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.selectInterface(successCallback, failureCallback, args); },
    selectCommandMode: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.selectCommandMode(successCallback, failureCallback, args); },
    directIO: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.directIO(successCallback, failureCallback, args); },
    isOpen: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.isOpen(successCallback, failureCallback, args); },
    getDeviceId: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.getDeviceId(successCallback, failureCallback, args); },
    // NOT IMPLEMENTED : START
    setTimeout: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setTimeout(successCallback, failureCallback, args); },
    setTransaction: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setTransaction(successCallback, failureCallback, args); },
    setReadMode: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setReadMode(successCallback, failureCallback, args); },
    getResult: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.getResult(successCallback, failureCallback, args); },
    convertHID: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.convertHID(successCallback, failureCallback, args); },
    // NOT IMPLEMENTED : END
    // PRINT APIs
    printQRCode: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printQRCode(successCallback, failureCallback, args); },
    printPDF417: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printPDF417(successCallback, failureCallback, args); },
    print1DBarcode: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.print1DBarcode(successCallback, failureCallback, args); },
    printDataMatrix: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printDataMatrix(successCallback, failureCallback, args); },
    printGS1Databar: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printGS1Databar(successCallback, failureCallback, args); },
    printText: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printText(successCallback, failureCallback, args); },
    // BITMAP
    printBitmapFile: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printBitmapFile(successCallback, failureCallback, args); },
    printBitmapWithBase64: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.printBitmapWithBase64(successCallback, failureCallback, args); },
    // SETTER
    setCharacterset: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setCharacterset(successCallback, failureCallback, args); },
    setTextEncoding: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setTextEncoding(successCallback, failureCallback, args); },
    setInternationalCharacterset: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setInternationalCharacterset(successCallback, failureCallback, args); },
    setPagemode: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setPagemode(successCallback, failureCallback, args); },
    setPagemodePrintArea: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setPagemodePrintArea(successCallback, failureCallback, args); },
    setPagemodePosition: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setPagemodePosition(successCallback, failureCallback, args); },
    // STATUS
    asbEnable: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.asbEnable(successCallback, failureCallback, args); },
    setStatusUpdateEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setStatusUpdateEvent(successCallback, failureCallback, args); },
    setDataOccurredEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setDataOccurredEvent(successCallback, failureCallback, args); },
    checkBattStatus: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.checkBattStatus(successCallback, failureCallback, args); },
    checkPrinterStatus: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.checkPrinterStatus(successCallback, failureCallback, args); },
    //  CUT, CASH DRAWER
    cutPaper: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.cutPaper(successCallback, failureCallback, args); },
    openDrawer: function(successCallback, failureCallback, args) { mPosControllerPrinterWrapper.openDrawer(successCallback, failureCallback, args); },
});

function MPosControllerPrinterWrapper() 
{
    var nativeAPIs = new WinRT.BxlComponent.UwpWrapper.MPosDevicePrinterImpl();
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
    var getDeviceId = function (successCallback, failureCallback, args) { successCallback(nativeAPIs.getDeviceId()); };
    var isOpen = function (successCallback, failureCallback) { successCallback(nativeAPIs.isOpen()); };
    
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
    var checkBattStatus = function (successCallback, failureCallback, args) {
        nativeAPIs.checkBattStatus().then(
            function (result) {
                ((result == 0) || (result == 16) || (result == 32) || (result == 64)) ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var checkPrinterStatus = function (successCallback, failureCallback, args) {
        nativeAPIs.checkPrinterStatus().then(
            function (result) {
                successCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var print1DBarcode = function (successCallback, failureCallback, args) {
        // Param : string data, int symbology, int width, int height, int alignment, int textPosition
        nativeAPIs.print1DBarcode(args[0],args[1],args[2],args[3],args[4],args[5]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printQRCode = function (successCallback, failureCallback, args) {
        // Param : string data, int model, int alignment, int moduleSize, int eccLevel
        nativeAPIs.printQRCode(args[0], args[1], args[2], args[3], args[4]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printPDF417 = function (successCallback, failureCallback, args) {
        // Param : string data, int symbology, int alignment, int columnNumber, int rowNumber, int moduleWidth, int moduleHeight, int eccLevel
        nativeAPIs.printPDF417(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printDataMatrix = function (successCallback, failureCallback, args) {
        // Param : string data, int alignment, int moduleSize
        nativeAPIs.printDataMatrix(args[0],args[1],args[2]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printGS1Databar = function (successCallback, failureCallback, args) {
        // Param : string data, int symbology, int alignment, int moduleSize
        nativeAPIs.printGS1Databar(args[0],args[1],args[2],args[3]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printText = function (successCallback, failureCallback, args) {
        // Param : string data, WinRT.BxlComponent.UwpWrapper.MPosWrapperConstant attribute
        var textProperty = new WinRT.BxlComponent.UwpWrapper.MPosWrapperConstant();
        if(args[1]){ // if text property was passed 
            textProperty.fontType = args[1].fontType;
            textProperty.width = args[1].width;
            textProperty.height = args[1].height;
            textProperty.underline = args[1].underline;
            textProperty.alignment = args[1].alignment;
            textProperty.bold = args[1].bold;
            textProperty.color = args[1].color;
            textProperty.reverse = args[1].reverse;
            textProperty.codePage = args[1].codePage;
        }
        nativeAPIs.printText(args[0], textProperty).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printBitmapWithBase64 = function (successCallback, failureCallback, args) {
        // string base64String, int width, int alignment, int brightness, bool isDithering, bool isCompress
        nativeAPIs.printBitmapWithBase64(args[0],args[1],args[2],args[3],args[4],args[5]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var printBitmapFile = function (successCallback, failureCallback, args) {
        // string filePath, int width, int alignment, int brightness, bool isDithering, bool isCompress
        nativeAPIs.printBitmapFile(args[0],args[1],args[2],args[3],args[4],args[5]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var openDrawer = function (successCallback, failureCallback, args) {
        // Param : int transactionMode
        nativeAPIs.openDrawer(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var cutPaper = function (successCallback, failureCallback, args) {
        // Param : int transactionMode
        nativeAPIs.cutPaper(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setCharacterset = function (successCallback, failureCallback, args) {
        // Param : int characterset
        nativeAPIs.setCharacterset(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
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
    var setInternationalCharacterset = function (successCallback, failureCallback, args) {
        // Param : int internationalCharacterset
        nativeAPIs.setInternationalCharacterset(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setPagemode = function (successCallback, failureCallback, args) {
        // Param : int pageMode
        nativeAPIs.setPagemode(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setPagemodePrintArea = function (successCallback, failureCallback, args) {
        // Param : int x, int y, int width, int height
        var result = nativeAPIs.setPagemodePrintArea(args[0], args[1], args[2], args[3]);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var setPagemodeDirection = function (successCallback, failureCallback, args) {
        // Param : int direction
        var result = nativeAPIs.setPagemodeDirection(args[0]);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var setPagemodePosition = function (successCallback, failureCallback, args) {
        // Param : int x, int y
        var result = nativeAPIs.setPagemodePosition(args[0], args[1]);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var setTransaction = function (successCallback, failureCallback, args) {
        // Param : int transactionMode
        nativeAPIs.setTransaction(args[0]).then(
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
    var asbEnable = function (successCallback, failureCallback, args) {
        nativeAPIs.asbEnable(args[0]).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };

    var setTimeout = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var setReadMode = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var convertHID = function (successCallback, failureCallback, args) { failureCallback('not supported'); };
    var getResult = function (successCallback, failureCallback, args) { failureCallback('not supported'); };

    return {
        selectInterface: selectInterface, 
        selectCommandMode: selectCommandMode,
        openService: openService,
        closeService: closeService,
        isOpen : isOpen, 
        getDeviceId : getDeviceId,
        directIO : directIO, 
        openDrawer : openDrawer, 
        cutPaper : cutPaper, 
        // Barcode, 2D Code
        print1DBarcode : print1DBarcode, 
        printQRCode : printQRCode, 
        printPDF417 : printPDF417,
        printDataMatrix : printDataMatrix,
        printGS1Databar : printGS1Databar,
        // Text
        printText : printText,
        // Bitmap
        printBitmapFile : printBitmapFile,
        printBitmapWithBase64 : printBitmapWithBase64,
        // Text Encoding
        setCharacterset : setCharacterset,
        setTextEncoding : setTextEncoding,
        setInternationalCharacterset : setInternationalCharacterset,
        // Page Mode
        setPagemode : setPagemode,
        setPagemodePrintArea : setPagemodePrintArea,
        setPagemodeDirection : setPagemodeDirection,
        setPagemodePosition : setPagemodePosition,
        // Transaction Mode
        setTransaction : setTransaction,
        // Status 
        asbEnable : asbEnable,
        setStatusUpdateEvent : setStatusUpdateEvent, 
        setDataOccurredEvent : setDataOccurredEvent,
        checkBattStatus : checkBattStatus,
        checkPrinterStatus : checkPrinterStatus,
        // Not Supported
        setTimeout : setTimeout, 
        setReadMode : setReadMode, 
        convertHID : convertHID, 
        getResult : getResult
    }
}