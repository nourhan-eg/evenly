import 'package:cloud_firestore/cloud_firestore.dart';

import 'event_category.dart';

class EventModel {
  String id;
  final String title;
  final String description;
  final DateTime date;
  final userId;
  final EventCategory category;
  bool isFavorite;

  EventModel({
    this.id = "",
    required this.title,
    required this.date,
    required this.category,
    required this.userId,
    this.description = "",
    this.isFavorite = false,
  });

  static EventModel fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      isFavorite: json['isFavorite'],
      date: _parseDate(json['date']),
      category: EventCategory.fromId(json['category']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isFavorite": isFavorite,
      "userId": userId,
      "date": date,
      "category": category.id.toString(),
    };
  }

  String get day => date.day.toString().padLeft(2, "0");

  String get month => _monthNames[date.month - 1];

  static const List<String> _monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
}
