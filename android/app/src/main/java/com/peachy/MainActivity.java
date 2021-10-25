package com.peachy;

import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;

public class MainActivity extends FlutterActivity { 
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        getWindow().setStatusBarColor(Color.parseColor("#fff9eb"));
        // getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
    }
}
