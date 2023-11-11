import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/order_status.dart';
import 'package:community_share/model/product.dart';

import 'basic/community_basic.dart';

class ProductOrder {
  String id;
  DateTime orderDate;
  Product product;
  UserDetailsBasic receiver;
  CommunityBasic hotSpot;
  OrderStatus orderStatus;

  ProductOrder(
      {required this.id,required this.orderDate, required this.product, required this.receiver, required this.hotSpot, required this.orderStatus});

  toJson() {
    return {
      'id': id,
      'orderDate': orderDate,
      'product': product.toJson(),
      'receiver': receiver.toJson(),
      'hotSpot': hotSpot.toJson(),
      'order_status': orderStatus.name
    };
  }

  factory ProductOrder.fromJson(Map<String, dynamic> json){

    return ProductOrder(id: json['id'],
        orderDate: (json['orderDate'] as Timestamp).toDate(),
        product: Product.fromJson(json['product']),
        receiver: UserDetailsBasic.fromJson(json['receiver']) ,
        hotSpot: CommunityBasic.fromJson(json['hotSpot']) ,
        orderStatus: orderStatusFromString(json['order_status']));
  }



  @override
  String toString() {
    return 'ProductOrder{id: $id, orderDate: $orderDate, product: $product, receiver: $receiver, hotSpot: $hotSpot, orderStatus: $orderStatus}';
  }
}