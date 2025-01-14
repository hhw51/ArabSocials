import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberTile extends StatefulWidget {
  final String imagePath;
  final String name;
  final String profession;
  final String location;
  final bool isCircular;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const MemberTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.profession,
    required this.location,
    required this.isCircular,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  State<MemberTile> createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  bool isFavorite = false;
  final NavigationController navigationController = Get.put(NavigationController());

  /// Decide whether to load via network or asset
  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,   // fill the container
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 92.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // --- Image Container (circular or rounded) ---
            widget.isCircular
                ? ClipOval(
              child: SizedBox(
                height: 72.h,
                width: 72.w,
                child: _buildImage(widget.imagePath),
              ),
            )
                : Container(
              height: 72.h,
              width: 72.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildImage(widget.imagePath),
            ),

            // --- Name, Profession, Location ---
            SizedBox(
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
                        Text(
                          "Profession:",
                          style: TextStyle(color: Colors.black, fontSize: 10.sp),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            widget.profession,
                            style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Location:",
                          style: TextStyle(color: Colors.black, fontSize: 10.sp),
                        ),
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

            // --- Favorite icon + "View" button ---
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
                      widget.onFavoriteTap?.call();
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTap,
                    child: const Row(
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
