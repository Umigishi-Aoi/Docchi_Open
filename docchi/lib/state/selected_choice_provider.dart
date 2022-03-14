import '../model/page_name.dart';
import '../model/choices_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//選択する選択肢を管理するプロバイダー
final  selectedChoicesProvider = StateProvider((ref){
  Choice? choices;
  return choices;
});