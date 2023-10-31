import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/product_availability.dart';
import 'package:community_share/model/enum/product_condition.dart';
import 'package:community_share/model/user_details.dart';

class Product {
  //le info basic
  late final String? id;
  String title;
  String description;
  String urlImages;
  String locationProduct;

  //date
  DateTime uploadDate;
  DateTime lastUpdateDate;

  //enum descrittivi
  ProductCondition condition;
  ProductAvailability availability;

  //altre info
  int likesNumber;
  UserDetailsBasic giver;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.urlImages,
    required this.locationProduct,
    required this.uploadDate,
    required this.lastUpdateDate,
    required this.condition,
    required this.availability,
    required this.giver, // Utilizza solo l'ID dell'utente invece di un oggetto UserDetails
    this.likesNumber = 0,
  });

  toJson() {
    return {
      'title': title,
      'description': description,
      'urlImages': urlImages,
      'locationProduct': locationProduct,
      'uploadDate': uploadDate,
      'lastUpdateDate': lastUpdateDate,
      'condition': condition.name,
      'availability': availability.name,
      'likesNumber': likesNumber,
      'giver': giver.toJson(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        urlImages: json['urlImages'],
        locationProduct: json['locationProduct'],
        uploadDate: (json['uploadDate'] as Timestamp).toDate(),
        lastUpdateDate: (json['lastUpdateDate'] as Timestamp).toDate(),
        condition: json['condition'] != null
            ? productConditionFromString(json['condition'])
            : ProductCondition.unknown,
        availability: json['availability'] != null
            ? productAvailabilityFromString(json['availability'])
            : ProductAvailability.pending,

        giver: UserDetailsBasic.fromJson(json['giver']),);
  }


}