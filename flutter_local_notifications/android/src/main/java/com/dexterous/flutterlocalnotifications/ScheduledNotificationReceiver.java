package com.dexterous.flutterlocalnotifications;

import android.app.Notification;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.Keep;
import androidx.core.app.NotificationManagerCompat;
import com.dexterous.flutterlocalnotifications.models.PayLoad;
import com.dexterous.flutterlocalnotifications.models.NotificationDetails;
import com.dexterous.flutterlocalnotifications.utils.StringUtils;
import com.dexterous.flutterlocalnotifications.utils.Util;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.EventChannel;

/**
 * Created by michaelbui on 24/3/18.
 */

@Keep
public class ScheduledNotificationReceiver extends BroadcastReceiver {

    private Handler mainHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onReceive(final Context context, Intent intent) {
        if(!Util.foregrounded()){
            Intent appIntent = context.getPackageManager().getLaunchIntentForPackage("com.iamplus.mafplus");
            appIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            context.startActivity(appIntent);
        }

        String notificationDetailsJson = intent.getStringExtra(FlutterLocalNotificationsPlugin.NOTIFICATION_DETAILS);
        if (StringUtils.isNullOrEmpty(notificationDetailsJson)) {
            // This logic is needed for apps that used the plugin prior to 0.3.4
            Notification notification = intent.getParcelableExtra("notification");
            notification.when = System.currentTimeMillis();
            int notificationId = intent.getIntExtra("notification_id",
                    0);
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
            notificationManager.notify(notificationId, notification);
            boolean repeat = intent.getBooleanExtra("repeat", false);
            if (!repeat) {
                FlutterLocalNotificationsPlugin.removeNotificationFromCache(context, notificationId);
            }
        } else {
            Gson gson = FlutterLocalNotificationsPlugin.buildGson();
            Type type = new TypeToken<NotificationDetails>() {
            }.getType();
            NotificationDetails notificationDetails = gson.fromJson(notificationDetailsJson, type);
            notificationDetails.appState = Util.getAppState();
            // FlutterLocalNotificationsPlugin.eventSink.success("Gson().toJson(payload)");
            PayLoad payload = new PayLoad(notificationDetails.payload,notificationDetails.appState);
            String updatedPayload = gson.toJson(payload).toString();



            sendEvent(updatedPayload);

            FlutterLocalNotificationsPlugin.showNotification(context, notificationDetails);
            if (notificationDetails.scheduledNotificationRepeatFrequency != null) {
                FlutterLocalNotificationsPlugin.zonedScheduleNextNotification(context, notificationDetails);
            } else if (notificationDetails.matchDateTimeComponents != null) {
                FlutterLocalNotificationsPlugin.zonedScheduleNextNotificationMatchingDateComponents(context, notificationDetails);
            } else if (notificationDetails.repeatInterval != null) {
                FlutterLocalNotificationsPlugin.scheduleNextRepeatingNotification(context, notificationDetails);
            } else {
                FlutterLocalNotificationsPlugin.removeNotificationFromCache(context, notificationDetails.id);
            }
        }

    }


    private void sendEvent(final String updatedPayload) {

        Runnable runnable =
                new Runnable() {
                    @Override
                    public void run() {
                        FlutterLocalNotificationsPlugin.eventSink.success(updatedPayload);
                    }
                };
        mainHandler.post(runnable);
    }


}

