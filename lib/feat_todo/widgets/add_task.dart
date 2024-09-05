import 'package:to_do_app/core/common.dart';
import 'package:to_do_app/feat_todo/widgets/custom_text_field.dart';
import 'package:to_do_app/utils/app_imports.dart';

// Add Todo
class AddToDo extends StatelessWidget {
  AddToDo({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final localData = Localizations.localeOf(context);
    final textDirection =
        localData.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: textDirection,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: AppStrings.addTaskFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                        textKey: AppStrings.addTitleKey,
                        controller: titleController,
                        title: locale.title,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return value?.trim().isValidTitle(context);
                        },
                        hintText: locale.titleHintText),
                    CustomTextField(
                        textKey: AppStrings.addDescKey,
                        controller: descriptionController,
                        textInputAction: TextInputAction.done,
                        title: locale.description,
                        onDone: (value) {
                          bool isFieldValid = AppStrings
                              .addTaskFormKey.currentState!
                              .validate();

                          if (isFieldValid) {
                            final todo = Todo(
                                id: DateTime.now().toString(),
                                title: titleController.text,
                                description: descriptionController.text,
                                createdDT: DateTime.now(),
                                updatedDT: DateTime.now(),
                                isCompleted: false,
                                isSynced: false);
                            BlocProvider.of<TodoBloc>(context)
                                .add(AddLocalTodo(todo: todo));
                            Navigator.pop(context);
                          }
                          return null;
                        },
                        validator: (value) {
                          return value?.trim().isValidDesc(context);
                        },
                        hintText: locale.descriptionHintText),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0.9, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Common().customeBtn(
                        ontap: () {
                          bool isFieldValid = AppStrings
                              .addTaskFormKey.currentState!
                              .validate();
                          if (isFieldValid) {
                            final todo = Todo(
                                id: DateTime.now().toString(),
                                title: titleController.text,
                                description: descriptionController.text,
                                createdDT: DateTime.now(),
                                updatedDT: DateTime.now(),
                                isCompleted: false,
                                isSynced: false);
                            BlocProvider.of<TodoBloc>(context)
                                .add(AddLocalTodo(todo: todo));
                            Navigator.pop(context);
                          }
                        },
                        titleText: locale.create),
                    Common().customeBtn(
                        isborderButton: true,
                        ontap: () {
                          Navigator.pop(context);
                        },
                        titleText: locale.cancel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
