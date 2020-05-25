package com.lyokone.location.services;

import android.content.Context;
import android.location.Location;
import android.os.Build;
import android.preference.PreferenceManager;

import java.util.HashMap;


public class LocationRequestHelper {

    final static String KEY_LOCATION_UPDATES_REQUESTED = "location-updates-requested";

    public static void setRequesting(Context context, boolean value) {
        PreferenceManager.getDefaultSharedPreferences(context)
                .edit()
                .putBoolean(KEY_LOCATION_UPDATES_REQUESTED, value)
                .apply();
    }

    public static boolean getRequesting(Context context) {
        return PreferenceManager.getDefaultSharedPreferences(context)
                .getBoolean(KEY_LOCATION_UPDATES_REQUESTED, false);
    }

    public static HashMap<String, Double> createLocationData(Location location) {
        HashMap<String, Double> loc = new HashMap<>();
        loc.put("latitude", location.getLatitude());
        loc.put("longitude", location.getLongitude());
        loc.put("accuracy", (double) location.getAccuracy());

        loc.put("altitude", location.getAltitude());
        loc.put("speed", (double) location.getSpeed());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            loc.put("speed_accuracy", (double) location.getSpeedAccuracyMetersPerSecond());
        }

        loc.put("heading", (double) location.getBearing());
        loc.put("time", (double) location.getTime());
        return loc;
    }
}
