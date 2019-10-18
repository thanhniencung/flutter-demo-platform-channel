package com.code4func.flutter_demo_platform_channel;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryCodec;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    public static final String StringCodecChannel = "StringCodec";
    public static final String JSONMessageCodecChannel = "JSONMessageCodec";
    public static final String BinaryCodecChannel = "BinaryCodec";
    public static final String StandardMessageCodecChannel = "StandardMessageCodec";

    public static final String StreamChannel = "stream";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        // method channel
        demoMethodChannel1();
        demoMethodChannel2();

        // basic message
        demoBasicMessageChannel1();
        demoBasicMessageChannel2();
        demoBasicMessageChannel3();
        demoBasicMessageChannel4();

        // event channel
        demoEventChannel();
    }

    public void demoMethodChannel1() {
        new MethodChannel(getFlutterView(), "com.code4func/method1").setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getDeviceInfoString")) {
                            String type = call.argument("type");

                            if (type == null || (type != null && type.isEmpty())) {
                                result.error("ERROR", "type can not null", null);
                                return;
                            }
                            result.success(getDeviceInfoString(type));
                            return;
                        }

                        result.notImplemented();
                    }
                });
    }

    public void demoMethodChannel2() {
        new MethodChannel(getFlutterView(), "com.code4func/method2", JSONMethodCodec.INSTANCE).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getDeviceInfo")) {
                            String type = call.argument("type");

                            if (type == null || (type != null && type.isEmpty())) {
                                result.error("ERROR", "type can not null", null);
                                return;
                            }
                            result.success(getDeviceInfo(type));
                            return;
                        }

                        result.notImplemented();
                    }
                });
    }

    ////////////////////////////////

    public void demoBasicMessageChannel1() {
        BasicMessageChannel<String> messageChannel = new BasicMessageChannel<>(getFlutterView(),
                StringCodecChannel, StringCodec.INSTANCE);

        messageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<String>() {
                    @Override
                    public void onMessage(String message, BasicMessageChannel.Reply<String> reply) {
                        messageChannel.send("Hello " + message + " from native code");
                        reply.reply(null);
                    }
                });
    }

    public void demoBasicMessageChannel2() {
        BasicMessageChannel<Object> messageChannel = new BasicMessageChannel<Object>(getFlutterView(),
                JSONMessageCodecChannel, JSONMessageCodec.INSTANCE);

        messageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<Object>() {
                    @Override
                    public void onMessage(Object message, BasicMessageChannel.Reply<Object> reply) {
                        JSONObject jsonObject = new JSONObject();
                        try {
                            jsonObject.put("phone", "0973901999");
                            jsonObject.put("email", "ryan@gmail.com");
                        } catch (Exception exp){}
                        messageChannel.send(jsonObject);
                        reply.reply(null);
                    }
                });
    }

    public void demoBasicMessageChannel3() {
        BasicMessageChannel<ByteBuffer> messageChannel = new BasicMessageChannel<ByteBuffer>(getFlutterView(),
                BinaryCodecChannel, BinaryCodec.INSTANCE);

        messageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<ByteBuffer>() {
                    @Override
                    public void onMessage(ByteBuffer message, BasicMessageChannel.Reply<ByteBuffer> reply) {
                        message.order(ByteOrder.nativeOrder());

                        ByteBuffer echo = ByteBuffer.allocateDirect(16);
                        echo.putDouble(10.12);

                        reply.reply(echo);
                    }
                });
    }

    public void demoBasicMessageChannel4() {
        BasicMessageChannel<Object> messageChannel = new BasicMessageChannel<Object>(
                getFlutterView(), StandardMessageCodecChannel, StandardMessageCodec.INSTANCE);

        messageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<Object>() {
                    @Override
                    public void onMessage(Object message, BasicMessageChannel.Reply<Object> reply) {
                        List<Integer> list = (List<Integer>) message;
                        for (int i=0 ;i<list.size(); i++) {
                            list.set(i, list.get(i) * 10);
                        }
                        reply.reply(list);
                    }
                });
    }

    String getDeviceInfoString(String type) {
        if (type.equals("MODEL")) {
            return Build.MODEL;
        }

        return null;
    }

    JSONObject getDeviceInfo(String type) {
        JSONObject json = new JSONObject();
        if (type.equals("MODEL")) {
            try {
                json.put("result", Build.MODEL);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return json;
        }

        return null;
    }

    ////////////////////////////////

    Handler handler = new Handler(Looper.getMainLooper());

    public void demoEventChannel() {
        new EventChannel(getFlutterView(), StreamChannel).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, final EventChannel.EventSink events) {
                        handler.postDelayed(buildCallBack(events), 1000);
                    }

                    @Override
                    public void onCancel(Object args) {
                    }
                }
        );
    }

    int i = 0;
    Runnable callback;

    Runnable buildCallBack(EventChannel.EventSink events) {
        if (callback == null) {
            callback =  new Runnable() {
                @Override
                public void run() {
                    events.success(String.valueOf(i++));
                    handler.postDelayed(callback, 1000);
                }
            };
        }
        return callback;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        handler.removeCallbacks(callback);
        Log.i("Native", "onDestroy");
    }
}
