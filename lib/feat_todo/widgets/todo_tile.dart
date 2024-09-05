import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/core/common.dart';
import 'package:to_do_app/feat_todo/screens/update_task.dart';
import 'package:to_do_app/utils/app_imports.dart';

//Todo List tile with random bg color and for completed we are using grey
class TodoTile extends StatelessWidget {
  const TodoTile(
      {super.key,
      required this.task,
      required this.context,
      r,
      required this.index});

  final Todo task;
  final int index;
  final BuildContext context;

  // final bool isDone;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.52,
        children: [
          if (!task.isCompleted)
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTask(
                      todo: task,
                      isEditing: true,
                    ),
                  ),
                );
              },
              backgroundColor: AppColors.lightgrey,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.edit,
              label: locale.edit,
            ),
          SlidableAction(
            onPressed: (context) async {
              var data = await Common().deleteAlert(
                  locale.deleteTodo, locale.deleteMsg, task, context, false);
              if (data == true) {
                // Add your delete logic here
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: AppColors.whiteColor,
            icon: Icons.delete,
            label: locale.delete,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            color: task.isCompleted == false
                ? AppColors
                    .listTileColor[index % AppColors.listTileColor.length]
                    .withOpacity(0.1)
                : AppColors.lightgrey.withOpacity(0.1),
            border: Border(
                left: BorderSide(
                    color: task.isCompleted == false
                        ? AppColors.listTileColor[
                            index % AppColors.listTileColor.length]
                        : AppColors.borderColor,
                    width: 4)),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.05.sw,
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (!task.isCompleted) {
                    Common().completeAlert(
                        locale.updateTitle, locale.updateMsg, task, context);
                  }
                },
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(50)),
                    width: 30.w,
                    height: 30.h,
                    child: !task.isCompleted
                        ? Assets.icons.check.svg()
                        : Assets.icons.checked.svg(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(right: 0),
                  title: Opacity(
                    opacity: task.isCompleted ? 0.5 : 0.8,
                    child: Wrap(
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(AppStrings.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.3,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: AppColors.blackTextColor),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Opacity(
                    opacity: 0.5,
                    child: Text(
                      formatDate(task.createdDT),
                      style: GoogleFonts.getFont(AppStrings.fontName,
                          fontWeight: FontWeight.w400,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          fontSize: 14,
                          height: 1.4,
                          color: AppColors.blackTextColor),
                    ),
                  ),
                  trailing: task.isSynced
                      ? Assets.images.cloudSyncDone
                          .image(height: 24.h, width: 24.w)
                      : Assets.images.cloud.image(height: 24.h, width: 24.w),
                  onTap: () {
                    if (!task.isCompleted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdateTask(
                                    todo: task,
                                  )));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
