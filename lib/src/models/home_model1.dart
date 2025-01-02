import 'package:flutter/material.dart';

class HomescreenModel {        /////////////////////FIRST MODEL HOMESCREEN//////////////////
  String? mainImage;
  String? title;
  String? image1;
  String? image2;
  String? image3;
  String? subtitle;
  String? day;
  String? month;
  IconData? locationIcon;
  String? locationText;
  bool isBookmarked; 

  HomescreenModel({
    this.mainImage,
    this.title,
    this.image1,
    this.image2,
    this.image3,
    this.subtitle,
    this.day,
    this.month,
    this.locationIcon,
    this.locationText,
    this.isBookmarked = false, 
  });
}

List<HomescreenModel> homescreenModelList = [
  HomescreenModel(
    title: "INTERNATIONAL BAND MUUSJX",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "10",
    month: "JUNE",
    locationIcon: Icons.location_on,
    subtitle: "+20 going",
    locationText: "36 Guild Street London, UK",
  ),
  HomescreenModel(
    title: "INTERNATIONAL BAND MUUHGAKA",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "10",
    month: "JUNE",
    locationIcon: Icons.location_on,
    subtitle: "+20 going",
    locationText: "36 Guild Street London, UK",
  ),
  HomescreenModel(
    title: "INTERNATIONAL BAND MUUUDHC",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "10",
    month: "JUNE",
    locationIcon: Icons.location_on,
    subtitle: "+20 going",
    locationText: "36 Guild Street London, UK",
  ),
];



///////////////////////SECOND MODEL HOMESCREEN//////////////////////

class Homescreenlogo {   
  String? logoimage;
  String? logoimage1;
   String? logoimage2;
    String? logoimage3;
  Homescreenlogo({
    this.logoimage, this.logoimage1,this.logoimage2,this.logoimage3
  });
}

List<Homescreenlogo> homescreenlogoList =[
   Homescreenlogo(
   logoimage:"assets/logo/logoimage.png", logoimage1: "assets/logo/logoimage1.png", logoimage2: "assets/logo/image2.png", logoimage3: "assets/logo/logoimage3.png"
  ),

   Homescreenlogo(
   logoimage:"assets/logo/logoimage.png", logoimage1: "assets/logo/logoimage1.png", logoimage2: "assets/logo/image2.png", logoimage3: "assets/logo/logoimage3.png"
  ),
];





//////////////////////////THIRD MODEL HOMESCREEN/////////////////////////////////

class Homescreenfotter {
  String? fotterimage;
  String? title;
  String? subtitle;

  Homescreenfotter({
    this.fotterimage,
    this.title,
    this.subtitle,
  });
}

List<Homescreenfotter> homescreenfotterList = List.generate( 20, 
  (index) => Homescreenfotter(
    fotterimage: "assets/logo/lastlist.png", 
    title: "ALEX LEE",
    subtitle: "Software Engineer",
  ),
);
