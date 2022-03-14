import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_notifier.dart';

final firebaseNotifierProvider = ChangeNotifierProvider((ref) => FirebaseNotifier());