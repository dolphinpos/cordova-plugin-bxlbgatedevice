package com.bxl.bgateplugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;

import com.bixolon.BixolonConst;
import com.bixolon.mpos.MPosControllerPrinter;
import com.bixolon.mpos.config.util.MPosControllerConfig;
import com.bixolon.mpos.print.FontAttribute;

import com.bixolon.mpos.event.DataEvent;
import com.bixolon.mpos.event.DataListener;
import com.bixolon.mpos.event.StatusUpdateEvent;
import com.bixolon.mpos.event.StatusUpdateListener;

public class MPosControllerPrinterProxy extends CordovaPlugin implements StatusUpdateListener, DataListener{

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

    private final String ACTION_PRINT_QRCODE = "printQRCode";
    private final String ACTION_PRINT_PDF417 = "printPDF417";
    private final String ACTION_PRINT_1D_BARCODE = "print1DBarcode";
    private final String ACTION_PRINT_DATAMATRIX = "printDataMatrix";
    private final String ACTION_PRINT_GS1DATABAR = "printGS1Databar";
    private final String ACTION_PRINT_TEXT = "printText";
    private final String ACTION_PRINT_BITMAP_FILE = "printBitmapFile";
    private final String ACTION_PRINT_BITMAP_BASE64 = "printBitmapWithBase64";
    private final String ACTION_SET_CHARACTERSET = "setCharacterset";
    private final String ACTION_SET_TEXT_ENCODING = "setTextEncoding";
    private final String ACTION_SET_ICS = "setInternationalCharacterset";
    private final String ACTION_SET_PAGEMODE = "setPagemode";
    private final String ACTION_SET_PAGEMODE_AREA = "setPagemodePrintArea";
    private final String ACTION_SET_PAGEMODE_POSITION = "setPagemodePosition";
    private final String ACTION_CHECK_BATTARY = "checkBattStatus";
    private final String ACTION_CHECK_PRINTER_STATUS = "checkPrinterStatus";
    private final String ACTION_ASB_ENABLE = "asbEnable";
    private final String ACTION_CUT_PAPER = "cutPaper";
    private final String ACTION_OPEN_DRAWER = "openDrawer";
    
    private final String TAG = MPosControllerPrinterProxy.class.getSimpleName();
    private final boolean DEBUG = true;
    private CallbackContext statusUpdateCallback = null;
    private CallbackContext dataOccurredCallback = null;
    private MPosControllerPrinter mPosPrinter;
    private Context mContext = null;
        
