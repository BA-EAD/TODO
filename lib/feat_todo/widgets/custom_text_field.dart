import 'package:to_do_app/utils/app_imports.dart';

///CustomText Field with box decorations
class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.title,
      required this.validator,
      required this.hintText,
      this.readOnly,
      required this.textKey,
      this.minLines,
      this.focusEnabled,
      this.focusNode,
      this.textInputAction,
      this.onDone});

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onDone;
  final bool? readOnly;
  final int? minLines;
  final ValueKey textKey;
  final bool? focusEnabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0.4, 0, 0.4, 5),
            child: Text(
              title,
              style: GoogleFonts.getFont(AppStrings.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.blackTextColor),
            ),
          ),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            onTapOutside: (eve) {
              if (focusNode != null) {
                focusNode!.unfocus();
              }
            },
            key: textKey,
            validator: validator,
            readOnly: readOnly ?? false,
            maxLines: title == locale.description ? null : 1,
            minLines: minLines,
            style: GoogleFonts.getFont(
              AppStrings.fontName,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: AppColors.textColorLight,
            ),
            onFieldSubmitted: onDone,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(
                10,
              ),
              errorStyle: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.9,
                color: AppColors.salmonColor,
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppColors.textColorLight,
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
