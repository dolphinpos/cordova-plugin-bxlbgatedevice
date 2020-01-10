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

var MPosControllerMSR = /** @class */ (function () {
    function MPosControllerMSR() { }
    // COMMON Methods
    MPosControllerMSR.prototype.getDeviceId = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'getDeviceId', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.openService = function (successCallback, failureCallback, id, timeout) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'openService', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.closeService = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'closeService', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.selectInterface = function (successCallback, failureCallback, interfaceType, address) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'selectInterface', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.selectCommandMode = function (successCallback, failureCallback, mode) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'selectCommandMode', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.isOpen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'isOpen', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.directIO = function (successCallback, failureCallback, rawData) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'directIO', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.setStatusUpdateEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'setStatusUpdateEvent', Array.from(arguments).slice(2)); };
    MPosControllerMSR.prototype.setDataOccurredEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerMSR', 'setDataOccurredEvent', Array.from(arguments).slice(2)); };
    return MPosControllerMSR;
}());

module.exports = MPosControllerMSR;
