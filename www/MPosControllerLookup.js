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

var MPosControllerLookup = /** @class */ (function () {
    // Constructor
    function MPosControllerLookup() { }
    // Methods
    MPosControllerLookup.prototype.getDeviceList = function (successCallback, failureCallback, interfaceType) { 
        console.log('MPosControllerLookup.prototype.getDeviceList : interfaceType = ' + interfaceType);
        exec(successCallback, failureCallback, 'MPosControllerLookup', 'getDeviceList', Array.from(arguments).slice(2)); 
    };
    MPosControllerLookup.prototype.refreshDeivcesList = function (successCallback, failureCallback, interfaceType, timeout) { 
        console.log('MPosControllerLookup.prototype.refreshDeivcesList : interfaceType = ' + interfaceType);
        console.log('MPosControllerLookup.prototype.refreshDeivcesList : timeout = ' + timeout);
        exec(successCallback, failureCallback, 'MPosControllerLookup', 'refreshDeivcesList', Array.from(arguments).slice(2)); 
    };
    return MPosControllerLookup;
}());

module.exports = MPosControllerLookup;
