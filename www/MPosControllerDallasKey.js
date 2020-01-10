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

var MPosControllerDallasKey = /** @class */ (function () {
    function MPosControllerDallasKey() { }
    // COMMON Methods
    MPosControllerDallasKey.prototype.getDeviceId = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'getDeviceId', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.openService = function (successCallback, failureCallback, id, timeout) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'openService', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.closeService = function (successCallback, failureCallback, timeout) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'closeService', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.selectInterface = function (successCallback, failureCallback, interfaceType, address) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'selectInterface', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.selectCommandMode = function (successCallback, failureCallback, mode) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'selectCommandMode', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.isOpen = function (successCallback, failureCallback) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'isOpen', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.directIO = function (successCallback, failureCallback, rawData) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'directIO', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.setStatusUpdateEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'setStatusUpdateEvent', Array.from(arguments).slice(2)); };
    MPosControllerDallasKey.prototype.setDataOccurredEvent = function (successCallback, failureCallback, handler) { exec(successCallback, failureCallback, 'MPosControllerDallasKey', 'setDataOccurredEvent', Array.from(arguments).slice(2)); };
    return MPosControllerDallasKey;
}());

module.exports = MPosControllerDallasKey;
