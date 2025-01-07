import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessTile extends StatefulWidget {
  final String imagePath;
  final String name;
  final String category;
  final String location;
  final bool isCircular;
  final VoidCallback? onTap; 
  
  const BusinessTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.location,
    required this.isCircular,
    this.onTap, 

  });

  @override
  State<BusinessTile> createState() => _BusinessTileState();
}

class _BusinessTileState extends State<BusinessTile> {
  bool isFavorite = false;

    final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 92.h,
        // width: 345.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.isCircular
                ? Container(
                    height: 72.h,
                    width: 72.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                  )
                : Container(
                    height: 72.h,
                    width: 72.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w)),
                    child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                  ),
            SizedBox(
              // height: 59.h,
              width: 176.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text("Category:",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            widget.category,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 8.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Location:",
                            style: TextStyle(
                                color: Colors.black, fontSize: 10.sp)),
                        SizedBox(width: 4.w),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 59.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? const Color.fromARGB(255, 35, 94, 77)
                          : const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                   InkWell(
                     onTap: widget.onTap,
                     child:  const Row(
                      children: [
                        Text(
                          "View",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color.fromARGB(255, 35, 94, 77),
                        ),
                      ],
                     ), 

                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
