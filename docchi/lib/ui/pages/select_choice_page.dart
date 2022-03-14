import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/choices_model.dart';
import '../../model/page_name.dart';
import '../../state/page_state_provider.dart';
import '../../res/colors.dart';
import '../../state/database_repository_provider.dart';
import '../../ui/widget/custom_list_card.dart';

class SelectChoicePage extends ConsumerStatefulWidget {
  const SelectChoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectChoicePage> createState() => _SelectChoicePageState();
}

class _SelectChoicePageState extends ConsumerState<SelectChoicePage> {
  bool editFlag = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectChoices),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textWhite),
          onPressed: () {
            ref.read(pageNameProvider.state).state = PageName.choice;
          },
        ),
        actions: [
          if (editFlag)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                ref.read(pageNameProvider.state).state = PageName.add;
              },
            ),
          if (editFlag)
            GestureDetector(
              onTap: () {
                setState(() {
                  editFlag = false;
                });
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(AppLocalizations.of(context)!.edit),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  editFlag = true;
                });
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(AppLocalizations.of(context)!.done),
                ),
              ),
            ),
        ],
      ),
      body: StreamBuilder<List<Choice>>(
        stream: ref.watch(databaseRepositoryProvider).watchAllChoices(),
        builder: (context, AsyncSnapshot<List<Choice>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final choices = snapshot.data ?? [];
            final reverseChoices = List.from(choices.reversed);
            if (editFlag) {
              return ListView.builder(
                itemCount: choices.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomListCard(
                    key: Key('${reverseChoices[index].id}'),
                    choice: reverseChoices[index],
                    flag: editFlag,
                  );
                },
              );
            } else {
              return ReorderableListView.builder(
                itemCount: choices.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomListCard(
                    key: Key('${reverseChoices[index].id}'),
                    choice: reverseChoices[index],
                    flag: editFlag,
                  );
                },
                onReorder: (int oldIndex, int newIndex) async {
                  Choice oldChoice = await ref
                      .read(databaseRepositoryProvider)
                      .findRecipeById(reverseChoices[oldIndex].id);
                  Choice tempChoice;

                  if (oldIndex < newIndex) {
                    newIndex -= 1;

                    for (int i = oldIndex; i < newIndex; i++) {
                      tempChoice = await ref
                          .read(databaseRepositoryProvider)
                          .findRecipeById(reverseChoices[i + 1].id);
                      await ref
                          .read(databaseRepositoryProvider)
                          .updateChoice(tempChoice, reverseChoices[i].id);
                    }
                  } else {
                    for (int i = oldIndex; i > newIndex; i--) {
                      tempChoice = await ref
                          .read(databaseRepositoryProvider)
                          .findRecipeById(reverseChoices[i - 1].id);
                      await ref
                          .read(databaseRepositoryProvider)
                          .updateChoice(tempChoice, reverseChoices[i].id);
                    }
                  }
                  await ref
                      .read(databaseRepositoryProvider)
                      .updateChoice(oldChoice, reverseChoices[newIndex].id);
                },
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
