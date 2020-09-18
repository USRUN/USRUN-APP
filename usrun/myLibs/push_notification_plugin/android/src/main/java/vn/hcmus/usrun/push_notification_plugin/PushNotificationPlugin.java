package vn.hcmus.usrun.push_notification_plugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.google.firebase.messaging.RemoteMessage;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

/** PushNotificationPlugin */
public class PushNotificationPlugin implements MethodCallHandler {
  private static Registrar registrar;
  private static MethodChannel channel;

  private static BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      // Get extra data included in the Intent
      String action = intent.getAction();

      if (action == null) {
        return;
      }

      if (action.equals(MessageService.ACTION_TOKEN)) {
        String token = intent.getStringExtra(MessageService.EXTRA_TOKEN);
        SharedPreferences.Editor editor = registrar.activeContext().getSharedPreferences("USRUN_SHARED_PREFERENCES", Context.MODE_PRIVATE).edit();
        editor.putString("USRUN_DEVICE_TOKEN", token);
        editor.commit();
      } else if (action.equals(MessageService.ACTION_REMOTE_MESSAGE)) {
        RemoteMessage message = intent.getParcelableExtra(MessageService.EXTRA_REMOTE_MESSAGE);
        Map<String, Object> content = parseRemoteMessage(message);
        channel.invokeMethod("onPushNotification", content);
      }
    }

    private Map<String, Object> parseRemoteMessage(RemoteMessage message) {
      Map<String, Object> content = new HashMap<>();
      content.put("title", message.getData().get("title"));
      content.put("message", message.getData().get("message"));

      return content;
    }
  };

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/push_notification");
    final PushNotificationPlugin plugin = new PushNotificationPlugin(registrar, channel);
    channel.setMethodCallHandler(plugin);
  }

  private PushNotificationPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;

    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction(MessageService.ACTION_TOKEN);
    intentFilter.addAction(MessageService.ACTION_REMOTE_MESSAGE);
    LocalBroadcastManager manager = LocalBroadcastManager.getInstance(registrar.context());
    manager.registerReceiver(mMessageReceiver, intentFilter);
  }

  @Override
  public void onMethodCall(final MethodCall call, final Result result) {
    if ("getDeviceToken".equals(call.method)) {
      SharedPreferences prefs = registrar.activeContext().getSharedPreferences("USRUN_SHARED_PREFERENCES", Context.MODE_PRIVATE);
      String token = prefs.getString("USRUN_DEVICE_TOKEN", null);
      channel.invokeMethod("onDeviceToken", token);
    }
    else {
      result.notImplemented();
    }
  }
}
