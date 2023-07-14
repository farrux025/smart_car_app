package uz.devops.smart_car_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class  MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        MapKitFactory.setLocale("lang=ru-RU") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("5e63fca8-a2f8-4df0-a859-b9d2fd9a0062") // Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
