import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/product_availability.dart';
import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/model/enum/product_condition.dart';
import 'package:community_share/model/user_details.dart';

import 'community.dart';

class Product {
  //le info basic
  String id;
  String title;
  String description;
  String urlImages;
  String locationProduct;
  String? docRef;

  //date
  DateTime uploadDate;
  DateTime lastUpdateDate;

  //enum descrittivi
  ProductCondition condition;
  ProductAvailability availability;
  ProductCategory productCategory;

  //altre info
  int likesNumber;
  UserDetailsBasic giver;

  List<CommunityBasic> publishedOn;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.urlImages,
    required this.locationProduct,
    required this.uploadDate,
    required this.lastUpdateDate,
    required this.condition,
    required this.availability,
    required this.giver,
    required this.productCategory,
    required this.publishedOn,
    this.likesNumber = 0,
  });

  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urlImages': urlImages,
      'locationProduct': locationProduct,
      'uploadDate': uploadDate,
      'lastUpdateDate': lastUpdateDate,
      'condition': condition.name,
      'availability': availability.name,
      'category': productCategory.name,
      'likesNumber': likesNumber,
      'giver': giver.toJson(),
      'publishedOn': publishedOn.map((community) => community.toJson()).toList(),

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
        productCategory: json['category'] !=null
            ? productCategoryFromString(json['category'])
            : ProductCategory.other,
        publishedOn: (json['publishedOn'] as List<dynamic>)
            .map((communityJson) => CommunityBasic.fromJson(communityJson))
            .toList(),
        likesNumber: json['likesNumber'],


        giver: UserDetailsBasic.fromJson(json['giver']),);
  }


  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, urlImages: $urlImages, locationProduct: $locationProduct, docRef: $docRef, uploadDate: $uploadDate, lastUpdateDate: $lastUpdateDate, condition: $condition, availability: $availability, productCategory: $productCategory, likesNumber: $likesNumber, giver: $giver, publishedOn: $publishedOn}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}