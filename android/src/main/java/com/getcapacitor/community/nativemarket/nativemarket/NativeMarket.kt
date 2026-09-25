package com.getcapacitor.community.nativemarket

import android.content.Intent
import android.net.Uri
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginException
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "NativeMarket")
public class NativeMarket : Plugin() {
    @PluginMethod
    public fun openStoreListing(call: PluginCall) {
        if (!call.data.has("appId")) {
            throw PluginException("appId is missing")
        }
        try {
            val appId = call.getString("appId")

            val context = bridge.activity.applicationContext
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$appId"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)

            call.resolve()
        } catch (ex: Exception) {
            call.reject(ex.localizedMessage)
        }
    }

    @PluginMethod
    public fun openDevPage(call: PluginCall) {
        if (!call.data.has("devId")) {
            throw PluginException("devId is missing")
        }
        try {
            val devId = call.getString("devId")

            val intent = Intent(Intent.ACTION_VIEW)
            intent.setData(Uri.parse("https://play.google.com/store/apps/dev?id=$devId"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)

            call.resolve()
        } catch (ex: Exception) {
            call.reject(ex.localizedMessage)
        }
    }

    @PluginMethod
    public fun openCollection(call: PluginCall) {
        if (!call.data.has("name")) {
            throw PluginException("name is missing")
        }
        try {
            val name = call.getString("name")

            val intent = Intent(Intent.ACTION_VIEW)
            intent.setData(Uri.parse("https://play.google.com/store/apps/collection/$name"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)

            call.resolve()
        } catch (ex: Exception) {
            call.reject(ex.localizedMessage)
        }
    }

    @PluginMethod
    public fun openEditorChoicePage(call: PluginCall) {
        if (!call.data.has("editorChoice")) {
            throw PluginException("editorChoice is missing")
        }
        try {
            val editorChoice = call.getString("editorChoice")

            val intent = Intent(Intent.ACTION_VIEW)
            intent.setData(Uri.parse("https://play.google.com/store/apps/topic?id=$editorChoice"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)

            call.resolve()
        } catch (ex: Exception) {
            call.reject(ex.localizedMessage)
        }
    }

    @PluginMethod
    public fun search(call: PluginCall) {
        if (!call.data.has("terms")) {
            throw PluginException("terms is missing")
        }
        try {
            val terms = call.getString("terms")

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("market://search?q=$terms"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)

            call.resolve()
        } catch (ex: Exception) {
            call.reject(ex.localizedMessage)
        }
    }
}
