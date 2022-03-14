import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase/firebase_state_provider.dart';
import 'iap/iap_repo_state.dart';
import 'purchase.dart';

final hideAdsPurchaseProvider =
ChangeNotifierProvider((ref) =>
    HideAdsPurchase(
        false,
        ref.read(firebaseNotifierProvider),
        ref.read(iapRepoProvider),
    ));
