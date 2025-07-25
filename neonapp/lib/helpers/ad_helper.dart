import 'dart:io';

import 'package:neonapp/constants/ad_constants.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'YOUR_ANDROID_BANNER_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return AdConstants.iosBannerUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return AdConstants.interstitialAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'YOUR_ANDROID_REWARDED_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return AdConstants.rewardedAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
