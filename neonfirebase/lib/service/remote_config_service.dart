import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:neonfirebase/constants/remote_config_keys.dart';
class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initRemoteConfig() async{
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
  }

static  Future<void> _setConfigSettings () async{
   await _remoteConfig.setConfigSettings( RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1), 
       minimumFetchInterval: Duration.zero) //her istediğimde yeni datayı bana getirsin
      
    ); }
    //eğer verinin bir karşılığı yoksa firebasede default olarak gelsin diye.
     static Future<void> _setDefaults() async {
      await _remoteConfig.setDefaults({
        FirebaseRemoteConfigKeys.ISHIDDEN: false,
        FirebaseRemoteConfigKeys.TITLE : "Eurovision Song Contest",
        FirebaseRemoteConfigKeys.YEAR : 2022,

      });
   }
//mainde initialize yapıcalacak ama.
//uygulama içinde ihtiyaç duyulur diye.
   static Future<void> fetchAndActivate() async{
    bool updated = await _remoteConfig.fetchAndActivate();
    if(updated){
      debugPrint("remote config updated");}
      else {
     debugPrint("remote config did not updated");

      }
      //datalarımı fecth ile çekip active ediyo.
    }
    static bool get isImageHidden => _remoteConfig.getBool( FirebaseRemoteConfigKeys.ISHIDDEN); 
    static String get title => _remoteConfig.getString( FirebaseRemoteConfigKeys.TITLE);
    static int get year => _remoteConfig.getInt( FirebaseRemoteConfigKeys.YEAR); 
   }
