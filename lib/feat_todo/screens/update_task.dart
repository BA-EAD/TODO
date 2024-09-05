import 'package:share_plus/share_plus.dart';
import 'package:to_do_app/feat_todo/widgets/custom_text_field.dart';
import 'package:to_do_app/utils/app_imports.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key, required this.todo, this.isEditing = false});

  final Todo todo;
  final bool isEditing;

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
                color: AppColors.whiteColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            height: 40.w,
            width: 40.w,
            child: Assets.icons.backIcon.svg(
              colorFilter: const ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.todo.title,
          style: GoogleFonts.getFont(
            AppStrings.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 1.9,
            letterSpacing: 0.2,
            color: AppColors.whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Share.share(
                  'Title: ${widget.todo.title}\nDescription: ${widget.todo.description}');
            },
            key: AppStrings.shareTodoKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  width: 30.w,
                  height: 30.h,
                  child: Assets.icons.shareIcon.svg(
                      colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  )),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: AppStrings.updateTaskFormKey,
                child: Column(
                  children: [
                    if (widget.isEditing)
                      CustomTextField(
                        controller: titleController,
                        title: locale.title,
                        textKey: AppStrings.updateTitleKey,
                        readOnly: !widget.isEditing,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value?.trim().isValidTitle(context),
                        hintText: widget.todo.title,
                      ),
                    CustomTextField(
                      controller: descriptionController,
                      title: locale.description,
                      textKey: AppStrings.updateDescKey,
                      textInputAction: TextInputAction.done,
                      readOnly: !widget.isEditing,
                      minLines: 1,
                      validator: (value) => value?.trim().isValidDesc(context),
                      hintText: widget.todo.description,
                      onDone: (value) => _updateTodo(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                child: ElevatedButton(
                  key: AppStrings.updateTodoKey,
                  onPressed: _updateTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(360.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    widget.isEditing ? locale.update : locale.markAsComplete,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _updateTodo() {
    final todo = Todo(
      id: widget.todo.id,
      title: widget.isEditing ? titleController.text : widget.todo.title,
      description: widget.isEditing
          ? descriptionController.text
          : widget.todo.description,
      createdDT: widget.todo.createdDT,
      updatedDT: DateTime.now(),
      isCompleted: widget.isEditing ? widget.todo.isCompleted : true,
      isSynced: false,
    );
    BlocProvider.of<TodoBloc>(context).add(UpdateLocalTodo(todo: todo));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (Route<dynamic> route) => false,
    );
    return null; // Return null as the placeholder
  }
}
