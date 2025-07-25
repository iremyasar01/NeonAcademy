import 'dart:io';

import 'package:neonapp/constants/ad_constants.dart';

class AdHelper {
  static String get bannerAdUnitId {
  if(Platform.isAndroid) {
    return 'YOUR_ANDROID_BANNER_AD_UNIT_ID'; 
  } else if (Platform.isIOS) {
    return AdConstants.iosBannerUnitId; 
  } else {
    throw UnsupportedError('Unsupported platform');
  }
  }
} 