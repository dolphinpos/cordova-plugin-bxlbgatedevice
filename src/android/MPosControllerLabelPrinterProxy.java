package com.bxl.bgateplugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;

import com.bixolon.BixolonConst;
import com.bixolon.mpos.MPosControllerLabelPrinter;
import com.bixolon.mpos.config.util.MPosControllerConfig;
import com.bixolon.mpos.print.FontAttribute;
import com.bixolon.mpos.event.DataEvent;
import com.bixolon.mpos.event.DataListener;
import com.bixolon.mpos.event.StatusUpdateEvent;
import com.bixolon.mpos.event.StatusUpdateListener;

public class MPosControllerLabelPrinterProxy extends CordovaPlugin implements StatusUpdateListener, DataListener{

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

    private final String ACTION_SET_TEXT_ENCODING= "setTextEncoding";
    private final String ACTION_SET_CHARACTERSET= "setCharacterset";
    private final String ACTION_SET_PRINTING_TYPE= "setPrintingType";
    private final String ACTION_SET_MARGIN= "setMargin";
    private final String ACTION_SET_BACKFEED_OPTION= "setBackFeedOption";
    private final String ACTION_SET_LENGTH= "setLength";
    private final String ACTION_SET_WIDTH= "setWidth";
    private final String ACTION_SET_BUFFER_MODE= "setBufferMode";
    private final String ACTION_SET_SPEED= "setSpeed";
    private final String ACTION_SET_DENSITY= "setDensity";
    private final String ACTION_SET_ORIENTATION= "setOrientation";
    private final String ACTION_SET_OFFSET= "setOffset";
    private final String ACTION_SET_CUTTING_POSITION= "setCuttingPosition";
    private final String ACTION_SET_AUTO_CUTTER= "setAutoCutter";

    private final String ACTION_PRINT_BUFFER= "printBuffer";
    private final String ACTION_CHECK_PRINTER_STATUS= "checkPrinterStatus";
    private final String ACTION_DRAW_TEXT_DEVICE_FONT= "drawTextDeviceFont";
    private final String ACTION_DRAW_TEXT_VECTOR_FONT= "drawTextVectorFont";
    private final String ACTION_DRAW_CIRCLE= "drawCircle";
    private final String ACTION_DRAW_IMAGE_FILE= "drawImageFile";
    private final String ACTION_DRAW_IMAGE_BASE64= "drawImageWithBase64";
    private final String ACTION_DRAW_BLOCK= "drawBlock";
    private final String ACTION_DRAW_BARCODE_1D= "drawBarcode1D";
    private final String ACTION_DRAW_BARCODE_MAXICODE= "drawBarcodeMaxiCode";
    private final String ACTION_DRAW_BARCODE_PDF417= "drawBarcodePDF417";
    private final String ACTION_DRAW_BARCODE_QRCODE= "drawBarcodeQRCode";
    private final String ACTION_DRAW_BARCOE_DATAMATRIX= "drawBarcodeDataMatrix";
    private final String ACTION_DRAW_BARCODE_AZTEC= "drawBarcodeAztec";
    private final String ACTION_DRAW_BARCODE_CODE49= "drawBarcodeCode49";
    private final String ACTION_DRAW_BARCODE_CODABLOCK= "drawBarcodeCodaBlock";
    private final String ACTION_DRAW_BARCODE_MICROPDF= "drawBarcodeMicroPDF";
    private final String ACTION_DRAW_BARCODE_IMB= "drawBarcodeIMB";
    private final String ACTION_DRAW_BARCODE_MSI= "drawBarcodeMSI";
    private final String ACTION_DRAW_BARCODE_PLESSEY= "drawBarcodePlessey";
    private final String ACTION_DRAW_BARCODE_TLC39= "drawBarcodeTLC39";
    private final String ACTION_DRAW_BARCODE_RSS= "drawBarcodeRSS";

    private final String TAG = MPosControllerLabelPrinterProxy.class.getSimpleName();
    private final boolean DEBUG = true;
    private CallbackContext statusUpdateCallback = null;
    private CallbackContext dataOccurredCallback = null;
    private MPosControllerLabelPrinter mPosLabelPrinter;
    private Context mContext = null;


