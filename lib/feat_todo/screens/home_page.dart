import 'package:lottie/lottie.dart';
import 'package:to_do_app/core/common.dart';
import 'package:to_do_app/feat_todo/screens/settings.dart';
import 'package:to_do_app/feat_todo/widgets/add_task.dart';
import 'package:to_do_app/feat_todo/widgets/todo_tile.dart';
import 'package:to_do_app/utils/app_imports.dart';

import '../../core/services/work_manager_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Todo> notSyncedTodos = [];
  List<Todo?> allTodos = [];
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    WorkManagerBox.setupBackgroundProcess();
    _loadTodos();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  // Load Todos
  void _loadTodos() {
    BlocProvider.of<TodoBloc>(context).add(LoadLocalTodos());
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final selectedLocale = Localizations.localeOf(context).toString();
    final todoBloc = BlocProvider.of<TodoBloc>(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(context, locale, selectedLocale),
      body: _buildTodoList(context, locale, todoBloc),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, AppLocalizations locale, String selectedLocale) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Align(
        alignment: Alignment.topLeft,
        child: Text(
          locale.todoTasks,
          style: GoogleFonts.getFont(
            AppStrings.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            height: 1.9,
            letterSpacing: 0.2,
            color: AppColors.blackTextColor,
          ),
        ),
      ),
      actions: [
        _buildLocaleSwitch(context, selectedLocale, locale),
        //_buildSyncIcon(context, locale),
      ],
    );
  }

  Widget _buildLocaleSwitch(
      BuildContext context, String selectedLocale, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                          notSyncedTodos: notSyncedTodos,
                          allTodos: allTodos,
                        )),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: AppColors.whiteColor,
            ),
          ),
          // _buildSyncIcon(context, locale),
        ],
      ),
    );
  }

  Widget _buildTodoList(
      BuildContext context, AppLocalizations locale, TodoBloc todoBloc) {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoOperationSuccess) {
          todoBloc.add(LoadLocalTodos());
          Common().showSnackBar(data: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is TodoLoading) {
          return Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/anim/loading.json',
                controller: _controller,
              ),
            ),
          );
        } else if (state is LocalTodosLoaded) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildLoadedTodos(context, locale, state.todos),
          );
        } else if (state is TodoOperationSuccess) {
          return Container();
        } else if (state is TodoOperationFailure) {
          return Center(child: Text(state.errorMessage));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadedTodos(
      BuildContext context, AppLocalizations locale, List<Todo?> allTodos) {
    allTodos.sort((a, b) => b!.createdDT.compareTo(a!.createdDT));
    final onGoingTodos = allTodos.where((todo) => !todo!.isCompleted).toList();
    final completedTodos = allTodos.where((todo) => todo!.isCompleted).toList();
    completedTodos.sort((a, b) => b!.updatedDT.compareTo(a!.updatedDT));
    notSyncedTodos =
        allTodos.where((todo) => !todo!.isSynced).cast<Todo>().toList();
    allTodos.sort((a, b) => a!.createdDT.compareTo(b!.createdDT));
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 40),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 4.h,
          ),
          Text(
            locale.appTitle,
            style: GoogleFonts.getFont(
              AppStrings.fontName,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              height: 1.9,
              letterSpacing: 0.2,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          _buildTodoSection(
            title: '${locale.ongoing} (${onGoingTodos.length})',
            todos: onGoingTodos,
            emptyMessage: locale.noOngoingTask,
            checkBoxIcon: Assets.images.check.image(),
          ),
          const SizedBox(height: 20),
          _buildTodoSection(
            title: '${locale.completed}  (${completedTodos.length})',
            todos: completedTodos,
            emptyMessage: locale.noCompletedTask,
            checkBoxIcon: Assets.images.checkedIcon.image(),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoSection({
    required String title,
    required List<Todo?> todos,
    required String emptyMessage,
    required Image checkBoxIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(
          height: 14.h,
        ),
        todos.isEmpty
            ? Center(child: _buildEmptyMessage(emptyMessage))
            : _buildTodoListView(todos, checkBoxIcon),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        AppStrings.fontName,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 2.1,
        letterSpacing: 0.2,
        color: AppColors.blackTextColor,
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Text(
      message,
      style: GoogleFonts.getFont(
        AppStrings.fontName,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 2.1,
        letterSpacing: 0.2,
        color: AppColors.blackTextColor,
      ),
    );
  }

  ListView _buildTodoListView(List<Todo?> todos, Image checkBoxIcon) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0.0),
      shrinkWrap: true,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        debugPrint('TODO: ${todo?.isCompleted}', wrapWidth: 1024);
        return TodoTile(
          task: todo!,
          context: context,
          index: index,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () => _navigateToAddTodoPage(context),
      child: const Icon(
        Icons.add,
        size: 36,
        color: AppColors.whiteColor,
      ),
    );
  }

  void _navigateToAddTodoPage(BuildContext context) async {
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(height: 450.h, child: AddToDo()));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
