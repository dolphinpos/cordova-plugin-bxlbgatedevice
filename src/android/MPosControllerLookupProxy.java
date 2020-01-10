package com.bxl.bgateplugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import android.os.AsyncTask;
import android.content.Context;
import android.util.Log;
import android.bluetooth.BluetoothDevice;
import java.util.HashSet;
import java.util.Set;

import com.bixolon.BixolonConst;
import com.bixolon.mpos.config.util.MPosControllerLookup;


public class MPosControllerLookupProxy extends CordovaPlugin {

    private final boolean DEBUG = true;
    private final String TAG = MPosControllerLookupProxy.class.getSimpleName();
    private final String ACTION_REFRESH_DEV_LIST = "refreshDeivcesList";
    private final String ACTION_GET_DEV_LIST = "getDeviceList";

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (DEBUG) {
            Log.d(TAG, "execute(" + action + ", " + args + ", " + callbackContext + ")");
        }
        if (action.equals(ACTION_REFRESH_DEV_LIST))     { refreshDeivcesList(args, callbackContext); return true; } 
        else if (action.equals(ACTION_GET_DEV_LIST))    { getDeviceList(args, callbackContext); return true; } 
        else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
            return false;
        }
    };

    private void refreshDeivcesList(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() <= 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }

        long result = BixolonConst.MPOS_FAIL;
        switch(args.getInt(0))
        {
            case BixolonConst.MPOS_INTERFACE_BLUETOOTH:
                if(getBluetoothDevListInJSON(true).length() > 0){
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                }else{
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
                }
                break;
            case BixolonConst.MPOS_INTERFACE_WIFI:
            case BixolonConst.MPOS_INTERFACE_ETHERNET:
                float sec = (args.length() >= 2) ? (float)args.getInt(1) : 3.0f;
                 MPosControllerLookup.initWithTimeout(sec, 1);
                cordova.getThreadPool().execute(new Runnable() {
                    public void run() {
                        Set<CharSequence> networkDeviceSet = MPosControllerLookup.refreshWifiDevicesList();
                        if(networkDeviceSet.size() > 0){
                            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, 0));
                        }else{
                            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL));
                        }            
                    }
                });
                break;
        }
    }

    private void getDeviceList(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String devListInJsonFormat = "";
        switch(args.getInt(0))
        {
            case BixolonConst.MPOS_INTERFACE_BLUETOOTH:
                devListInJsonFormat = getBluetoothDevListInJSON(false);
                break;
            case BixolonConst.MPOS_INTERFACE_WIFI:
            case BixolonConst.MPOS_INTERFACE_ETHERNET:
                devListInJsonFormat = getNetworkDevListInJSON();
                break;
            default:
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
                return;
        }

        if(devListInJsonFormat.length() > 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, "[" + devListInJsonFormat + "]"));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL));
        }
    }

    private String getBluetoothDevListInJSON(boolean bRefresh){
        String btStringInJSON = "";
        Set<BluetoothDevice> bluetoothDeviceSet = null;
        bluetoothDeviceSet = bRefresh ? MPosControllerLookup.refreshBluetoothDevicesList() : MPosControllerLookup.getBluetoothDevicesList();
        if(bluetoothDeviceSet != null){
            if(bluetoothDeviceSet.size() > 0){
                for (BluetoothDevice device: bluetoothDeviceSet) {
                    btStringInJSON += "{\"interfaceType\": " + BixolonConst.MPOS_INTERFACE_BLUETOOTH + ",";
                    btStringInJSON += "\"name\": " + "\"" + device.getName() + "\",";
                    btStringInJSON += "\"address\": " + "\"" + device.getAddress() + "\"},";
                }
                btStringInJSON = btStringInJSON.substring(0, btStringInJSON.length() - 1);
            }
        }
        return btStringInJSON;
    }

    private String getNetworkDevListInJSON(){
        String networkStringInJSON = "";
        Set<CharSequence> networkDeviceSet = MPosControllerLookup.getWifiDevicesList();
        if(networkDeviceSet != null){
            if(networkDeviceSet.size() > 0){
                String[] items = networkDeviceSet.toArray(new String[networkDeviceSet.size()]);
                for(int i = 0; i < items.length; i++){
                    networkStringInJSON += "{\"interfaceType\": " + BixolonConst.MPOS_INTERFACE_WIFI + ",";
                    networkStringInJSON += "\"name\": " + "\"" + "" + "\",";
                    networkStringInJSON += "\"address\": " + "\"" + items[i] + "\"},";
                }
                networkStringInJSON = networkStringInJSON.substring(0, networkStringInJSON.length() - 1);
            }
        }
        return networkStringInJSON;
    }

}