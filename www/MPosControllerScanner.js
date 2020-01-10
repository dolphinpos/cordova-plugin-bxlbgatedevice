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

var MPosControllerScanner = /** @class */ (function () {
    function MPosControllerScanner() { }
    // COMMON Methods
    MPosControllerScanner.prototype.getDeviceId = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'getDeviceId', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.openService = function (successCallback, failureCallback, id, timeout) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'openService', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.closeService = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'closeService', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.selectInterface = function (successCallback, failureCallback, interfaceType, address) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'selectInterface', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.selectCommandMode = function (successCallback, failureCallback, mode) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'selectCommandMode', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.isOpen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'isOpen', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.setStatusUpdateEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'setStatusUpdateEvent', Array.from(arguments).slice(2)); };
    MPosControllerScanner.prototype.setDataOccurredEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerScanner', 'setDataOccurredEvent', Array.from(arguments).slice(2)); };
    return MPosControllerScanner;
}());

module.exports = MPosControllerScanner;