    @Override
    public void pluginInitialize() {
        mContext = webView.getContext();
        mPosPrinter = new MPosControllerPrinter();
        mPosPrinter.addStatusUpdateListener(this);
        mPosPrinter.addDataListener(this);
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
        // DEVICE SPECIFIC METHOD
        else if(action.equals(ACTION_PRINT_QRCODE))             { printQRCode(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_PDF417))             { printPDF417(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_1D_BARCODE))         { print1DBarcode(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_DATAMATRIX))         { printDataMatrix(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_GS1DATABAR))         { printGS1Databar(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_TEXT))               { printText(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_BITMAP_FILE))        { printBitmapFile(args, callbackContext); return true; } 
        else if(action.equals(ACTION_PRINT_BITMAP_BASE64))      { printBitmapWithBase64(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_CHARACTERSET))         { setCharacterset(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_TEXT_ENCODING))        { setTextEncoding(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_ICS))                  { setInternationalCharacterset(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_PAGEMODE))             { setPagemode(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_PAGEMODE_AREA))        { setPagemodePrintArea(args, callbackContext); return true; } 
        else if(action.equals(ACTION_SET_PAGEMODE_POSITION))    { setPagemodePosition(args, callbackContext); return true; } 
        else if(action.equals(ACTION_CHECK_BATTARY))            { checkBattStatus(args, callbackContext); return true; } 
        else if(action.equals(ACTION_CHECK_PRINTER_STATUS))     { checkPrinterStatus(args, callbackContext); return true; } 
        else if(action.equals(ACTION_ASB_ENABLE))               { asbEnable(args, callbackContext); return true; } 
        else if(action.equals(ACTION_CUT_PAPER))                { cutPaper(args, callbackContext); return true; } 
        else if(action.equals(ACTION_OPEN_DRAWER))              { openDrawer(args, callbackContext); return true; }     
        else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
            return false;
        }
    }

    @Override
	public void statusUpdateOccurred(final StatusUpdateEvent statusUpdateEvent) {
        if(statusUpdateCallback == null)
            return;
        String statusStringInJSON = "";
        statusStringInJSON += "[{\"deviceid\": " + mPosPrinter.getDeviceId() + ",";
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
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, mPosPrinter.isOpen()));
    }

    private void getDeviceId(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, mPosPrinter.getDeviceId()));
    }

    private void setTransaction(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.setTransaction(args.getInt(0)/*mode*/);
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
        long result = mPosPrinter.openService(deviceID, mContext);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }        
        // final int deviceID = args.getInt(0);
        // cordova.getThreadPool().execute(new Runnable() {
        //     public void run() {
        //         long result = mPosPrinter.openService(deviceID, mContext);
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
        long result =  mPosPrinter.closeService(args.getInt(0)/*timeout in seconds*/);
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
        long result = mPosPrinter.selectInterface(args.getInt(0)/*interface type*/, args.getString(1)/*address*/);
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
        long result = mPosPrinter.selectCommandMode(args.getInt(0)/*command mode*/);
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
        long result = mPosPrinter.directIO(data);
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
        long result = mPosPrinter.setTimeout(args.getInt(0)/*timeout*/);
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
        long result = mPosPrinter.setReadMode(args.getInt(0)/*control*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void getResult(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
    }

    private void convertHID(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_NOT_SUPPORT));
    }

    private void setStatusUpdateEvent(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        statusUpdateCallback = callbackContext;
    }

    private void setDataOccurredEvent(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        dataOccurredCallback = callbackContext;
    }

    // DEVICE METHOD
    private void printQRCode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 5){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.printQrCode(args.getString(0)/*data*/, args.getInt(1)/*model*/, args.getInt(2)/*alignment*/, 
        args.getInt(3)/*size*/, args.getInt(4)/*controerrorCorrectionLevell*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printPDF417(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 8){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.printPDF417(args.getString(0)/*data*/, args.getInt(1)/*symbol*/, args.getInt(2)/*alignment*/, 
        args.getInt(3)/*columnNumber*/,  args.getInt(4)/*rowNumber*/, args.getInt(5)/*moduleWidth*/, args.getInt(6)/*moduleHeight*/, 
        args.getInt(7)/*eccLevel*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void print1DBarcode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.print1dBarcode(args.getString(0)/*data*/, args.getInt(1)/*symbol*/, args.getInt(2)/*width*/, 
        args.getInt(3)/*height*/, args.getInt(4)/*alignment*/, args.getInt(5)/*textPosition*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printDataMatrix(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 3){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.printDataMatrix(args.getString(0)/*data*/, args.getInt(1)/*alignment*/, args.getInt(2)/*moduleSize*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printGS1Databar(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 4){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.printGS1Databar(args.getString(0)/*data*/, args.getInt(1)/*symbol*/, args.getInt(2)/*alignment*/, 
        args.getInt(3)/*moduleSize*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printText(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String str = "[" + args.getString(1) + "]";
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = (JsonArray) jsonParser.parse(str);
        FontAttribute font = convertFontAttribute(jsonArray);
        long result = mPosPrinter.printText(args.getString(0)/*data*/, font/*attribute*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    private void printBitmapFile(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.printBitmap(args.getString(0)/*pathName*/, args.getInt(1)/*width*/, args.getInt(2)/*alignment*/, 
        args.getInt(3)/*brightness*/, args.getBoolean(4)/*isDithering*/, args.getBoolean(5)/*isCompress*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printBitmapWithBase64(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String base64EncodedData = args.getString(0);
        byte[] imageAtBytes = Base64.decode(base64EncodedData.getBytes(), Base64.DEFAULT);
        Bitmap image =  BitmapFactory.decodeByteArray(imageAtBytes, 0, imageAtBytes.length);
        //Bitmap image = getDecodedBitmap(base64EncodedData); //getBitmap(imageURL);
        long result = mPosPrinter.printBitmap(image/*bitmap*/, args.getInt(1)/*width*/, args.getInt(2)/*alignment*/, args.getInt(3)/*brightness*/,
                args.getBoolean(4)/*isDithering*/, args.getBoolean(5)/*isCompress*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setCharacterset(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        // 여기에서 문자열 인코딩 값 변경 필요, Android 정의된 코드페이지 상수 값과 Cordova에서 사용하는 코드페이지 상수 값 다름
        long result = mPosPrinter.setCharacterset(args.getInt(0)/*characterset*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setTextEncoding(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        // 여기에서 문자열 인코딩 값 변경 필요, Android 정의된 코드페이지 상수 값과 Cordova에서 사용하는 코드페이지 상수 값 다름
        long result = mPosPrinter.setTextEncoding(args.getInt(0)/*textEncodeing*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    
    private void setInternationalCharacterset(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.setInternationalCharacterset(args.getInt(0)/*internationalCharacterset*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setPagemode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.setPageMode(args.getInt(0)/*pagemode*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setPagemodePrintArea(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 4){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.setPagemodePrintArea(args.getInt(0)/*x*/, args.getInt(1)/*y*/, args.getInt(2)/*width*/, args.getInt(3)/*height*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setPagemodePosition(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.setPagemodePosition(args.getInt(0)/*x*/, args.getInt(1)/*y*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void checkBattStatus(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        long result = mPosPrinter.checkBattStatus();
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
    }

    private void checkPrinterStatus(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        long result = mPosPrinter.checkPrinterStatus();
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
    }

    private void asbEnable(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.asbEnable(args.getBoolean(0));
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    private void cutPaper(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.cutPaper(args.getInt(0)/*cutType*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    private void openDrawer(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosPrinter.openDrawer(args.getInt(0)/*pinNumber*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private FontAttribute convertFontAttribute(JsonArray jsonArray) {
        if(jsonArray == null){
            return null;
        }
        int fontType = 0, width= 0, height= 0, alignment= 0, codePage = 437;
        boolean bold = false, underline = false, reverse = false;
        for (int i = 0; i < jsonArray.size(); i++) {
            JsonObject object = (JsonObject) jsonArray.get(i);
            codePage = object.get("codePage").getAsInt();
            fontType = object.get("fontType").getAsInt();
            width = object.get("width").getAsInt();
            height = object.get("height").getAsInt();
            alignment = object.get("alignment").getAsInt();
            bold = object.get("bold").getAsBoolean();
            underline = object.get("underline").getAsBoolean();
            reverse = object.get("reverse").getAsBoolean();
        }
        FontAttribute font = new FontAttribute();
        font.setTextEncoding(codePage);
        font.setFontType(fontType);
        font.setFontSize(width|height);
        font.setAlignment(alignment);
        font.setBold(bold);
        font.setUnderline(underline);
        font.setReverse(reverse);
        return font;
    }
}