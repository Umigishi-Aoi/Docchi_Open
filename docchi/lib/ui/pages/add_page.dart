import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../res/colors.dart';
import '../../state/page_state_provider.dart';
import '../../model/page_name.dart';
import '../../model/choices_model.dart';
import '../../state/database_repository_provider.dart';
import '../../state/selected_choice_provider.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage>{

  static const double okButtonWidthRatio = 0.8;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _choice1Controller = TextEditingController();
  final TextEditingController _choice2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addChoice),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textWhite),
          onPressed: (){
            ref.read(pageNameProvider.state).state = PageName.select;
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: displayWidth*okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.title
                ),
                controller: _titleController,
              ),
            ),
            SizedBox(
              width: displayWidth*okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.choice1
                ),
                controller: _choice1Controller,
              ),
            ),
            SizedBox(
              width: displayWidth*okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.choice2
                ),
                controller: _choice2Controller,
              ),
            ),
            SizedBox(
              width: displayWidth*okButtonWidthRatio,
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () async{
                  Choice choice = Choice(
                      title: _titleController.text,
                      choice1: _choice1Controller.text,
                      choice2: _choice2Controller.text);

                  int id = await ref.watch(databaseRepositoryProvider).insertChoice(choice);

                  ref.read(selectedChoicesProvider.state).state = choice;
                  ref.read(pageNameProvider.state).state = PageName.select;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _choice1Controller.dispose();
    _choice2Controller.dispose();
    super.dispose();
  }

}
