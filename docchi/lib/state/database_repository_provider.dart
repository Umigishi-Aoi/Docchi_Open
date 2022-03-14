import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/drift_repository.dart';

final databaseRepositoryProvider = Provider((ref) => DriftRepository());