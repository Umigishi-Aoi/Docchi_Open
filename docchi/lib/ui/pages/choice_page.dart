import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../res/colors.dart';
import '../../model/page_name.dart';
import '../../state/page_state_provider.dart';
import '../../state/selected_choice_provider.dart';
import '../../ad/interstitial_ad.dart';
import '../../state/duration_provider.dart';

import '../../purchases/purchase_state.dart';

class ChoicePage extends ConsumerStatefulWidget {
  const ChoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends ConsumerState<ChoicePage> {
  //BOXの大きさ割合を管理する変数
  late double _firstBoxHeightRatio;

  //choiseが実行されたか否かを判別するフラグ
  bool _choiceFlag = true;

  //Boxの大きさ割合の初期値
  static const double _initialRatio = 0.25;

  //Boxたちが入っているColumnの高さ割合を管理する変数
  static const double _boxesHeightRatio = 0.55;

  //Boxのマージン
  static const int _boxesMargin = 16;

  //ボックス間のスペースを管理する変数
  static const double _betweenBoxSpaseRatio = 0.05;

  static const double _buttonWidthRatio = 0.4;

  //アニメーションのリピート回数
  static const int _times = 2;

  //fontSizeの定数
  double fontSize = 24;

  @override
  void initState() {
    super.initState();
    _firstBoxHeightRatio = _initialRatio;
  }

  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: displayHeight * _boxesHeightRatio,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: ref.watch(durationProvider)),
                    height: min(displayHeight * _firstBoxHeightRatio,
                        displayWidth - _boxesMargin),
                    width: min(displayHeight * _firstBoxHeightRatio,
                        displayWidth - _boxesMargin),
                    decoration: BoxDecoration(
                      color: choice1background,
                      border: Border.all(
                        color: mainBlack,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      ref.watch(selectedChoicesProvider)!.choice1,
                      style: TextStyle(fontSize: fontSize),
                    )),
                  ),
                  SizedBox(
                    height: displayHeight * _betweenBoxSpaseRatio,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: ref.watch(durationProvider)),
                    height: min(
                        displayHeight *
                            (_boxesHeightRatio -
                                _firstBoxHeightRatio -
                                _betweenBoxSpaseRatio),
                        displayWidth - _boxesMargin),
                    width: min(
                        displayHeight *
                            (_boxesHeightRatio -
                                _firstBoxHeightRatio -
                                _betweenBoxSpaseRatio),
                        displayWidth - _boxesMargin),
                    decoration: BoxDecoration(
                      color: choice2background,
                      border: Border.all(
                        color: mainBlack,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ref.watch(selectedChoicesProvider)!.choice2,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (_choiceFlag)
                  SizedBox(
                    width: displayWidth * _buttonWidthRatio,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(!ref.watch(hideAdsPurchaseProvider).hideAdFlag) {
                          ref.read(adInterstitialProvider).createAd();
                        }
                        await _choice();
                        setState(() {
                          _choiceFlag = false;
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.start),
                    ),
                  )
                else
                  SizedBox(
                    width: displayWidth * _buttonWidthRatio,
                    child: ElevatedButton(
                      onPressed: () async {

                        if(!ref.watch(hideAdsPurchaseProvider).hideAdFlag) {
                          await ref.read(adInterstitialProvider).showAd();
                        }
                        await _resetChoice();
                        setState(() {
                          _choiceFlag = true;
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.reset),
                    ),
                  )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: displayWidth * _buttonWidthRatio,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(pageNameProvider.state).state = PageName.select;
                    },
                    child: Text(AppLocalizations.of(context)!.selectChoices),
                  ),
                ),
                SizedBox(
                  width: displayWidth * _buttonWidthRatio,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(pageNameProvider.state).state = PageName.setting;
                    },
                    child: Text(AppLocalizations.of(context)!.settings),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //共通部分のアニメーション
  Future<void> _choiceAnimation() async {
    for (int i = 0; i < _times; i++) {
      setState(() {
        _firstBoxHeightRatio = _boxesHeightRatio - _betweenBoxSpaseRatio - 0.1;
      });
      await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
      setState(() {
        _firstBoxHeightRatio = 0.1;
      });
      await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
    }
  }

  //選択1が選ばれた場合
  Future<void> _choice1() async {
    await _choiceAnimation();
    setState(() {
      _firstBoxHeightRatio = _boxesHeightRatio - _betweenBoxSpaseRatio;
    });
    await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
    setState(() {
      fontSize = 56;
    });
  }

  //選択2が選ばれた場合
  Future<void> _choice2() async {
    await _choiceAnimation();
    setState(() {
      _firstBoxHeightRatio = _boxesHeightRatio - _betweenBoxSpaseRatio - 0.1;
    });
    await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
    setState(() {
      _firstBoxHeightRatio = 0;
    });
    await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
    setState(() {
      fontSize = 56;
    });
  }

  //choice1,choice2をランダム実行する関数
  Future<void> _choice() async {
    Random rand = Random();
    int choice = rand.nextInt(2);

    if (choice == 0) {
      await _choice1();
    } else {
      await _choice2();
    }
  }

  //リセットする関数
  Future<void> _resetChoice() async {
    if (_firstBoxHeightRatio != _initialRatio) {
      setState(() {
        _firstBoxHeightRatio = _initialRatio;
        fontSize = 24;
      });
      await Future.delayed(Duration(milliseconds: ref.watch(durationProvider)));
    }
  }
}
