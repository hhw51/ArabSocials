import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutMepopUp extends StatelessWidget {
  final String title;
  final String hintText;
  final String initialText;
  final Function(String) onSave;

  const AboutMepopUp({
    Key? key,
    required this.title,
    required this.hintText,
    this.initialText = "",
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final TextEditingController aboutmeController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: Text(title),
      content: TextFormField(
        controller: aboutmeController,
        maxLines: 5, 
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 250, 244, 228),
                        ),
                      ),
                    ),
        ElevatedButton(
                      onPressed: (){
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 250, 244, 228),
                        ),
                      ),
                    ),
      ],
    );
  }
}
