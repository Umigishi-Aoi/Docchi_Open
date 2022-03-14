import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void showTakeoverDialog(BuildContext context){

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Center(
        child: Text(
          AppLocalizations.of(context)!.takeover,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      content: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.takeoverContents,
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        Center(
          child: Column(
            children: [
              //AndroidはAndroid,iOSはiOSの引き継ぎしか考慮しない。
              //そのため、プラットフォームで引き継ぎ文を変える
              if (Platform.isAndroid)
                Column(children: [
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async{

                      //引き継ぎ実行処理

                      //匿名ログインを実施
                      UserCredential userCredential =
                      await FirebaseAuth.instance.signInAnonymously();

                      // Trigger the Google Authentication flow.
                      final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();
                      // Obtain the auth details from the request.
                      final GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;
                      // Create a new credential.
                      final OAuthCredential googleCredential =
                      GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      //Googleアカウントとのリンク
                      try {
                        await userCredential.user!
                            .linkWithCredential(googleCredential);
                      } catch (error) {
                        Fluttertoast.showToast(
                          msg: "error has occurred.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                        );
                      }


                      Navigator.pop(context);
                      //成功した場合のトーストを表示
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.takeoverComplete,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ]),
              if (Platform.isIOS)
                Column(children: [
                  SignInWithAppleButton(
                    onPressed: () async{

                      //匿名ログインを実施
                      UserCredential userCredential =
                          await FirebaseAuth.instance.signInAnonymously();

                      final appleUser =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                      );

                      final appleCredential =
                      OAuthProvider('apple.com').credential(
                        idToken: appleUser.identityToken,
                        accessToken: appleUser.authorizationCode,
                      );

                      //Appleアカウントとのリンク
                      try {
                        await userCredential.user!
                            .linkWithCredential(appleCredential);
                      } catch (error) {
                        Fluttertoast.showToast(
                          msg: "error has occurred.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                        );
                      }

                      Navigator.pop(context);

                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.takeoverComplete,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ]),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.back),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}