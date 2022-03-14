import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dialogs/disclaimer_dialog.dart';

import '../../res/colors.dart';
import '../../state/page_state_provider.dart';
import '../../model/page_name.dart';

import '../../purchases/ui/dialogs/hide_ads_dialog.dart';
import '../../purchases/ui/dialogs/restore_dialog.dart';
import '../../purchases/ui/dialogs/takeover_dialog.dart';
import '../../purchases/purchase_state.dart';
import '../widget/text_box.dart';
import '../widget/duration_switch.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const double _buttonHeightRatio = 0.05;
  static const double _buttonWidthRatio = 0.5;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    double _height = MediaQuery.of(context).size.height * _buttonHeightRatio;
    double _width = MediaQuery.of(context).size.width * _buttonWidthRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textWhite),
          onPressed: (){
            ref.read(pageNameProvider.state).state = PageName.choice;
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  marginLeft: MediaQuery.of(context).size.width * 0.1,
                  text: AppLocalizations.of(context)!.quickDecide,
                ),
                const DurationSwitch(),

                const SizedBox(),
              ],
            ),
            Column(
              children: [
                if (!ref.watch(hideAdsPurchaseProvider).hideAdFlag)
                  SizedBox(
                    height: _height,
                    width: _width,
                    child: ElevatedButton(
                      onPressed: () {
                        showHideAdsDialog(context);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.advertisementOFF),
                    ),
                  )
                else
                  SizedBox(
                    height: _height,
                    width: _width,
                    child: ElevatedButton(
                      onPressed: () {
                        showTakeoverDialog(context);
                      },
                      child: Text(AppLocalizations.of(context)!.takeover),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: _height,
              width: _width,
              child: ElevatedButton(
                onPressed: () {
                  showRestoreDialog(context);
                },
                child: Text(AppLocalizations.of(context)!.restore),
              ),
            ),
            SizedBox(
              height: _height,
              width: _width,
              child: ElevatedButton(
                onPressed: () {
                  showDisclaimerDialog(context);
                },
                child: Text(AppLocalizations.of(context)!.disclaimer),
              ),
            ),
            SizedBox(
              height: _height,
              width: _width,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(pageNameProvider.state).state = PageName.choice;
                },
                child: Text(AppLocalizations.of(context)!.back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
