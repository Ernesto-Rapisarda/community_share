import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  DateTime eventDate;
  String title;
  String eventLocation;

  Event(
      {this.id,
      required this.eventDate,
      required this.title,
      required this.eventLocation});

  toJson() {
    return {
      'eventDate': eventDate,
      'title': title,
      'eventLocation': eventLocation
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        eventDate: (json['eventDate'] as Timestamp).toDate(),
        title: json['title'],
        eventLocation: json['eventLocation']);
  }
}
