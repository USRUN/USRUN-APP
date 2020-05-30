package com.lyokone.location;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.lyokone.location.services.LocationConst;
import com.lyokone.location.services.LocationRequestHelper;
import com.lyokone.location.services.LocationResultHelper;
import com.lyokone.location.services.LocationUpdatesBroadcastReceiver;
import com.lyokone.location.services.LocationUpdatesIntentService;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


public class LocationServicePlugin  implements MethodChannel.MethodCallHandler, GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener {

    private static final String TAG = "LocationServicePlugin";

    private static final String STREAM_CHANNEL_NAME = "usrun/locationstream";

    private static final String METHOD_CHANNEL_NAME = "usrun/location";


    private Context mAplicationContext;

    private Activity mActivity;

    /**
     * Stores parameters for requests to the FusedLocationProviderApi.
     */
    private LocationRequest mLocationRequest;

    /**
     * The entry point to Google Play Services.
     */
    private GoogleApiClient mGoogleApiClient;

    FusedLocationProviderClient mFusedLocationProviderClient;


    LocationServicePlugin(Activity activity) {
        this.mAplicationContext = activity.getApplicationContext();
        this.mActivity = activity;
        this.buildGoogleApiClient();
        this.createLocationRequest();
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        if (registrar.activity() != null) {
            LocationServicePlugin locationServicePlugin = new LocationServicePlugin(registrar.activity());

            final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
            channel.setMethodCallHandler(locationServicePlugin);
        } else {
            Log.e(TAG, "register activity is null");
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("startBackgroundLocation")) {
            // Log.e(TAG, "startBackgroundLocation");
//            this.requestLocationUpdates();

            Intent intent = new Intent(this.mActivity, BackgroundLocationUpdateService.class);
            intent.setAction(BackgroundLocationUpdateService.STARTFOREGROUND_ACTION);
            this.mActivity.startService(intent);
        } else if (call.method.equals("stopBackgroundLocation")){
            // Log.e(TAG, "stopBackgroundLocation");
//            this.removeLocationUpdates();
//            LocationResultHelper.hideNotification(mAplicationContext);

            Intent intent = new Intent(this.mActivity, BackgroundLocationUpdateService.class);
            intent.setAction(BackgroundLocationUpdateService.STOPFOREGROUND_ACTION);
            this.mActivity.startService(intent);

        } else if (call.method.equals("isStartLocationBackground")) {
            boolean isRequesting = LocationRequestHelper.getRequesting(mAplicationContext);
            result.success(isRequesting);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        Log.v(TAG, "onConnected");
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.v(TAG, "onConnectionSuspended");
    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Log.v(TAG, "onConnectionFailed");
    }

    private PendingIntent getPendingIntent() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent intent = new Intent(mAplicationContext, LocationUpdatesBroadcastReceiver.class);
            intent.setAction(LocationConst.ACTION_PROCESS_UPDATES);
            return PendingIntent.getBroadcast(mAplicationContext, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        } else {
            Intent intent = new Intent(mAplicationContext, LocationUpdatesIntentService.class);
            intent.setAction(LocationConst.ACTION_PROCESS_UPDATES);
            return PendingIntent.getService(mAplicationContext, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        }
    }

    private void buildGoogleApiClient() {
        if (mGoogleApiClient != null) {
            return;
        }
        mGoogleApiClient = new GoogleApiClient.Builder(mAplicationContext)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build();
    }

    private void createLocationRequest() {
        mLocationRequest = new LocationRequest();

        //mLocationRequest.setInterval(LocationConst.UPDATE_INTERVAL);

        // Sets the fastest rate for active location updates. This interval is exact, and your
        // application will never receive updates faster than this value.
        //mLocationRequest.setFastestInterval(LocationConst.FASTEST_UPDATE_INTERVAL);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        mLocationRequest.setSmallestDisplacement(0f);
        // Sets the maximum time when batched location updates are delivered. Updates may be
        // delivered sooner than this interval.
        // mLocationRequest.setMaxWaitTime(MAX_WAIT_TIME);
    }

    /**
     * Handles the Request Updates button and requests start of location updates.
     */
    public void requestLocationUpdates() {
        if (LocationRequestHelper.getRequesting(mAplicationContext)) {
            this.removeLocationUpdates();
        }
        try {
            Log.i(TAG, "Starting location updates");
            LocationRequestHelper.setRequesting(mAplicationContext, true);
            mFusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(mAplicationContext);
            mFusedLocationProviderClient.requestLocationUpdates(mLocationRequest, getPendingIntent());
        } catch (SecurityException e) {
            LocationRequestHelper.setRequesting(mAplicationContext, false);
            e.printStackTrace();
        }
    }

    /**
     * Handles the Remove Updates button, and requests removal of location updates.
     */
    public void removeLocationUpdates() {
        if (LocationRequestHelper.getRequesting(mAplicationContext)) {
            LocationRequestHelper.setRequesting(mAplicationContext, false);
            if (mFusedLocationProviderClient != null) {
                mFusedLocationProviderClient.removeLocationUpdates(getPendingIntent());
            }

        }
    }

}
