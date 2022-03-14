
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase/firebase_state.dart';
import '../../firebase/firebase_state_provider.dart';
import '../../purchase_state.dart';
import '../../store_state.dart';

class BuyButton extends ConsumerWidget {
  const BuyButton({Key? key,required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var purchases = ref.watch(hideAdsPurchaseProvider);
    return ElevatedButton(
      onPressed: () async{

        if(purchases.storeState == StoreState.available ) {
          if (ref
              .watch(firebaseNotifierProvider)
              .state == FirebaseState.available
              && ref
                  .watch(firebaseNotifierProvider)
                  .loggedIn != true) {
            //firebaseへログイン
            await ref.read(firebaseNotifierProvider).login();
          }
          if (ref
              .watch(firebaseNotifierProvider)
              .loggedIn && purchases.products.isNotEmpty) {
            //購入処理の実行
            purchases.buy(purchases.products[0]);
            Navigator.pop(context);
          }
        }
      },
      child: Text(text),
    );
  }
}