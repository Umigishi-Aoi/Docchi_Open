import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/buy_button.dart';
import '../../firebase/firebase_state.dart';
import '../../firebase/firebase_state_provider.dart';
import '../../purchase_state.dart';
import '../../store_state.dart';

void showHideAdsDialog(BuildContext context){

  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext _context) => AlertDialog(
      title: Center(
        child: Text(
          AppLocalizations.of(_context)!.advertisementOFF,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      content: Builder(
        builder: (__context) {
          return HideAdsWidget();

        },
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(_context);
                },
                child: Text(AppLocalizations.of(_context)!.back),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(child: BuyButton(text: AppLocalizations.of(_context)!.purchase,),),
          ],
        )
      ],
    ),
  );
}


class HideAdsWidget extends ConsumerWidget {
  const HideAdsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    var firebaseNotifier = ref.watch(firebaseNotifierProvider);
    if (firebaseNotifier.state == FirebaseState.loading) {
      return _PurchasesLoading();
    } else if (firebaseNotifier.state == FirebaseState.notAvailable) {
      return _PurchasesNotAvailable();
    }


    var upgrades = ref.watch(hideAdsPurchaseProvider);
    switch (upgrades.storeState){

      case StoreState.loading:
        return _PurchasesLoading();
      case StoreState.available:
        return _PurchasesContents();
      case StoreState.notAvailable:
        return _PurchasesNotAvailable();
    }
  }

}


class _PurchasesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.storeLoading);
  }
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.storeNotAvailable);
  }
}

class _PurchasesContents extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    if(ref.watch(hideAdsPurchaseProvider).products.isEmpty){
      return const Text("error");
    }
    String text;
    String price = ref.watch(hideAdsPurchaseProvider).products[0].price;
    text = AppLocalizations.of(context)!.adsOFFContents + price;
    return Text(text);
  }
}
