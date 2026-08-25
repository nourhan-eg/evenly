import 'package:flutter/material.dart';

import '../utils/app_images.dart';

class EventCategory {
  final String id;
  final String nameKey;
  final IconData icon;
  final String imagePath;
  final String darkImagePath;

  const EventCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.imagePath,
    required this.darkImagePath,
  });

  String imageFor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkImagePath : imagePath;
  }

  static EventCategory fromId(String? id) {
    return categories.firstWhere((c) => c.id == id);
  }

  static EventCategory? tryFromId(String? id) {
    for (final c in filters) {
      if (c.id == id) return c;
    }
    return null;
  }

  static const EventCategory all = EventCategory(
    id: "all",
    nameKey: "All",
    icon: Icons.grid_view_rounded,
    imagePath: "",
    darkImagePath: "",
  );

  static const EventCategory sport = EventCategory(
    id: "sport",
    nameKey: "Sport",
    icon: Icons.directions_bike,
    imagePath: AppImagesWhiteMode.sport,
    darkImagePath: AppImagesDarkMode.sport,
  );

  static const EventCategory birthday = EventCategory(
    id: "birthday",
    nameKey: "Birthday",
    icon: Icons.cake_outlined,
    imagePath: AppImagesWhiteMode.birthday,
    darkImagePath: AppImagesDarkMode.birthday,
  );

  static const EventCategory meeting = EventCategory(
    id: "meeting",
    nameKey: "Meeting",
    icon: Icons.laptop_mac,
    imagePath: AppImagesWhiteMode.meeting,
    darkImagePath: AppImagesDarkMode.meeting,
  );

  static const EventCategory bookClub = EventCategory(
    id: "book_club",
    nameKey: "Book_Club",
    icon: Icons.menu_book,
    imagePath: AppImagesWhiteMode.bookClub,
    darkImagePath: AppImagesDarkMode.bookClub,
  );

  static const EventCategory exhibition = EventCategory(
    id: "exhibition",
    nameKey: "Exhibition",
    icon: Icons.color_lens_outlined,
    imagePath: AppImagesWhiteMode.exhibition,
    darkImagePath: AppImagesDarkMode.exhibition,
  );

  /// Categories an event can belong to.
  static const List<EventCategory> categories = [
    sport,
    birthday,
    meeting,
    bookClub,
    exhibition,
  ];

  /// Categories plus the "All" entry, used by the home tab filter bar.
  static const List<EventCategory> filters = [all, ...categories];
}