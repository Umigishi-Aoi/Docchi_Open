import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/choices_model.dart';
import '../../state/selected_choice_provider.dart';
import '../res/colors.dart';
import 'pages/navigator_pages.dart';
import '../repository/drift_repository.dart';
import '../state/database_repository_provider.dart';
import '../purchases/ui/widget/hidable_banner_ad.dart';

class Docchi extends StatelessWidget {
  const Docchi({Key? key,required this.driftRepository}) : super(key: key);

  final DriftRepository driftRepository;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _showIDFACheckFirstTime());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: _themeData,
      home: Builder(
        builder: (context) {
          return FutureBuilder(
              future: driftRepository.initData(context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ProviderScope(
                    overrides: [
                      selectedChoicesProvider.overrideWithValue(
                          StateController(Choice.preset1(context))),
                      databaseRepositoryProvider.overrideWithValue(driftRepository)
                    ],
                    child: Column(
                      children: const [
                        Expanded(child: NavigatorPages()),
                        SafeArea(
                          top: false,
                            child: HidableBannerAd()),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        }
      ),
    );
  }

  //初回起動を判定し、初回起動ならIDFA対応を行う
  void _showIDFACheckFirstTime() async {
    final preference = await SharedPreferences.getInstance();
    // 最初の起動ならチュートリアル表示
    if (preference.getBool('IDFACheckIsDone') != true) {
      if (Platform.isIOS) {
        showAppTrackingTransparency();
      }
      preference.setBool('IDFACheckIsDone', true);
    }
  }

  // App Tracking Transparency を表示する
  void showAppTrackingTransparency() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

}

final ThemeData _themeData = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: mainBlack,
    scaffoldBackgroundColor: background,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom().copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(buttonNormal))),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      contentPadding: EdgeInsets.all(8),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: accentColor,
        ),
      ),
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: accentColor
      ),
      filled: true,
      fillColor: textWhite,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      //ここを追加
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: buttonNormal,
      systemOverlayStyle: SystemUiOverlayStyle.light
      ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6!.copyWith(fontSize: 18.0),
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: mainBlack,
        bodyColor: mainBlack,
      );
}
