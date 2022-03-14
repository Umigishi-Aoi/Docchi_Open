import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'choice_page.dart';
import 'select_choice_page.dart';
import 'add_page.dart';
import 'edit_page.dart';
import 'setting_page.dart';
import '../../state/page_state_provider.dart';
import '../../model/page_name.dart';
import '../../model/choices_model.dart';

class NavigatorPages extends ConsumerWidget {
  const NavigatorPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    PageName _pageName = ref.watch(pageNameProvider);
    Choice? _choice = ref.watch(editChoicesProvider);

    return Navigator(
        pages: [
          if (_pageName == PageName.choice)
            const MaterialPage(
              child: ChoicePage(),
            ),
          if (_pageName == PageName.select
              && _choice == null)
            const MaterialPage(
              child: SelectChoicePage(),
            )
          else if(_pageName == PageName.select
              && _choice != null)
            MaterialPage(
              child: EditPage(choice: _choice,),
            ),
          if (_pageName == PageName.add)
            const MaterialPage(
              child: AddPage(),
            ),
          if(_pageName == PageName.setting)
            const MaterialPage(
              child: SettingPage(),
            ),
        ],
        onPopPage: (route, result) {
          return false;
        }
    );
  }
}
