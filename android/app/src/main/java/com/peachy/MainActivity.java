package com.peachy;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity { 

    private static final String CHANNEL = "yuv_transform";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        System.out.println("JAVA (yuv_transform) REGISTERED ");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "yuv_transform": {
                                    List<byte[]> bytesList = call.argument("platforms");
                                    int[] strides = call.argument("strides");
                                    int width = call.argument("width");
                                    int height = call.argument("height");

                                    try {
                                        byte[] data = YuvConverter.NV21toJPEG(YuvConverter.YUVtoNV21(bytesList, strides, width, height), width, height, 100);
                                        Bitmap bitmapRaw = BitmapFactory.decodeByteArray(data, 0, data.length);

                                        Matrix matrix = new Matrix();
                                        matrix.postRotate(90);
                                        Bitmap finalbitmap = Bitmap.createBitmap(bitmapRaw, 0, 0, bitmapRaw.getWidth(), bitmapRaw.getHeight(), matrix, true);
                                        ByteArrayOutputStream outputStreamCompressed = new ByteArrayOutputStream();
                                        finalbitmap.compress(Bitmap.CompressFormat.JPEG, 60, outputStreamCompressed);

                                        result.success(outputStreamCompressed.toByteArray());
                                        outputStreamCompressed.close();
                                        data = null;
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                    break;
                                }
                            }
                        }
                );

    }
}
