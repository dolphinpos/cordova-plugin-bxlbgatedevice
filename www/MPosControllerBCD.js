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

var MPosControllerBCD = /** @class */ (function () {
    function MPosControllerBCD() { }
    // COMMON Methods
    MPosControllerBCD.prototype.getDeviceId = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'getDeviceId', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.openService = function (successCallback, failureCallback, id, timeout) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'openService', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.closeService = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'closeService', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.selectInterface = function (successCallback, failureCallback, interfaceType, address) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'selectInterface', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.selectCommandMode = function (successCallback, failureCallback, mode) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'selectCommandMode', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.isOpen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'isOpen', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.directIO = function (successCallback, failureCallback, rawData) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'directIO', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.setStatusUpdateEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'setStatusUpdateEvent', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.setDataOccurredEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'setDataOccurredEvent', Array.from(arguments).slice(2)); };
    // Customer Display Methods
    MPosControllerBCD.prototype.setTextEncoding = function (successCallback, failureCallback, textEncoding) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'setTextEncoding', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.setCharacterset = function (successCallback, failureCallback, characterset) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'setCharacterset', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.setInternationalCharacterset = function (successCallback, failureCallback, characterset) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'setInternationalCharacterset', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.displayString = function (successCallback, failureCallback, data, line) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'displayString', Array.from(arguments).slice(2)); };
    MPosControllerBCD.prototype.clearScreen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerBCD', 'clearScreen', Array.from(arguments).slice(2)); };
    return MPosControllerBCD;
}());

module.exports = MPosControllerBCD;
