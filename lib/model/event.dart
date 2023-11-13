import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  DateTime eventDate;
  String title;
  String eventLocation;
  String description;

  Event(
      {this.id,
      required this.eventDate,
      required this.title,
      required this.eventLocation,
        required this.description
      });

  toJson() {
    return {

      'eventDate': eventDate,
      'title': title,
      'eventLocation': eventLocation,
      'description':description
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        eventDate: (json['eventDate'] as Timestamp).toDate(),
        title: json['title'],
        eventLocation: json['eventLocation'],
      description: json['description']
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
