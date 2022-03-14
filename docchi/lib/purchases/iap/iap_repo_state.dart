import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_state_provider.dart';
import 'iap_repo.dart';

final iapRepoProvider = ChangeNotifierProvider((ref) => IAPRepo(ref.read(firebaseNotifierProvider)));