import 'package:docchi/ad/adaptive_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../purchase_state.dart';

class HidableBannerAd extends ConsumerWidget {
  const HidableBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if(!ref.watch(hideAdsPurchaseProvider).hideAdFlag)
        const AdaptiveBannerAd(),
      ],
    );
  }
}
