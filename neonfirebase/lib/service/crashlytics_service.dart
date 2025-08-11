import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  // Hata yakalama mekanizmalarını kurar (initialize'den ayrı)
  static void setupErrorHandlers() {
    // Flutter framework hatalarını yakala
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Asenkron hataları yakala
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Kullanıcı ve ortam bilgilerini ayarlar
  //yani crash raporlarına hatanın hangi kullanıcıda ya da nerede olduğu bilgisini vermek için
  static Future<void> setUserAndEnvironment() async {
    await FirebaseCrashlytics.instance
        .setUserIdentifier('alex_mars_intern_2300');

    await FirebaseCrashlytics.instance.setCustomKey('colony', 'New Hope City');
    await FirebaseCrashlytics.instance.setCustomKey('planet', 'Mars');
    await FirebaseCrashlytics.instance.setCustomKey('year', '2300');
    await FirebaseCrashlytics.instance.setCustomKey('developer', 'Alex');
  }
  //mesela theme, dark eklenseydi hata sadece karanlık modda mı çalışıyor diye bakmak için.

  /// Manuel hata gönderme (test amaçlı)
  static Future<void> testCrash() async {
    FirebaseCrashlytics.instance.log("Test crash tetiklendi!");
    throw Exception("Crashlytics Test Crash 🚨");
  }

  /// Manuel log ekleme
  static Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }

  /// Hata raporuna ekstra key ekleme
  static Future<void> setCustomKey(String key, dynamic value) async {
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  /// Özelleştirilmiş hata kaydı
  /// Yani yakalanan bir hatayı manuel olarak crashlytics'e gönderir.
  static Future<void> recordError({
    required dynamic error,
    required StackTrace stackTrace,
    String? reason,
    bool fatal = false,
    List<Object> information = const [],
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
      information: information,
    );
  }

  /// Uygulamayı manuel olarak çökertir
  static void crash() {
    FirebaseCrashlytics.instance.crash();
  }
}