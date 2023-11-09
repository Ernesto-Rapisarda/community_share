import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/product_availability.dart';

class ProductBasic {
  String id;
  String title;
  String urlImages;
  String? docRef;
  String docRefCompleteProduct;

  DateTime uploadDate;
  ProductAvailability availability;



  ProductBasic({
    required this.id,
    required this.title,
    required this.urlImages,
    required this.uploadDate,
    required this.availability,
    required this.docRefCompleteProduct
  });

  toJson() {
    return {
      'id': id,
      'title': title,
      'urlImages': urlImages,
      'uploadDate': uploadDate,
      'availability': availability.name,
      'doc_ref_complete_product': docRefCompleteProduct
    };
  }

  factory ProductBasic.fromJson(Map<String, dynamic> json){
    return ProductBasic(
      id: json['id'],
      title: json['title'],
      urlImages: json['urlImages'],
      uploadDate: (json['uploadDate'] as Timestamp).toDate(),
      availability: json['availability'] != null
          ? productAvailabilityFromString(json['availability'])
          : ProductAvailability.pending,
      docRefCompleteProduct: json['doc_ref_complete_product']);



  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductBasic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          urlImages == other.urlImages &&
          docRefCompleteProduct == other.docRefCompleteProduct &&
          uploadDate == other.uploadDate &&
          availability == other.availability;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      urlImages.hashCode ^
      docRefCompleteProduct.hashCode ^
      uploadDate.hashCode ^
      availability.hashCode;

  @override
  String toString() {
    return 'ProductBasic{id: $id, title: $title, urlImages: $urlImages, docRef: $docRef, docRefCompleteProduct: $docRefCompleteProduct, uploadDate: $uploadDate, availability: $availability}';
  }
}