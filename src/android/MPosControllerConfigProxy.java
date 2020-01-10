package com.bxl.bgateplugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.util.Log;

import com.bixolon.mpos.event.DataEvent;
import com.bixolon.mpos.event.DataListener;
import com.bixolon.mpos.event.StatusUpdateEvent;
import com.bixolon.mpos.event.StatusUpdateListener;

import com.bixolon.mpos.MPosControllerDeviceConfig;
import com.bixolon.BixolonConst;

public class MPosControllerConfigProxy extends CordovaPlugin implements StatusUpdateListener, DataListener{

    private static final String TAG = MPosControllerConfigProxy.class.getSimpleName();
    private static final boolean DEBUG = true;

    private final String ACTION_OPEN_SERVICE = "openService";
    private final String ACTION_CLOSE_SERVICE = "closeService";
    private final String ACTION_SELECT_INTERFACE = "selectInterface";
    private final String ACTION_SELECT_COMMAND_MODE = "selectCommandMode";
    private final String ACTION_DIRECT_IO = "directIO";
    private final String ACTION_IS_OPEN = "isOpen";
    private final String ACTION_GET_DEVICE_ID = "getDeviceId";
    private final String ACTION_SET_TIMEOUT = "setTimeout";
    private final String ACTION_SET_TRANSACTION = "setTransaction";
    private final String ACTION_SET_READ_MODE = "setReadMode";
    private final String ACTION_GET_RESULT = "getResult";
    private final String ACTION_CONVERT_HID = "convertHID";
    private final String METHOD_SET_STATUS_UPDATE_EVENT = "setStatusUpdateEvent";
    private final String METHOD_SET_DATA_OCCURRED_EVENT = "setDataOccurredEvent";

    private final String ACTION_SEARCH_DEVICES= "searchDevices";
    private final String ACTION_GET_SERIAL_CONFIG= "getSerialConfig";
    private final String ACTION_SET_SERIAL_CONFIG= "setSerialConfig";
    private final String ACTION_GET_BGATE_SERIAL_NUMBER= "getBgateSerialNumber";

    private CallbackContext statusUpdateCallback = null;
    private CallbackContext dataOccurredCallback = null;
    private MPosControllerDeviceConfig mPosDeviceConfig;
    private Context mContext = null;    
    
    @Override
    public void pluginInitialize() {
        mContext = webView.getContext();
        mPosDeviceConfig = new MPosControllerDeviceConfig();
    }

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (DEBUG) {
            Log.d(TAG, "execute(" + action + ", " + args + ", " + callbackContext + ")");
        }

