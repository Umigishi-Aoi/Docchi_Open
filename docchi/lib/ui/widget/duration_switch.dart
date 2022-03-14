import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../res/colors.dart';
import '../../state/duration_provider.dart';

class DurationSwitch extends ConsumerWidget {
  const DurationSwitch({Key? key}) : super(key: key);

  static const _minimumDuration = 10;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Switch(
      value: _durationFlag(ref.watch(durationProvider)),
      onChanged: (value) {
        if(value){
          ref.read(durationProvider.state).state = _minimumDuration;
        }else{
          ref.read(durationProvider.state).state = maxDuration;
        }
      },
      activeColor: switchActive,
      inactiveThumbColor: accentColor,
      inactiveTrackColor: accentColorVariant,
    );
  }

  bool _durationFlag(int duration){
    bool _flag;
    if(duration == _minimumDuration){
      _flag = true;
    }else{
      _flag = false;
    }
    return _flag;
  }
}
