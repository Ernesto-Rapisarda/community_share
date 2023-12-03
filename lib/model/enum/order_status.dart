import 'package:flutter/cupertino.dart';

enum OrderStatus {
  pending,
  productDeliveredToHotSpot,
  completed
}

OrderStatus orderStatusFromString(String value) {
  switch (value) {
    case 'productDeliveredToHotSpot':
      return OrderStatus.productDeliveredToHotSpot;
    case 'completed':
      return OrderStatus.completed;
    default:
      return OrderStatus.pending;
  }
}

String orderStatusToString (OrderStatus orderStatus, BuildContext context){
  switch (orderStatus){
    case OrderStatus.productDeliveredToHotSpot:
      return 'disponibile per il ritiro';
    case OrderStatus.completed:
      return 'donazione completata';
    default:
      return 'in attesa';
  }
}