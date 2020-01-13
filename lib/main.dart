
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:malayalam_live_news_channels/view/splashscreen.dart';

void main() {
  Admob.initialize(getAppId());
  FirebaseAdMob.instance.initialize(appId: getAppId());
  runApp(MaterialApp(
    title: 'Malayalam Live TV#',
    home: SplashScreen(),
  ));
}

String getAppId() {
  return "ca-app-pub-9079381335168661~1285626978";
}
