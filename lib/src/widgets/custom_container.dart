import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLogoContainer extends StatelessWidget {
  final String imagePath;

  const CustomLogoContainer({required this.imagePath, Key? key}) : super(key: key);

  @override                    //////////////////////////////FEATURED BUSINESS LISTVIEW IN HOMESCREEN//////////////////////////
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          imagePath,
          height: 80.h,
          width: 80.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
             "assets/logo/member_group.png",
            height: 80.h,
            width: 80.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}