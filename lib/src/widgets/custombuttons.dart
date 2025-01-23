import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatefulWidget {
  final String text;
  final IconData? icon;
  final String? image;
  final VoidCallback? onTap;
  final bool isActive; // Add this parameter

  const CustomContainer({
    Key? key,
    required this.text,
    this.icon,
    this.image,
    this.onTap,
    this.isActive = false, // Default value
  }) : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.green[800] : Colors.green[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(
                widget.icon,
                color: widget.isActive ? Colors.white : Colors.green,
                size: 18,
              )
            else if (widget.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Image.asset(
                  widget.image!,
                  height: 16.h,
                  width: 16.w,
                  color: widget.isActive ? Colors.white : Colors.green,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 4),
            Text(
              widget.text,
              style: TextStyle(
                color: widget.isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


///////////////////////////////////EVENTSCREEN SPORTS, MUSIC OR.............BUTTON////////////////////////////

class Custombutton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final String? image;
  final Color color;

  const Custombutton({
    Key? key,
    required this.text,
    this.icon,
    this.image,
    required this.color,
  }) : super(key: key);

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null)
            Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            )
          else if (widget.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                widget.image!,
                height: 18,
                width: 18,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////IN PROFILESCREEN INTERESTS CONTAINER/////////////////////////////////

class CustomIntrestsContainer extends StatefulWidget {
  final String text;
  final Color color;

  const CustomIntrestsContainer({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  State<CustomIntrestsContainer> createState() =>
      _CustomIntrestsContainerState();
}

class _CustomIntrestsContainerState extends State<CustomIntrestsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

////////////////////////IN HOMESCREEN HEAD TEXT AND SEE ALL BUTTON//////////////////////////////////////

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText = "See all",
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplaySc(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 143, 146, 137),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16.sp,
                  color: const Color.fromARGB(255, 35, 94, 77),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum Interest {
  game('Game', Color.fromARGB(255, 240, 99, 90)),
  music('Music', Color.fromARGB(255, 245, 151, 98)),
  movies('Movies', Color.fromARGB(255, 41, 214, 151)),
  art('Art', Color.fromARGB(255, 70, 205, 251)),
  technology('Technology', Color.fromARGB(255, 240, 99, 90)),
  innovation('Innovation', Color.fromARGB(255, 245, 151, 98)),
  networking('Networking', Color.fromARGB(255, 41, 214, 151));

 static Interest fromApi({required String value}) {
    return switch (value) {
      'Game' => game,
      'Music' => music,
      'Movies' => movies,
      'Art' => art,
      'Technology' => technology,
      'Innovation' => innovation,
      'Networking' => networking,
      _ => game,
    };
  }

  final Color color;
  final String name;

  const Interest(this.name, this.color);
}