    @Override
    public void pluginInitialize() {
        mContext = webView.getContext();
        mPosLabelPrinter = new MPosControllerLabelPrinter();
        //mPosLabelPrinter.addStatusUpdateListener(this);
        //mPosLabelPrinter.addDataListener(this);
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
        //else if(action.equals(METHOD_SET_STATUS_UPDATE_EVENT))  { setStatusUpdateEvent(args, callbackContext); return true; } 
        //else if(action.equals(METHOD_SET_DATA_OCCURRED_EVENT))  { setDataOccurredEvent(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_TEXT_ENCODING))        { setTextEncoding(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_CHARACTERSET))         { setCharacterset(args, callbackContext); return true; }  // 
        else if(action.equals(ACTION_SET_PRINTING_TYPE))        { setPrintingType(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_MARGIN))               { setMargin(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_BACKFEED_OPTION))      { setBackFeedOption(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_LENGTH))               { setLength(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_WIDTH))                { setWidth(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_BUFFER_MODE))          { setBufferMode(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_DENSITY))              { setDensity(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_ORIENTATION))          { setOrientation(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_OFFSET))               { setOffset(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_CUTTING_POSITION))     { setCutterPosition(args, callbackContext); return true; }     
        else if(action.equals(ACTION_SET_AUTO_CUTTER))          { setAutoCutter(args, callbackContext); return true; }     
        else if(action.equals(ACTION_PRINT_BUFFER))             { printBuffer(args, callbackContext); return true; }     
        else if(action.equals(ACTION_CHECK_PRINTER_STATUS))     { checkPrinterStatus(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_TEXT_DEVICE_FONT))    { drawTextDeviceFont(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_TEXT_VECTOR_FONT))    { drawTextVectorFont(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_CIRCLE))              { drawCircle(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_IMAGE_FILE))          { drawImageFile(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_IMAGE_BASE64))        { drawImage(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BLOCK))               { drawBlock(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_1D))          { drawBarcode1D(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_MAXICODE))    { drawBarcodeMaxiCode(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_PDF417))      { drawBarcodePDF417(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_QRCODE))      { drawBarcodeQRCode(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCOE_DATAMATRIX))   { drawBarcodeDataMatrix(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_AZTEC))       { drawBarcodeAztec(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_CODE49))      { drawBarcodeCode49(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_CODABLOCK))   { drawBarcodeCodaBlock(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_MICROPDF))    { drawBarcodeMicroPDF(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_IMB))         { drawBarcodeIMB(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_MSI))         { drawBarcodeMSI(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_PLESSEY))     { drawBarcodePlessey(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_TLC39))       { drawBarcodeTLC39(args, callbackContext); return true; }     
        else if(action.equals(ACTION_DRAW_BARCODE_RSS))         { drawBarcodeRSS(args, callbackContext); return true; }     
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
        statusStringInJSON += "[{\"deviceid\": " + mPosLabelPrinter.getDeviceId() + ",";
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
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, mPosLabelPrinter.isOpen()));
    }

    private void getDeviceId(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, mPosLabelPrinter.getDeviceId()));
    }

    private void setTransaction(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setTransaction(args.getInt(0)/*mode*/);
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
        long result = mPosLabelPrinter.openService(deviceID, mContext);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }        
        // final int deviceID = args.getInt(0);
        // cordova.getThreadPool().execute(new Runnable() {
        //     public void run() {
        //         long result = mPosLabelPrinter.openService(deviceID, mContext);
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
        long result =  mPosLabelPrinter.closeService(args.getInt(0)/*timeout in seconds*/);
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
        long result = mPosLabelPrinter.selectInterface(args.getInt(0)/*interface type*/, args.getString(1)/*address*/);
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
        long result = mPosLabelPrinter.selectCommandMode(args.getInt(0)/*command mode*/);
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
        long result = mPosLabelPrinter.directIO(data);
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
        long result = mPosLabelPrinter.setTimeout(args.getInt(0)/*timeout*/);
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
        long result = mPosLabelPrinter.setReadMode(args.getInt(0)/*control*/);
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


    private void setTextEncoding(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        // 여기에서 문자열 인코딩 값 변경 필요, Android 정의된 코드페이지 상수 값과 Cordova에서 사용하는 코드페이지 상수 값 다름
        long result = mPosLabelPrinter.setTextEncoding(args.getInt(0)/*textEncodeing*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setCharacterset(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        // 여기에서 문자열 인코딩 값 변경 필요, Android 정의된 코드페이지 상수 값과 Cordova에서 사용하는 코드페이지 상수 값 다름
        long result = mPosLabelPrinter.setCharacterSet(args.getInt(0)/*characterset*/, args.getInt(1)/*international characterset*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setPrintingType(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setPrintingType(args.getString(0).charAt(0)/*printingType*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setMargin(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setMarginValue(args.getInt(0)/*horizontalMargin*/, args.getInt(1)/*verticalMargin*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setBackFeedOption(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setBackFeedOption(args.getBoolean(0)/*bEnable*/, args.getInt(1)/*stepQuantity*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setLength(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 4){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setLength(args.getInt(0)/*labelLength*/, args.getInt(1)/*gapLength*/, 
        args.getString(2).charAt(0)/*mediaType*/, args.getInt(3)/*offsetLength*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setWidth(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setWidth(args.getInt(0)/*labelWidth*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setBufferMode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setBufferMode(args.getBoolean(0)/*doubleBuffer*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setDensity(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setDensity(args.getInt(0)/*density*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setOrientation(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setOrientation(args.getString(0).charAt(0)/*orientation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setOffset(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setOffset(args.getInt(0)/*offset*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
    
    private void setCutterPosition(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setCutterPosition(args.getInt(0)/*offset*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void setAutoCutter(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 2){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.setAutoCutter(args.getBoolean(0)/*enableAutoCutter*/, args.getInt(1)/*cuttingPeriod*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void printBuffer(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 1){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.printBuffer(args.getInt(0)/*numberOfCopies*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void checkPrinterStatus(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        long result = mPosLabelPrinter.checkPrinterStatus();
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
    }

    private void drawTextDeviceFont(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 12){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String strFontSelection = args.getString(3);
        char chFont = strFontSelection.charAt(0);
        long result = mPosLabelPrinter.drawTextDeviceFont(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, chFont/*fontSelection*/,
                args.getInt(4)/*fontWidth*/, args.getInt(5)/*fontHeight*/, args.getInt(6)/*rightSpace*/, args.getInt(7)/*rotation*/,
                args.getBoolean(8)/*reverse*/, args.getBoolean(9)/*bold*/, args.getBoolean(10)/*rightToLeft*/, args.getInt(11)/*textAlignment*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawTextVectorFont(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 13){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String strFontSelection = args.getString(3);
        char chFont = strFontSelection.charAt(0);
        long result = mPosLabelPrinter.drawTextVectorFont(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, chFont/*fontSelection*/,
                args.getInt(4)/*fontWidth*/, args.getInt(5)/*fontHeight*/, args.getInt(6)/*rightSpace*/, args.getInt(7)/*rotation*/,
                args.getBoolean(8)/*reverse*/, args.getBoolean(9)/*bold*/, args.getBoolean(10)/*italic*/, args.getBoolean(11)/*rightToLeft*/,
                args.getInt(12)/*alignment*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawCircle(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 4){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String strFontSelection = args.getString(3);
        char chFont = strFontSelection.charAt(0);
        long result = mPosLabelPrinter.drawCircle(args.getInt(0)/*startPosX*/, args.getInt(1)/*startPosY*/, args.getInt(2)/*size*/, args.getInt(3)/*multiplier*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawImageFile(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawImageFile(args.getString(0)/*pathName*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*mulwidthtiplier*/,
        args.getInt(4)/*level*/, args.getBoolean(5)/*dithering*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawImage(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        String base64EncodedData = args.getString(0);

        byte[] imageAtBytes = Base64.decode(base64EncodedData.getBytes(), Base64.DEFAULT);
        Bitmap image =  BitmapFactory.decodeByteArray(imageAtBytes, 0, imageAtBytes.length);
        //Bitmap image = getDecodedBitmap(base64EncodedData); //getBitmap(imageURL);
        long result = mPosLabelPrinter.drawImage(image/*bitmap*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*width*/, args.getInt(4)/*level*/,
                args.getBoolean(5)/*dithering*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBlock(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBlock(args.getInt(0)/*startPosX*/, args.getInt(1)/*startPosY*/, args.getInt(2)/*endPosX*/, args.getInt(3)/*endPosY*/,
        args.getString(4)/*option*/, args.getInt(5)/*thickness*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcode1D(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 10){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcode1D(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*barcodeType*/,
        args.getInt(4)/*widthNarrow*/, args.getInt(5)/*widthWide*/, args.getInt(6)/*height*/, args.getInt(7)/*hri*/,
        args.getInt(8)/*quietZoneWidth*/, args.getInt(9)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeMaxiCode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 4){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeMaxiCode(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*mode*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodePDF417(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 12){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodePDF417(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*rowCount*/,
        args.getInt(4)/*columnCount*/, args.getInt(5)/*eccLevel*/, args.getInt(6)/*dataCompression*/, args.getBoolean(7)/*hri*/,
        args.getInt(8)/*startPosition*/, args.getInt(9)/*moduleWidth*/, args.getInt(10)/*barHeight*/, args.getInt(11)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeQRCode(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 7){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeQRCode(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*size*/,
        args.getInt(4)/*model*/, args.getInt(5)/*eccLevel*/, args.getInt(6)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeDataMatrix(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 6){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeDataMatrix(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*size*/,
        args.getBoolean(4)/*reverse*/, args.getInt(5)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeAztec(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 10){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeAztec(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*size*/,
        args.getBoolean(4)/*extendedChannel*/, args.getInt(5)/*eccLevel*/, args.getBoolean(6)/*menuSymbol*/,
        args.getInt(7)/*numberOfSymbls*/, args.getString(8)/*staroptionalIDtPosition*/, args.getInt(9)/*rotation*/);
        
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeCode49(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 9){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeCode49(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*widthNarrow*/,
        args.getInt(4)/*widthWide*/, args.getInt(5)/*height*/, args.getInt(6)/*hri*/,
        args.getInt(7)/*startingMode*/, args.getInt(8)/*rotation*/);

        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeCodaBlock(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 10){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeCodaBlock(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*widthNarrow*/,
                args.getInt(4)/*widthWide*/, args.getInt(5)/*height*/, args.getBoolean(6)/*securityLevel*/,
                args.getInt(7)/*dataColumns*/, args.getString(8).charAt(0)/*mode*/, args.getInt(9)/*encode*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeMicroPDF(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 7){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeMicroPDF(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*moduleWidth*/,
        args.getInt(4)/*height*/, args.getInt(5)/*mode*/, args.getInt(6)/*rotation*/);    
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeIMB(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 5){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeIMB(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getBoolean(3)/*hri*/,
        args.getInt(4)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeMSI(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 10){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeMSI(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*widthNarrow*/,
        args.getInt(4)/*widthWide*/, args.getInt(5)/*height*/, args.getInt(6)/*checkDigit*/, args.getBoolean(7)/*printCheckDigit*/,
        args.getInt(8)/*hri*/, args.getInt(9)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodePlessey(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 9){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodePlessey(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*widthNarrow*/,
        args.getInt(4)/*widthWide*/, args.getInt(5)/*height*/, args.getBoolean(6)/*printCheckDigit*/, args.getInt(7)/*hri*/, args.getInt(8)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeTLC39(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 9){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeTLC39(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*widthNarrow*/,
        args.getInt(4)/*widthWide*/, args.getInt(5)/*height*/, args.getInt(6)/*rowHeightOfMicroPDF417*/,
        args.getInt(7)/*narrowWidthOfMicroPDF417*/, args.getInt(8)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }

    private void drawBarcodeRSS(final JSONArray args, final CallbackContext callbackContext) throws JSONException{
        if(args.length() < 9){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, BixolonConst.MPOS_FAIL_INVALID_PARAMETER));
            return;
        }
        long result = mPosLabelPrinter.drawBarcodeRSS(args.getString(0)/*data*/, args.getInt(1)/*xPos*/, args.getInt(2)/*yPos*/, args.getInt(3)/*barcodeType*/,
        args.getInt(4)/*magnification*/, args.getInt(5)/*separatorHeight*/, args.getInt(6)/*height*/,
        args.getInt(7)/*segmentWidth*/, args.getInt(8)/*rotation*/);
        if(result == 0){
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
        }else{
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, result));
        }
    }
}