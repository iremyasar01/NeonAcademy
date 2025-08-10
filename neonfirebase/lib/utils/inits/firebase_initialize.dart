import 'package:firebase_core/firebase_core.dart';
import 'package:neonfirebase/firebase_options.dart';
import 'package:neonfirebase/service/remote_config_service.dart';


class FirebaseInitialize {
  static Future<void> firebaseInit() async {
    // Firebase başlatma
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Firebase servislerini başlat

    await RemoteConfigService.initRemoteConfig();
  }
}