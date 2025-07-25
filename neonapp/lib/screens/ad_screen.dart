import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neonapp/helpers/ad_helper.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(adUnitId: AdHelper.bannerAdUnitId,
    request: const AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (ad){
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint('Banner Ad failed to load: $error');
        ad.dispose();
      }
      )
    ).load();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Screen'),
      ),
      body: Stack(
        children: [ const Center(
        ),
        if(_bannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
             width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
     
        ],
      ),
    );
  }
}