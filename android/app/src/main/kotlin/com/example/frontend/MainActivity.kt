package com.example.frontend

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}

// package com.example.frontend

// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// import android.content.Context
// import android.content.ContextWrapper
// import android.content.Intent
// import android.content.IntentFilter
// import android.os.BatteryManager
// import android.os.Build.VERSION
// import android.os.Build.VERSION_CODES

// public class MainActivity : FlutterActivity() {
//   private var sharedText : String? = null;
//   private var sharedImage: ByteArray? = null;
//   private var sharedImageUri: String? = null;
//   private val CHANNEL = "app.channel.shared.data";

//     override protected fun onCreate(savedInstanceState : android.os.Bundle?) {
//     super.onCreate(savedInstanceState);
//     val intent: Intent = getIntent();
//     val action = intent.action;
//     val type = intent.getType();

//     if (Intent.ACTION_SEND.equals(action) && type != null) {
//       if ("text/plain".equals(type)) {
//         handleSendText(intent);
//       } else{
//         handleSendImage(intent);
//       }
//     }
//   }


//   override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//     // GeneratedPluginRegistrant.registerWith(flutterEngine);
//     super.configureFlutterEngine(flutterEngine);

//     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
//       call, result -> 
//         if (call.method.contentEquals("getSharedText")) {
//           result.success(sharedText);
//           sharedImage = null;
//         }
      
//     }
//   }

//   fun handleSendText(intent: Intent) {
//     sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
//   }

//   fun handleSendImage(intent : Intent) {
//     val uri = intent.getClipData()?.getItemAt(0)?.getUri();
//     val inputStream = contentResolver.openInputStream(uri!!);
//     sharedImage = inputStream?.readBytes();
//   }
// }