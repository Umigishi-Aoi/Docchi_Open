import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../res/colors.dart';
import '../../state/page_state_provider.dart';
import '../../model/choices_model.dart';
import '../../state/database_repository_provider.dart';
import '../../state/selected_choice_provider.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({Key? key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  static const double okButtonWidthRatio = 0.8;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _choice1Controller = TextEditingController();
  final TextEditingController _choice2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.choice.title;
    _choice1Controller.text = widget.choice.choice1;
    _choice2Controller.text = widget.choice.choice2;
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editChoice),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textWhite),
          onPressed: () {
            ref.read(editChoicesProvider.state).state = null;
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: displayWidth * okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.title,
                ),
                controller: _titleController,
              ),
            ),
            SizedBox(
              width: displayWidth * okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.choice1,
                ),
                controller: _choice1Controller,
              ),
            ),
            SizedBox(
              width: displayWidth * okButtonWidthRatio,
              child: TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.choice2,
                ),
                controller: _choice2Controller,
              ),
            ),
            SizedBox(
              width: displayWidth * okButtonWidthRatio,
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () async {
                  Choice choice = Choice(
                      id: widget.choice.id,
                      title: _titleController.text,
                      choice1: _choice1Controller.text,
                      choice2: _choice2Controller.text);

                  await ref
                      .watch(databaseRepositoryProvider)
                      .updateChoice(choice, widget.choice.id!);

                  ref.read(selectedChoicesProvider.state).state = choice;
                  ref.read(editChoicesProvider.state).state = null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
