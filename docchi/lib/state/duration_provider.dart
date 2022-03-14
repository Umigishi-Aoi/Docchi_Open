import 'package:flutter_riverpod/flutter_riverpod.dart';

const maxDuration = 1000;

final durationProvider = StateProvider((ref) => maxDuration);