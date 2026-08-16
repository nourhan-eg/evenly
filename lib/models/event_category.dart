import 'package:flutter/material.dart';

class EventCategory {
  final String id;
  final String nameKey;
  final IconData icon;
  final String imagePath;

  const EventCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.imagePath,
  });

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
    nameKey: "all",
    icon: Icons.grid_view,
    imagePath: "",
  );

  static const EventCategory sport = EventCategory(
    id: "sport",
    nameKey: "sport",
    icon: Icons.directions_bike,
    imagePath: "assets/images/Sport.png",
  );

  static const EventCategory birthday = EventCategory(
    id: "birthday",
    nameKey: "birthday",
    icon: Icons.cake_outlined,
    imagePath: "assets/images/Birthday.png",
  );

  static const EventCategory meeting = EventCategory(
    id: "meeting",
    nameKey: "meeting",
    icon: Icons.laptop_mac,
    imagePath: "assets/images/Meeting.png",
  );

  static const EventCategory bookClub = EventCategory(
    id: "book_club",
    nameKey: "book_club",
    icon: Icons.menu_book,
    imagePath: "assets/images/Book Club.png",
  );

  static const EventCategory exhibition = EventCategory(
    id: "exhibition",
    nameKey: "exhibition",
    icon: Icons.color_lens_outlined,
    imagePath: "assets/images/Exhibition.png",
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
