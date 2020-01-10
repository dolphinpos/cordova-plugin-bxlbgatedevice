/*
The JavaScript interface provides the front-facing interface, making it perhaps the most important part of the plugin. 
You can structure your plugin's JavaScript however you like, but you need to call cordova.exec to communicate with the native platform, using the following syntax:

cordova.exec(function(winParam) {},
    function(error) {},
    'service',
    'action',
    ['firstArgument', 'secondArgument', 42, false]);

    - A success callback function. Assuming your exec call completes successfully, this function executes along with any parameters you pass to it.
    - An error callback function. If the operation does not complete successfully, this function executes with an optional error parameter.
    - The service name to call on the native side. This corresponds to a native class, for which more information is available in the native guides listed below.
    - The action name to call on the native side. This generally corresponds to the native class method. See the native guides listed below.
    - An array of arguments to pass into the native environment.
*/

var exec = require('cordova/exec');
//var MPosControllerDevices = require('./MPosControllerDevices');

var MPosControllerPrinter = /** @class */ (function () {
    function MPosControllerPrinter() { }
    // COMMON Methods
    MPosControllerPrinter.prototype.getDeviceId = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'getDeviceId', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.selectInterface = function (successCallback, failureCallback, interfaceType, address) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'selectInterface', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.selectCommandMode = function (successCallback, failureCallback, mode) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'selectCommandMode', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setTransaction = function (successCallback, failureCallback, transactionMode) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setTransaction', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.openService = function (successCallback, failureCallback, id, timeout) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'openService', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.closeService = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'closeService', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.isOpen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'isOpen', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.directIO = function (successCallback, failureCallback, rawData) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'directIO', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.cutPaper = function (successCallback, failureCallback, cutType) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'cutPaper', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.openDrawer = function (successCallback, failureCallback, pinNumber) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'openDrawer', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.checkBattStatus = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'checkBattStatus', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.checkPrinterStatus = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'checkPrinterStatus', Array.from(arguments).slice(2)); };    
    MPosControllerPrinter.prototype.asbEnable = function (successCallback, failureCallback, enable) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'asbEnable', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setStatusUpdateEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setStatusUpdateEvent', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setDataOccurredEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setDataOccurredEvent', Array.from(arguments).slice(2)); };

    // NOT IMPLEMENTED API : START
    MPosControllerPrinter.prototype.setTimeout = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setTimeout', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setReadMode = function (successCallback, failureCallback, readMode) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setReadMode', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.convertHID = function (successCallback, failureCallback, newType) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'convertHID', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.getResult = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'getResult', Array.from(arguments).slice(2)); };
    // NOT IMPLEMENTED API : END
    // MPosControllerPrinter Methods
    MPosControllerPrinter.prototype.print1DBarcode = function (successCallback, failureCallback, data, symbology, height, width, barWidth, alignment, hriPosition) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'print1DBarcode', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printQRCode = function (successCallback, failureCallback, data, model, alignment, moduleSize, eccLevel) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printQRCode', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printPDF417 = function (successCallback, failureCallback, data, symbol, alignment, columnNumber, rowNumber, moduleWidth, moduleHeight, eccLevel) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printPDF417', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printDataMatrix = function (successCallback, failureCallback, data, alignment, moduleSize) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printDataMatrix', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printGS1Databar = function (successCallback, failureCallback, data, symbology, alignment, moduleSize) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printGS1Databar', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printBitmapFile = function (successCallback, failureCallback, filePath, width, alignment, brightness, isDithering, isCompress) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printBitmapFile', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.printBitmapWithBase64 = function (successCallback, failureCallback, base64String, width, alignment, brightness, isDithering, isCompress) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printBitmapWithBase64', Array.from(arguments).slice(2)); };

    // MPosControllerPrinter Methods
    MPosControllerPrinter.prototype.printText = function (successCallback, failureCallback, textData, property) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'printText', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setTextEncoding = function (successCallback, failureCallback, encoding) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setTextEncoding', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setCharacterset = function (successCallback, failureCallback, characterset) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setCharacterset', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setInternationalCharacterset = function (successCallback, failureCallback, characterset) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setInternationalCharacterset', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setPagemode = function (successCallback, failureCallback, pageMode) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setPagemode', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setPagemodePrintArea = function (successCallback, failureCallback, x, y, width, height) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setPagemodePrintArea', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setPagemodeDirection = function (successCallback, failureCallback, direction) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setPagemodeDirection', Array.from(arguments).slice(2)); };
    MPosControllerPrinter.prototype.setPagemodePosition = function (successCallback, failureCallback, x, y) { exec(successCallback, failureCallback, 'MPosControllerPrinter', 'setPagemodePosition', Array.from(arguments).slice(2)); };
    return MPosControllerPrinter;
}());

module.exports = MPosControllerPrinter;
