import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/utils/app_imports.dart';

class Common {
  static final Common _instance = Common._internal();

  factory Common() => _instance;

  Common._internal();

  Widget cancelButton(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 11, 0),
        child: Opacity(
          opacity: 0.5,
          child: Text(
            locale.cancel,
            style: GoogleFonts.getFont(AppStrings.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.4,
                color: AppColors.blackTextColor),
          ),
        ),
      ),
    );
  }

  Widget customeBtn(
      {required VoidCallback ontap,
      required String titleText,
      double? width,
      bool isborderButton = false}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        // margin: const EdgeInsets.fromLTRB(0, 0, 11, 0),
        width: width ?? 0.4.sw,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: isborderButton == false ? AppColors.primaryColor : null,
            borderRadius: BorderRadius.circular(8),
            border: isborderButton == true
                ? Border.all(color: AppColors.primaryColor)
                : null),
        child: Text(
          titleText,
          style: GoogleFonts.getFont(AppStrings.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
              color: isborderButton == false
                  ? AppColors.whiteColor
                  : AppColors.primaryColor),
        ),
      ),
    );
  }

  //Delete Alert
  Future deleteAlert(String ttl, String msg, Todo todo, BuildContext context,
      bool isNavigate) {
    var locale = AppLocalizations.of(context)!;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              // width: 310.w,
              height: 220.h,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ttl,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: 0.2,
                        color: AppColors.blackTextColor),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.3,
                        letterSpacing: 0.1,
                        color: AppColors.blackTextColor),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Common().customeBtn(
                            width: 0.3.sw,
                            isborderButton: true,
                            titleText: locale.cancel,
                            ontap: () {
                              Navigator.pop(context, false);
                            }),
                        Common().customeBtn(
                            width: 0.3.sw,
                            titleText: locale.delete,
                            ontap: () {
                              BlocProvider.of<TodoBloc>(context)
                                  .add(DeleteTodo(todo: todo));
                              isNavigate
                                  ? Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomePage()),
                                      (Route<dynamic> route) => false)
                                  : Navigator.pop(context, true);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Complete Todo
  Future completeAlert(
      String ttl, String msg, Todo todo, BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              // width: 1.sw,
              height: 220.h,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ttl,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: 0.2,
                        color: AppColors.blackTextColor),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.3,
                        letterSpacing: 0.1,
                        color: AppColors.blackTextColor),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Common().customeBtn(
                            width: 0.3.sw,
                            isborderButton: true,
                            ontap: () {
                              Navigator.pop(context);
                            },
                            titleText: locale.cancel),
                        Common().customeBtn(
                            width: 0.3.sw,
                            ontap: () {
                              final todoUpdate = Todo(
                                  id: todo.id,
                                  title: todo.title,
                                  description: todo.description,
                                  createdDT: todo.createdDT,
                                  updatedDT: DateTime.now(),
                                  isCompleted: true,
                                  isSynced: false);
                              BlocProvider.of<TodoBloc>(context)
                                  .add(UpdateLocalTodo(todo: todoUpdate));
                              Navigator.pop(context);
                            },
                            titleText: locale.update),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///common app snackBar
  void showSnackBar(
      {required String data,
      Color? color,
      Duration? duration,
      required BuildContext context}) {
    if (data[data.length - 1] != ".") {
      data = "$data.";
    }
    final snackBar = SnackBar(
      duration: duration ?? const Duration(milliseconds: 4000),
      content: Text(
        data,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color ?? AppColors.blackTextColor,
      showCloseIcon: true,
      closeIconColor: color != null ? AppColors.whiteColor : Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else {
      return "default";
    }
  }
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));

  // Check if the date is today
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Today';
  }

  // Check if the date is yesterday
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Yesterday';
  }

  // If not today or yesterday, return the formatted date
  // return DateFormat('yyyy-MM-dd').format(date);
  return '${DateFormat.yMMMEd().format(date)} ${DateFormat('hh:mm a').format(date)}';
}
