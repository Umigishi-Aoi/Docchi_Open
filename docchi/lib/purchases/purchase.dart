import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';

import 'firebase/firebase_notifier.dart';
import 'iap/iap_connection.dart';
import 'iap/iap_repo.dart';
import 'purchasable_product.dart';
import 'purchase_constants.dart';
import 'store_state.dart';

class HideAdsPurchase extends ChangeNotifier{
  bool hideAdFlag = false;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = IAPConnection.instance;
  StoreState storeState = StoreState.loading;
  List<PurchasableProduct> products = [];

  FirebaseNotifier firebaseNotifier;

  IAPRepo iapRepo;

  HideAdsPurchase(this.hideAdFlag,this.firebaseNotifier,this.iapRepo){
    final purchaseUpdated =
        iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone:_updateStreamOnDone,
      onError:_updateStreamOnError,
    );
    iapRepo.addListener(purchasesUpdate);
    loadPurchases();
  }

  @override
  void dispose() {
    iapRepo.removeListener(purchasesUpdate);

    if (Platform.isIOS) {
      var iosPlatformAddition =
      iapConnection.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    _subscription.cancel();
    super.dispose();
  }

  void purchasesUpdate() {
    var subscriptions = <PurchasableProduct>[];
    var upgrades = <PurchasableProduct>[];
    // Get a list of purchasable products for the subscription and upgrade.
    // This should be 1 per type.
    if (products.isNotEmpty) {
      subscriptions = products
          .where((element) => false)
          .toList();
      upgrades = products
          .where((element) => element.productDetails.id == storeKeyUpgrade)
          .toList();
    }


    // Set the Dash beautifier and show/hide purchased on
    // the purchases page.
    if (iapRepo.hasUpgrade != hideAdFlag) {
      hideAdFlag = iapRepo.hasUpgrade;
      upgrades.forEach((element) => _updateStatus(
          element,
          hideAdFlag
              ? ProductStatus.purchased
              : ProductStatus.purchasable));
      notifyListeners();

    }
  }

  void _updateStatus(PurchasableProduct product, ProductStatus status) {
    if (product.status != status) {
      product.status = status;
      notifyListeners();
    }
  }


  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }
    try{
      await firebaseNotifier.functions;
    }catch(e){
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    //トランザクションを終了するのに必要とのこと
    if (Platform.isIOS) {
      var iosPlatformAddition =
      iapConnection.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    const ids = <String>{
      storeKeyUpgrade,
    };

    final response =
    await iapConnection.queryProductDetails(ids);
    response.notFoundIDs.forEach((element) {
      print('Purchase $element not found');
    });
    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();

  }

  Future<void> buy(PurchasableProduct product) async {
    //Unhandled Exception: PlatformException(storekit_duplicate_product_object, There is a pending transaction for the same product identifier.
    //に対応

    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case storeKeyUpgrade:
        await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
        break;
      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
    var transactions = await SKPaymentQueueWrapper().transactions();
    transactions.forEach((skPaymentTransactionWrapper) {
      SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    });
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    //Handle purchase here
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async{
      //購入結果をチェック
      if(purchaseDetails.status == PurchaseStatus.pending){
        //購入がペンディングの時の処理を記載
        //今回はなし
        Fluttertoast.showToast(
          msg: "Confirming purchase.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }else{
        if(purchaseDetails.status == PurchaseStatus.error){
          Fluttertoast.showToast(
            msg: "An error has occurred.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
          );
          hideAdFlag = false;
          notifyListeners();
        }else if(purchaseDetails.status == PurchaseStatus.purchased){
          bool valid = await _verifyPurchase(purchaseDetails);
          if(valid){
            Fluttertoast.showToast(
              msg: "Complete!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
            //hideAdFlagのステータスをtrueに変更
            hideAdFlag = true;
            notifyListeners();
          }else{
            hideAdFlag = false;
            notifyListeners();
          }
        }
      }
      //購入完了を知らせる。
      if (purchaseDetails.pendingCompletePurchase) {
        await iapConnection.completePurchase(purchaseDetails);
      }

    });
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) async{
    if (purchaseDetails.status == PurchaseStatus.purchased) {

      //購入のバックエンドでの確認
      var validPurchase = await _verifyPurchase(purchaseDetails);
      //購入が確認できたら
      if(validPurchase) {
        switch (purchaseDetails.productID) {
          case storeKeyUpgrade:
            hideAdFlag = true;
            notifyListeners();
            break;
        }
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    var functions = await firebaseNotifier.functions;
    final callable = functions.httpsCallable('verifyPurchase');
    final results = await callable({
      'source':
      purchaseDetails.verificationData.source,
      'verificationData':
      purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.productID,
    });
    return results.data as bool;
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
  }

}

//トランザクションを終了するのに必要とのこと
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction,
      SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}