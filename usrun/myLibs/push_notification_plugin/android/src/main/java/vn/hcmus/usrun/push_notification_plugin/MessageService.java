package vn.hcmus.usrun.push_notification_plugin;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.Intent;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import androidx.core.app.NotificationCompat;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.text.TextUtils;

import android.util.Log;

public class MessageService extends FirebaseMessagingService {
    public static final String ACTION_REMOTE_MESSAGE = "io.flutter.plugins.usrun.NOTIFICATION";
    public static final String EXTRA_REMOTE_MESSAGE = "notification";

    public static final String ACTION_TOKEN = "io.flutter.plugins.usrun.TOKEN";
    public static final String EXTRA_TOKEN = "token";
    public final String NOTIFICATION_PREFS_NAME = "NOTIFICATION_PREFS_NAME";

    @Override
    public void onNewToken(String token) {
        Log.d("onNewToken", token);

        Intent intent = new Intent(ACTION_TOKEN);
        intent.putExtra(EXTRA_TOKEN, token);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    @Override
    public void onMessageReceived(RemoteMessage message) {
        handlePushMessage(message);

        Intent intent = new Intent(ACTION_REMOTE_MESSAGE);
        intent.putExtra(EXTRA_REMOTE_MESSAGE, message);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    private void handlePushMessage(RemoteMessage remoteMessage) {
        if (remoteMessage.getData().size() > 0) {
            String message = remoteMessage.getData().get("body");
            String title = remoteMessage.getData().get("title");

            if (TextUtils.isEmpty(title)) {
                title = "USRUN";
            }
            if (!TextUtils.isEmpty(message)) {
                showNotification(title, message);
                return;
            }
        }

        if (remoteMessage.getNotification() != null) {
            String notiBody = remoteMessage.getNotification().getBody();
            String title = remoteMessage.getNotification().getTitle();

            if (TextUtils.isEmpty(title)) {
                title = "USRUN";
            }
            if (notiBody == null) {
                return;
            }
            showNotification(title, notiBody);
        }
    }

    private void showNotification(String title, String msg) {
        int temp = 0;

        if(loadCache() != -1) {
           temp = loadCache();
        }
        Intent intent = getPackageManager().getLaunchIntentForPackage(getApplicationContext().getPackageName());
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);


        NotificationCompat.Builder builder;
        String channelId = "0";
        NotificationManager notificationManager = (NotificationManager) getApplicationContext()
                .getSystemService(NOTIFICATION_SERVICE);

        PendingIntent contentIntent = PendingIntent.getActivity(getApplicationContext(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            // from Android O, a notification channel must be set (when targetsdk is set to 26)
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(channelId, title, importance);
            mChannel.setDescription(msg);
            mChannel.enableLights(true);
            mChannel.setLightColor(Color.RED);
            notificationManager.createNotificationChannel(mChannel);
        }
        Uri notificationSound = RingtoneManager.getActualDefaultRingtoneUri(this, RingtoneManager.TYPE_NOTIFICATION);

        builder = new NotificationCompat.Builder(getApplicationContext(), channelId)
                        .setSmallIcon(R.drawable.ic_stat_name)
                        .setWhen(System.currentTimeMillis())
                        .setContentText(msg)
                        .setSound(notificationSound)
                        .setColor(Color.rgb(238, 100, 4))
                        .setContentTitle(title)
                        .setContentIntent(contentIntent)
                        .setAutoCancel(true);

        Notification notif = builder.build();
        notificationManager.notify(temp + 1, notif);
        saveCache(temp + 1);
    }

    private void saveCache(int id) {
        SharedPreferences.Editor editor = getSharedPreferences(NOTIFICATION_PREFS_NAME, MODE_PRIVATE).edit();
        editor.putInt("idData", id);
        editor.apply();
    }

    private int loadCache() {
        SharedPreferences prefs = getSharedPreferences(NOTIFICATION_PREFS_NAME, MODE_PRIVATE);
        int idData = prefs.getInt("idData", -1); //-1 is the default value.
        return idData;
    }
}
