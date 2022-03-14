import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/choices_model.dart';
import '../../state/page_state_provider.dart';
import '../../res/colors.dart';
import '../../state/selected_choice_provider.dart';
import '../../state/database_repository_provider.dart';

class CustomListCard extends ConsumerWidget {
  const CustomListCard({Key? key, required this.choice, required this.flag})
      : super(key: key);

  final Choice choice;

  final bool flag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: key!,
      child: GestureDetector(
        child: Card(
          color: tileBackground,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(choice.title)),
                if (choice.check(ref.watch(selectedChoicesProvider)!) && flag)
                  const Icon(
                    Icons.check,
                    color: checkMark,
                  )
                else if (!flag)
                  Row(
                    children: const [
                      Icon(
                        Icons.navigate_next,
                      ),
                      SizedBox(width: 16,),
                      Icon(
                        Icons.drag_handle,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (flag) {
            ref.read(selectedChoicesProvider.state).state = choice;
          } else {
            ref.read(editChoicesProvider.state).state = choice;
          }
        },
      ),
      direction: choice.check(ref.watch(selectedChoicesProvider)!) || flag
          ? DismissDirection.none
          : DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (!choice.check(ref.watch(selectedChoicesProvider)!)) {
          await ref.read(databaseRepositoryProvider).deleteChoice(choice);
        }
      },
      background: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_forever,
          color: textWhite,
        ),
      ),
    );
  }
}
