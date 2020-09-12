/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.lyokone.location.services;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;

import com.lyokone.location.R;

// import android.support.v4.app.TaskStackBuilder;

/**
 * Class to process location results.
 */
public class LocationResultHelper {


    final private static String PRIMARY_CHANNEL = "default";


    /**
     * Get the notification mNotificationManager.
     * <p>
     * Utility method as this helper works with it a lot.
     *
     * @return The system service NotificationManager
     */
    private static NotificationManager getNotificationManager(Context context) {
        NotificationManager manager = (NotificationManager)context.getSystemService(
                    Context.NOTIFICATION_SERVICE);
        return manager;
    }

    /**
     * Displays a notification with the location results.
     */
    public static void showNotification(Context context, String titleNotification, String contentNotification) {
        // Intent notificationIntent = new Intent(mContext, mContext);

        // Construct a task stack.
        // TaskStackBuilder stackBuilder = TaskStackBuilder.create(mContext);

        // Add the main Activity to the task stack as the parent.
        // stackBuilder.addParentStack(MainActivity.class);

        // Push the content Intent onto the stack.
        // stackBuilder.addNextIntent(notificationIntent);

        // Get a PendingIntent containing the entire back stack.
        // PendingIntent notificationPendingIntent =
        //       stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);

        Notification.Builder mBuilder = null;
        NotificationManager notificationManager = getNotificationManager(context);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            NotificationChannel channel = new NotificationChannel(PRIMARY_CHANNEL,
                    context.getString(R.string.default_channel), NotificationManager.IMPORTANCE_LOW);
            channel.setLightColor(Color.GREEN);
            channel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            notificationManager.createNotificationChannel(channel);
                     mBuilder =  new Notification.Builder(context,
                    PRIMARY_CHANNEL)
                    .setContentTitle(titleNotification)
                    .setContentText(contentNotification)
                    .setSmallIcon(R.drawable.app_icon)
                    .setAutoCancel(true);
                    //.setContentIntent(notificationPendingIntent);
            notificationManager.notify(0, mBuilder.build());
        } else {
            mBuilder = new Notification.Builder(context);
            mBuilder.setContentTitle(titleNotification)
                    .setContentText(contentNotification)
                    .setSmallIcon(R.drawable.app_icon)
                    .setAutoCancel(true);
            notificationManager.notify(0, mBuilder.build());
        }

    }

    public static void hideNotification(Context context) {
        NotificationManager notificationManager = getNotificationManager(context);
        notificationManager.cancel(0);
    }
}