        // COMMON METHOD
        if (action.equals(ACTION_OPEN_SERVICE))                 { openService(args, callbackContext); return true; } 
        else if(action.equals(ACTION_CLOSE_SERVICE))            { closeService(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SELECT_INTERFACE))         { selectInterface(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SELECT_COMMAND_MODE))      { selectCommandMode(args, callbackContext); return true; }         
        else if(action.equals(ACTION_DIRECT_IO))                { directIO(args, callbackContext); return true; } 
        else if(action.equals(ACTION_IS_OPEN))                  { isOpen(args, callbackContext); return true; } 
        else if(action.equals(ACTION_GET_DEVICE_ID))            { getDeviceId(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_TIMEOUT))              { setTimeout(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_TRANSACTION))          { setTransaction(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_READ_MODE))            { setReadMode(args, callbackContext); return true; } 
        else if(action.equals(METHOD_SET_STATUS_UPDATE_EVENT))  { setStatusUpdateEvent(args, callbackContext); return true; } 
        else if(action.equals(METHOD_SET_DATA_OCCURRED_EVENT))  { setDataOccurredEvent(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SEARCH_DEVICES))           { searchDevices(args, callbackContext); return true; } 
        else if(action.equals(ACTION_GET_SERIAL_CONFIG))        { getSerialConfig(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_SERIAL_CONFIG))        { setSerialConfig(args, callbackContext); return true; } 
        else if(action.equals(ACTION_GET_BGATE_SERIAL_NUMBER))  { getBgateSerialNumber(args, callbackContext); return true; } 
        else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
            return false;
        }
    };        

    @Override
	public void statusUpdateOccurred(final StatusUpdateEvent statusUpdateEvent) {
        if(statusUpdateCallback == null)
            return;
        String statusStringInJSON = "";
        statusStringInJSON += "[{\"deviceid\": " + 0 + ",";
        statusStringInJSON += "\"status\": " + statusUpdateEvent.getStatus() + "}]";
        PluginResult result = new PluginResult(PluginResult.Status.OK, statusStringInJSON);
        result.setKeepCallback(true);
        statusUpdateCallback.sendPluginResult(result);
	}

	@Override
	public void dataOccurred(final DataEvent dataOccurredEvent) {
        if(dataOccurredCallback == null)
            return;
        try {
            JSONObject parameter = new JSONObject();
            parameter.put("Object", dataOccurredEvent.getObject());
            PluginResult result = new PluginResult(PluginResult.Status.OK, parameter);
            result.setKeepCallback(true);
            dataOccurredCallback.sendPluginResult(result);
        } catch (JSONException e) {
            Log.e(TAG, e.toString());
        }
    }

    // COMMON METHODS
    private void isOpen(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, mPosDeviceConfig.isOpen()));
    }

    private void getDeviceId(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
    }

    private void setTransaction(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.setTransaction(args.getInt(0)/*mode*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void openService(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        final int deviceID = args.getInt(0);
        long result = mPosDeviceConfig.openService(deviceID, mContext);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }        
        // final int deviceID = args.getInt(0);
        // cordova.getThreadPool().execute(new Runnable() {
        //     public void run() {
        //         long result = mPosDeviceConfig.openService(deviceID, mContext);
        //         if(result == 0){
        //             callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        //         }else{
        //             callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        //         }        
        //     }
        // });
    }

    private void closeService(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result =  mPosDeviceConfig.closeService(args.getInt(0)/*timeout in seconds*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    private void selectInterface(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.selectInterface(args.getInt(0)/*interface type*/, args.getString(1)/*address*/);
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    private void selectCommandMode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.selectCommandMode(args.getInt(0)/*command mode*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void directIO(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String stringData = args.getString(0);
        stringData = stringData.substring(1, stringData.length() - 1);
        String[] arrayData = stringData.split(",");
        byte[] data = new byte[arrayData.length];
        for (int i = 0; i < arrayData.length; i++)
            data[i] = (byte) (Integer.parseInt(arrayData[i]));
        long result = mPosDeviceConfig.directIO(data);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setTimeout(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.setTimeout(args.getInt(0)/*timeout*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setReadMode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.setReadMode(args.getInt(0)/*control*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setStatusUpdateEvent(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        statusUpdateCallback = callbackContext;
    }

    private void setDataOccurredEvent(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        dataOccurredCallback = callbackContext;
    }    

    private void getResult(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
    }

    private void convertHID(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
    }    

    // DEVICE METHOD
    private void getBgateSerialNumber(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        String strResult = mPosDeviceConfig.getBgateSerialNumber();
        if(strResult.length() > 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, strResult));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "failed to get the serial number"));
        }
    }

    private void searchDevices(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        int[] arrResult = null;
        String devListInJsonFormat = "";
        String strResult = "";
        arrResult = mPosDeviceConfig.searchDevices();
        JSONArray jsonArray = new JSONArray();
        for(int i = 0; i < arrResult.length; i++)
            jsonArray.put(arrResult[i]);
        if(arrResult.length > 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonArray));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "no devices"));
        }
    }

    private void getSerialConfig(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        int[] arrResult = mPosDeviceConfig.getSerialConfig(args.getInt(0)/*devID*/);
        JSONArray jsonArray = new JSONArray();
        for(int i = 0; i < arrResult.length; i++){
            jsonArray.put(arrResult[i]);
        }
        if(arrResult.length > 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonArray));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "failed to get the serial config of the device"));
        }
    }

    private void setSerialConfig(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosDeviceConfig.setSerialConfig(args.getInt(0)/*devID*/, args.getInt(1)/*baudRate*/, 
                        args.getInt(2)/*dataBit*/, args.getInt(3)/*stopBit*/, args.getInt(4)/*parityBit*/, args.getInt(5)/*flowControl*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
}