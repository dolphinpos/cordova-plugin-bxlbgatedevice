cordova.commandProxy.add("MPosControllerConfig", {
    MPosControllerConfig : (function(){
        this.mPosControllerConfigWrapper = new MPosControllerConfigWrapper();
    })(),
    // COMMON
    openService: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.openService(successCallback, failureCallback, args); },
    closeService: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.closeService(successCallback, failureCallback, args); },
    selectInterface: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.selectInterface(successCallback, failureCallback, args); },
    selectCommandMode: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.selectCommandMode(successCallback, failureCallback, args); },
    isOpen: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.isOpen(successCallback, failureCallback, args); },
    searchDevices: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.searchDevices(successCallback, failureCallback, args); },
    setSerialConfig: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.setSerialConfig(successCallback, failureCallback, args); },
    getSerialConfig: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.getSerialConfig(successCallback, failureCallback, args); },
    getBgateSerialNumber: function(successCallback, failureCallback, args) { mPosControllerConfigWrapper.getBgateSerialNumber(successCallback, failureCallback, args); },
    setStatusUpdateEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setStatusUpdateEvent(successCallback, failureCallback, args); },
    setDataOccurredEvent: function (successCallback, failureCallback, args) { mPosControllerPrinterWrapper.setDataOccurredEvent(successCallback, failureCallback, args); }
});

function MPosControllerConfigWrapper() 
{
    var nativeAPIs = new WinRT.BxlComponent.UwpWrapper.MposConfigImpl();
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
    var selectInterface = function (successCallback, failureCallback, args) {
        var result = nativeAPIs.selectInterface(args[0]/*interface type*/, args[1]/*address*/);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var selectCommandMode = function (successCallback, failureCallback, args) {
        var result = nativeAPIs.selectCommandMode(args[0]/*command mode*/);
        result === 0 ? successCallback(result) : failureCallback(result);
    };
    var isOpen = function (successCallback, failureCallback, args) { 
        var result = nativeAPIs.isOpen();
        result >= 0 ? successCallback(result) : failureCallback(result);
    };
    var searchDevices = function (successCallback, failureCallback, args) {
        nativeAPIs.searchDevices().then(
            function (result) {
                result.length > 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var setSerialConfig = function (successCallback, failureCallback, args) {
        nativeAPIs.setSerialConfig(args[0]/*ID of the target TTY-USB device*/, args[1]/*baudRate*/, args[2]/*dataBit*/, args[3]/*stopBit*/, args[4]/*parityBit*/, args[5]/*flowControl*/).then(
            function (result) {
                result === 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var getSerialConfig = function (successCallback, failureCallback, args) {
        nativeAPIs.getSerialConfig(args[0]/*ID of the target TTY-USB device*/).then(
            function (result) {
                result.length > 0 ? successCallback(result) : failureCallback(result);
            }, function (error) {
                failureCallback(error);
            }
        );
    };
    var getBgateSerialNumber = function (successCallback, failureCallback, args) {
        nativeAPIs.getBgateSerialNumber().then(
            function (result) {
                result.length > 0 ? successCallback(result) : failureCallback(result);
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
    return {
        openService: openService,
        closeService: closeService,
        selectInterface: selectInterface, 
        selectCommandMode: selectCommandMode,
        isOpen : isOpen, 
        searchDevices : searchDevices, 
        setSerialConfig : setSerialConfig, 
        getSerialConfig : getSerialConfig, 
        getBgateSerialNumber : getBgateSerialNumber, 
        setStatusUpdateEvent : setStatusUpdateEvent, 
        setDataOccurredEvent : setDataOccurredEvent
    }
}