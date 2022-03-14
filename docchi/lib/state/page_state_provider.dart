import '../model/page_name.dart';
import '../model/choices_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Pageの名前を管理するプロバイダー
final StateProvider<PageName> pageNameProvider = StateProvider<PageName>((ref)=>PageName.choice);

//編集する選択肢を管理するプロバイダー

final  editChoicesProvider = StateProvider((ref){
  Choice? choices;
  return choices;
});