import 'package:flutter/material.dart';
class InAppScreen extends StatefulWidget {
  final Function(bool) onPremiumPurchased;

  const InAppScreen({super.key, required this.onPremiumPurchased});

  @override
  State<InAppScreen> createState() => _InAppScreenState();
}

class _InAppScreenState extends State<InAppScreen> {
  bool _purchaseInProgress = false;

  Future<void> _handlePurchase() async {
    setState(() => _purchaseInProgress = true);
    
   
    await Future.delayed(const Duration(seconds: 2));
    
//simüle ediyor çünkü gerçek ödeme işlemini simülatörde yapamadım.
//gerçek cihazda developer hesabı artı StoreKit.
//adapty kütüphanesi apple develeloper hesabına key veriyo.
    final success = (DateTime.now().second % 2 == 0);
// Simulüle ediyor başarılı olup olmamasını rastgele vermek adına.
    if (!mounted) return;
    
    if (success) {
      widget.onPremiumPurchased(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Completed')),
      );
    } else {
      setState(() => _purchaseInProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your payment has not been made')),
      );
    }
  }

  Future<void> _restorePurchase() async {
    setState(() => _purchaseInProgress = true);
    await Future.delayed(const Duration(seconds: 2));
    
    // Kullanıcı daha önce satın aldıysa tekrar ödeme yapmadan geri getirme işlemi.
    //rastgele başarılı veya başarısız simüle ediyor.
    final restored = (DateTime.now().second % 3 != 0);
    
    if (!mounted) return;
    
    if (restored) {
      widget.onPremiumPurchased(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase Restored!')),
      );
    } else {
      setState(() => _purchaseInProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No purchases to restore')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adapty Premium')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Premium Membership',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('Per Month Price \$19.99',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            if (_purchaseInProgress)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _handlePurchase,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15)),
                child: const Text('BUY NOW', style: TextStyle(fontSize: 18))),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _restorePurchase,
              child: const Text('Restore Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
