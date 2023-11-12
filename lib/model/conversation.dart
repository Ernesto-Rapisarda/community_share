import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/user_details.dart';

import 'message.dart';

class Conversation {
  String id;
  ProductBasic productBasic;
  List<UserDetailsBasic> members;
  String subject;
  int indexOfLastSender;
  DateTime startDate;
  DateTime lastUpdate;
  int unreadMessage;
  List<Message> messages;
  bool order;

  Conversation(
      {required this.id,
      required this.productBasic,
      required this.members,
        required this.subject,
      required this.indexOfLastSender,
      required this.startDate,
      required this.lastUpdate,
      required this.unreadMessage,
      required this.messages,required this.order});

  toJson() {
    return {
      'id': id,
      'productBasic': productBasic.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
      'subject':subject,
      'indexOfLastSender': indexOfLastSender,
      'startDate': startDate,
      'lastUpdate': lastUpdate,
      'unreadMessage': unreadMessage,
      'messages': messages.map((e) => e.toJson()).toList(),
      'order':order
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      productBasic: ProductBasic.fromJson(json['productBasic'])  ,
      members: (json['members'] as List<dynamic>)
          .map((e) => UserDetailsBasic.fromJson(e))
          .toList(),
      subject: json['subject'],
      indexOfLastSender: json['indexOfLastSender'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      lastUpdate: (json['lastUpdate'] as Timestamp).toDate(),
      unreadMessage: json['unreadMessage'],
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e))
          .toList(),
      order: json['order']
    );

  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productBasic == other.productBasic &&
          members == other.members;

  @override
  int get hashCode => id.hashCode ^ productBasic.hashCode ^ members.hashCode;
}
