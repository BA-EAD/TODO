import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';

class ToggleButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final String firstLabel;
  final String secondLabel;
  final Color activeColor;
  final Color inactiveColor;
  final double width;

  const ToggleButton({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.firstLabel,
    required this.secondLabel,
    this.activeColor = AppColors.whiteColor,
    this.inactiveColor = AppColors.primaryColor,
    this.width = 0.32,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (size.width * width).w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: inactiveColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52.0.w,
                height: 28.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isActive ? activeColor : inactiveColor,
                ),
                child: Center(
                  child: Text(
                    firstLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                width: 52.0.w,
                height: 28.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isActive ? inactiveColor : activeColor,
                ),
                child: Center(
                  child: Text(
                    secondLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0.sp,
                      color: Colors.black,
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
}
