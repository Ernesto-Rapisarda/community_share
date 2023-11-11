import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/user_details_basic.dart';

class Message {
  String id;
  UserDetailsBasic sender;
  UserDetailsBasic receiver;
  String text;
  DateTime date;

  Message(
      {required this.id,
      required this.sender,
      required this.receiver,
      required this.text,
      required this.date});

  toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'text': text,
      'date': date
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        sender: UserDetailsBasic.fromJson(json['sender']),
        receiver: UserDetailsBasic.fromJson(json['receiver']),
        text: json['text'],
        date: (json['date'] as Timestamp).toDate());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sender == other.sender &&
          receiver == other.receiver &&
          text == other.text &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      text.hashCode ^
      date.hashCode;
}
