import 'package:gap/gap.dart';
import 'package:to_do_app/utils/app_imports.dart';
import 'package:to_do_app/widgets/primary_cta.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.only(
            top: 163.sp, bottom: 48.sp, left: 24.0.w, right: 24.0.w),
        child: Column(
          children: [
            Center(
              child: Assets.images.logo.image(height: 53.h, width: 53.w),
            ),
            Gap(6.0.h),
            Text(
              AppLocalizations.of(context)!.todoTasks,
              style: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 30.sp,
                height: 1.5,
                letterSpacing: 0.4,
                color: AppColors.whiteColor,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                height: 1.5,
                letterSpacing: 0.4,
                color: AppColors.whiteColor,
              ),
            ),
            Gap(80.0.h),
            Center(
              child: Assets.icons.toDoSpash
                  .svg(width: double.infinity, height: 260.0.h),
            ),
            const Spacer(),
            PrimaryCta(
              text: AppLocalizations.of(context)!.getStarted,
              textColor: AppColors.primaryColor,
              backgroundColor: AppColors.whiteColor,
              filled: true,
              fillWidth: true,
              borderRadius: BorderRadius.circular(4),
              onPressed: () => _navigateToHome(context),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}
