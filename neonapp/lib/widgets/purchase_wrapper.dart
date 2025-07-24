import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:neonapp/screens/in_app_screen.dart';
import 'package:neonapp/screens/main_screen.dart';

//in app purchase uygulama içi satın alma kütüphanesi.
class PurchaseWrapper extends StatefulWidget {
  const PurchaseWrapper({super.key});

  @override
  State<PurchaseWrapper> createState() => _PurchaseWrapperState();
}

class _PurchaseWrapperState extends State<PurchaseWrapper> {
  bool _isPremium = false;
  bool _isLoading = true;
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    _verifyPremiumStatus();
  }
//simülatörde gerçek ödeme işlemi yapamadığımız için, satın alma işlemini simüle ediyoruz.
  Future<void> _verifyPremiumStatus() async {
    final available = await _iap.isAvailable();
    if (!available) {
      setState(() => _isLoading = false);
      return;
    }

    final purchaseStream = _iap.purchaseStream;
    purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          setState(() => _isPremium = true);
        }
      }
    });

    // iOS için geçmiş satın alımları manuel olarak geri yükleme.
    //android'de bu adım gerekli değil.otomatik olarak geri yükleniyor.
    await _iap.restorePurchases();

    // kısa gecikmeyle loading spinner'ı kaldıralım
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _updatePremiumStatus(bool isPremium) {
    setState(() => _isPremium = isPremium);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isPremium
        ? const MainScreen()
        : InAppScreen(onPremiumPurchased: _updatePremiumStatus);
  }
}
