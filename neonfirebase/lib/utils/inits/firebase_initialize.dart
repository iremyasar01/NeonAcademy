import 'package:firebase_core/firebase_core.dart';
import 'package:neonfirebase/firebase_options.dart';
import 'package:neonfirebase/service/crashlytics_service.dart';
import 'package:neonfirebase/service/remote_config_service.dart';


class FirebaseInitialize {
  /// Tüm Firebase servislerini başlatır
  static Future<void> firebaseInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Remote Config başlat
    await RemoteConfigService.initRemoteConfig();

    // Crashlytics başlat
    CrashlyticsService.setupErrorHandlers();
    await CrashlyticsService.setUserAndEnvironment();
  }
}
