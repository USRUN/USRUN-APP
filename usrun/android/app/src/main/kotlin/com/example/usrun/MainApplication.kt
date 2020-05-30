package com.example.usrun

import android.content.Context;
import android.content.Intent;

import com.lyokone.location.BackgroundLocationUpdateService;

import androidx.multidex.MultiDex;
import io.flutter.app.FlutterApplication;

class MainApplication : FlutterApplication() {
    protected override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
        java.lang.Thread.setDefaultUncaughtExceptionHandler(object : Thread.UncaughtExceptionHandler {
            override fun uncaughtException(thread: Thread, throwable: Throwable) {
                handleUncaughtExeption(thread, throwable)
            }
        })
    }

    private fun handleUncaughtExeption(thread: Thread, e: Throwable) {
        val stopIntent = Intent(this, BackgroundLocationUpdateService::class.java)
        stopIntent.setAction(BackgroundLocationUpdateService.STARTFOREGROUND_ACTION)
        startService(stopIntent)
    }
}
