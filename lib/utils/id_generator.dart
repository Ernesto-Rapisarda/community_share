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
}