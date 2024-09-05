import 'package:provider/provider.dart';
import 'package:to_do_app/core/common.dart';
import 'package:to_do_app/core/services/work_manager_box.dart';
import 'package:to_do_app/feat_todo/widgets/sync_now.dart';
import 'package:to_do_app/models/language.dart';
import 'package:to_do_app/utils/app_imports.dart';

class SettingsScreen extends StatefulWidget {
  final List<Todo> notSyncedTodos;
  final List<Todo?> allTodos;
  const SettingsScreen(
      {super.key, required this.notSyncedTodos, required this.allTodos});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var selectedLocale = Localizations.localeOf(context).toString();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40.w,
            width: 40.w,
            child: Assets.icons.backIcon.svg(),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          locale.settings,
          style: GoogleFonts.getFont(
            AppStrings.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            height: 1.9,
            letterSpacing: 0.2,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              _buildSettingsOptionCard(
                context: context,
                title: locale.language,
                child: Row(
                  children: [
                    const Text('English'),
                    Switch(
                      activeColor: AppColors.primaryColor,
                      value: selectedLocale == 'ar',
                      onChanged: (bool isArabic) {
                        String newLocale = isArabic ? 'ar' : 'en';
                        Provider.of<LocaleModel>(context, listen: false)
                            .set(Locale(newLocale));
                      },
                    ),
                    const Text('عربي'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsOptionCard(
                context: context,
                title: locale.sync,
                child: _buildSyncIcon(context, locale),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // A reusable card with title and child content
  Widget _buildSettingsOptionCard(
      {required BuildContext context,
      required String title,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightgrey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.getFont(
              AppStrings.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              height: 1.9,
              letterSpacing: 0.2,
              color: AppColors.primaryColor,
            ),
          ),
          child,
        ],
      ),
    );
  }

  // Sync icon button within the settings card
  IconButton _buildSyncIcon(BuildContext context, AppLocalizations locale) {
    return IconButton(
      onPressed: () => _onSyncPressed(context, locale),
      icon: const Icon(
        Icons.sync,
        color: AppColors.primaryColor,
        size: 28,
      ),
    );
  }

  // Handles sync press logic
  void _onSyncPressed(BuildContext context, AppLocalizations locale) {
    final frequencyStr = WorkManagerBox.frequencyBox
            .get(AppStrings.frequencyBox, defaultValue: '6') ??
        '6';
    if (widget.notSyncedTodos.isNotEmpty) {
      _showSyncNowBottomSheet(context, frequencyStr);
    } else {
      final message =
          widget.allTodos.isEmpty ? locale.todosMsgNo : locale.todosMsg;
      Common().showSnackBar(data: message, context: context);
    }
  }

  // Displays the Sync Now bottom sheet
  void _showSyncNowBottomSheet(BuildContext context, String frequencyStr) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 310.h,
            child: SyncNowBottomSheet(
              taskStoSync: widget.notSyncedTodos,
              selectedFrequency: frequencyStr,
            ),
          ),
        );
      },
    );
  }
}
