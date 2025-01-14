import 'package:flutter/material.dart';

class EventModel {
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
  EventModel({
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

List<EventModel> eventModelList = [
  EventModel(
    title: "International Band International Mu...",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "12",
    month: "JULY",
    locationIcon: Icons.location_on,
    subtitle: "+25 Going",
    locationText: "45 Park Lane, New York, USA",
  ),
  EventModel(
    title: "International Band International Mu...",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "20",
    month: "JUNE",
    locationIcon: Icons.location_on,
    subtitle: "+50 Going",
    locationText: "123 Main Street, Los Angeles, USA",
  ),
  EventModel(
    title: "International Band International Mu...",
    mainImage: "assets/logo/homegrid.png",
    image1: "assets/logo/image1.png",
    image2: "assets/logo/image2.png",
    image3: "assets/logo/image3.png",
    day: "5",
    month: "JUNE",
    locationIcon: Icons.location_on,
    subtitle: "+100 Going",
    locationText: "789 Beach Avenue, Miami, USA",
  ),
];
