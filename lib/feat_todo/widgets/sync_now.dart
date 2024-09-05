import 'package:to_do_app/core/common.dart';
import 'package:to_do_app/utils/app_imports.dart';

// Sync Now SyncNowBottomSheet
class SyncNowBottomSheet extends StatefulWidget {
  const SyncNowBottomSheet({
    super.key,
    required this.taskStoSync,
    required this.selectedFrequency,
  });

  final List<Todo> taskStoSync;
  final String selectedFrequency;

  @override
  State<SyncNowBottomSheet> createState() => _SyncNowBottomSheetState();
}

class _SyncNowBottomSheetState extends State<SyncNowBottomSheet> {
  String selectedFrequency = '6';
  late Box<String> box;
  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  openHiveBox() async {
    selectedFrequency = widget.selectedFrequency;
    await Hive.openBox<String>(AppStrings.frequencyBox);
    box = Hive.box<String>(AppStrings.frequencyBox);
  }

  @override
  Widget build(BuildContext context) {
    selectedFrequency = widget.selectedFrequency;
    var locale = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<TodoBloc>(context)
                    .add(SyncTodos(todos: widget.taskStoSync));
                Navigator.pop(context);
              },
              child: Text(
                locale.sync,
                style: GoogleFonts.getFont(AppStrings.fontName,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.4,
                    color: AppColors.blackTextColor),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: Text(
                    locale.syncMsg,
                    style: GoogleFonts.getFont(AppStrings.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.blackTextColor),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Common().customeBtn(
                    ontap: () {
                      BlocProvider.of<TodoBloc>(context)
                          .add(SyncTodos(todos: widget.taskStoSync));
                      Navigator.pop(context);
                    },
                    titleText: locale.syncNow),
                SizedBox(
                  height: 20.h,
                ),
                Common().customeBtn(
                  titleText: locale.cancel,
                  isborderButton: true,
                  ontap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
