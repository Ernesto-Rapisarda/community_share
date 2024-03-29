import 'package:flutter/material.dart';

import '../service/auth.dart';

class IdGenerator {
  static String generateUniqueId() {
    DateTime now = DateTime.now();
    int milliseconds = now.millisecondsSinceEpoch;
    String userId = Auth().currentUser!.uid;
    String uniqueId = 'ID_$userId$milliseconds';
    return uniqueId;
  }

  static String generateUniqueCommunityId(){
    DateTime now = DateTime.now();
    int milliseconds = now.microsecondsSinceEpoch;
    String communityId = 'ID_Community$milliseconds';
    return communityId;
  }

  static String generateUniqueOrderId(String productId){
    DateTime now = DateTime.now();
    int milliseconds = now.microsecondsSinceEpoch;
    return '$productId$milliseconds';

  }

  static String generateUniqueConversationId(String userOne, String userTwo, String productId){
    return '$userOne$userTwo$productId';
  }

  static String generateUniqueMessageId(String userOne, String userTwo){
    DateTime now = DateTime.now();
    int milliseconds = now.microsecondsSinceEpoch;
    return '$userOne$userTwo$milliseconds';
  }
}