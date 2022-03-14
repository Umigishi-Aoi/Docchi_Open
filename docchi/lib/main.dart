import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'res/colors.dart';
import 'repository/drift_repository.dart';
import 'ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //初期化処理中CircularProgressIndicator を呼び出す
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: mainBlack,
            ),
          )),
    ),
  );

  //購入があるよ、を知らせるための処理
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

  DriftRepository driftRepository = DriftRepository();
  await driftRepository.init();

  MobileAds.instance.initialize();

  //回転を抑制する
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(ProviderScope(child: Docchi(driftRepository: driftRepository,)));
}