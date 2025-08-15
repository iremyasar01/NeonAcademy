import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neonfirebase/service/crashlytics_service.dart';
import 'package:neonfirebase/widgets/crash_button.dart';
import 'package:neonfirebase/widgets/crash_dialog.dart';
import 'package:neonfirebase/widgets/crashlytics_header.dart';
import 'package:neonfirebase/widgets/crashlytics_title_section.dart';
import 'package:neonfirebase/widgets/crashlytics_warning.dart';
import 'package:neonfirebase/widgets/mars_colony_exception.dart';


class CrashlyticsScreen extends StatefulWidget {
  const CrashlyticsScreen({super.key});

  @override
  State<CrashlyticsScreen> createState() => _CrashlyticsScreenState();
}

class _CrashlyticsScreenState extends State<CrashlyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCrashPending = false;

  @override
  void initState() {
    super.initState();
    // Animasyon kontrolcüsünü başlat
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Ölçek animasyonunu tanımla
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    // Animasyon kontrolcüsünü temizle
    _animationController.dispose();
    super.dispose();
  }

  /// Ölümcül olmayan hata kaydetme
  Future<void> _logNonFatalError() async {
    try {
      // Crashlytics'e log mesajı gönder
      await CrashlyticsService.log("Alex Mars'tan crashlytics test ediyor!");
      
      // Özelleştirilmiş hata kaydet
      await CrashlyticsService.recordError(
        error: 'Mars İletişim Hatası',
        stackTrace: StackTrace.current,
        reason: 'Dünya ve Mars arasında sinyal kaybı',
        fatal: false,
        information: [
          DiagnosticsProperty('colony', 'New Hope City'),
          DiagnosticsProperty('developer', 'Alex - Mars intern'),
          DiagnosticsProperty('year', '2300'),
        ],
      );

      // Başarı mesajı göster
      _showDialog('Ölümcül Olmayan Hata Kaydedildi!', 
          'Mars iletişim hatası için Firebase Crashlytics panosunu kontrol edin.',
          isError: false);
    } catch (e) {
      // Hata durumunda uyarı göster
      _showDialog('Hata', 'Hata kaydedilemedi: $e', isError: true);
    }
  }

  /// Uygulamayı bilerek çökertme
  void _triggerFatalCrash() {
    setState(() => _isCrashPending = true);
    _animationController.forward();

    // 3 saniye gecikmeli çökertme
    Future.delayed(const Duration(seconds: 3), () {
      CrashlyticsService.crash();
    });
  }

  /// Özel Mars istisnası fırlatma
  void _throwCustomException() {
    try {
      throw MarsColonyException(
        'Yeni Umut Şehrinde kritik sistem arızası!',
        errorCode: 'MARS_2300_FATAL',
        sector: 'Merkezi İşlem Birimi',
      );
    } catch (error, stackTrace) {
      // Hatayı Crashlytics'e kaydet
      CrashlyticsService.recordError(
        error: error,
        stackTrace: stackTrace,
        fatal: true,
        reason: "Alex'in Crashlytics Meydan Okuması",
      );
      rethrow;
    }
  }

  /// Bilgilendirme diyaloğu gösterme
  void _showDialog(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => CrashDialog(
        title: title,
        message: message,
        titleColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Mars Crashlytics Meydan Okuması'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0E0E), Color(0xFF8B4513), Color(0xFF1A0E0E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Başlık bölümü
                const CrashlyticsHeader(),
                const SizedBox(height: 20),
                
                // Başlık altı açıklama
                const CrashlyticsTitleSection(),
                const SizedBox(height: 20),
                
                // Butonlar bölümü
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ölümcül olmayan hata butonu
                        CrashButton(
                          title: '📊 Ölümcül Olmayan Hata',
                          subtitle: 'Güvenli test - çökme olmadan hata kaydeder',
                          color: Colors.orange,
                          onPressed: _logNonFatalError,
                          icon: Icons.warning,
                        ),
                        
                        // Çökertme butonu (animasyonlu)
                        AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: _isCrashPending ? _scaleAnimation.value : 1.0,
                            child: CrashButton(
                              title: '💥 ÖLÜMCÜL ÇÖKME',
                              subtitle: _isCrashPending 
                                  ? '3 saniye içinde çökme başlatılıyor...' 
                                  : 'Uygulamayı anında çökertir',
                              color: Colors.red,
                              onPressed: _isCrashPending ? null : _triggerFatalCrash,
                              icon: Icons.dangerous,
                              isPending: _isCrashPending,
                            ),
                          ),
                        ),
                        
                        // Özel istisna butonu
                        CrashButton(
                          title: '🔥 Özel İstisna',
                          subtitle: 'Mars\'a özgü hata fırlatır',
                          color: Colors.purple,
                          onPressed: _throwCustomException,
                          icon: Icons.error_outline,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Uyarı mesajı
                const CrashlyticsWarning(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}