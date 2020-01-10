
cordova.commandProxy.add('MPosControllerLookup', {
    MPosLookup : (function(){
        this.mPosLookupWrapper = new MPosLookupWrapper();
    })(),
    refreshDeivcesList: function(successCallback, failureCallback, args) { mPosLookupWrapper.refreshDeivcesList(successCallback, failureCallback, args); },
    getDeviceList: function(successCallback, failureCallback, args) { mPosLookupWrapper.getDeviceList(successCallback, failureCallback, args); }
});

function MPosLookupWrapper() 
{ 
    var nativeAPIs = new WinRT.BxlComponent.UwpWrapper.MposLookupImpl();
    var refreshDeivcesList = function (successCallback, failureCallback, args) {
        console.log('MposLookupWrapper : refreshDeivcesList : args.length = ' + args.length);
        nativeAPIs.refreshDeivcesList(args[0], args[1]).then(
            function (result) {
                console.log('MposLookupWrapper : refreshDeivcesList : result = ' + result);
                result === 0 ? successCallback(result) : failureCallback(result);
            }, 
            function (error) {
                console.log('MposLookupWrapper : refreshDeivcesList : error = ' + error);
                failureCallback(result);
            }
        );
    };

    var getDeviceList = function (successCallback, failureCallback, args) {
        console.log('MposLookupWrapper : getDeviceList : args.length = ' + args.length);
        var devAddressList = nativeAPIs.getDeviceList(args[0]);
        if(devAddressList){ 
            console.log('MposLookupWrapper : getDeviceList : devAddressList.length = ' + devAddressList.length);
            var devListInJsonFormat = '';
            for (var index = 0; index < devAddressList.length; index++){
                // { interfaceType : Number, name : String, address : String }
                devListInJsonFormat += '{\"interfaceType\": ' + devAddressList[index].intefaceType + ',';
                devListInJsonFormat += '\"name\": ' + '\"' + devAddressList[index].name + '\",';       
                devListInJsonFormat += '\"address\": ' + '\"' + devAddressList[index].address + '\"},';
            }
            devListInJsonFormat = devListInJsonFormat.substring(0, devListInJsonFormat.length-1);
            devAddressList.length > 0 ? successCallback('['+devListInJsonFormat+']') : failureCallback();
        }else{
            failureCallback(undefined);
        }
    };

    return {
        refreshDeivcesList: refreshDeivcesList, 
        getDeviceList: getDeviceList
    }
}