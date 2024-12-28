import 'package:arab_socials/src/widgets/custonbuttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Eventscreen extends StatelessWidget {
  const Eventscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Arrow
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.green, 
                ),
                onPressed: () {
                  Get.back(); 
                },
              ),
             Spacer(),
                    
              // Custom containers in a horizontal row
              Row(
                children: const [
                  CustomContainer(
                    text: "Saved",
                    icon: Icons.bookmark,
                  ),
                  CustomContainer(
                    text: "Location",
                    icon: Icons.location_on,
                  ),
                  CustomContainer(
                    text: "Date",
                    icon: Icons.date_range,
                  ),
                  CustomContainer(
                    text: "Type",
                    icon: Icons.filter_alt,
                  ),
                ],
              ),
            ],
          ),
           const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
             child: Row(
                  children: [
                    Custombutton(
                      text: "Sports",
                      icon: Icons.bookmark,
                      color: Color.fromARGB(255, 240, 99, 90),
                    ),
                    Custombutton(
                      text: "Music",
                      icon: Icons.location_on,
                      color: Color.fromARGB(255, 245, 151, 98),
                    ),
                    Custombutton(
                      text: "Food",
                      icon: Icons.date_range,
                      color: Color.fromARGB(255, 41, 214, 151),
                    ),
                    Custombutton(
                      text: "Drawing",
                      icon: Icons.filter_alt,
                      color: Color.fromARGB(255, 70, 205, 251),
                    ),
                  ],
                ),
           ),
        ],
      ),
    );
  }
}
