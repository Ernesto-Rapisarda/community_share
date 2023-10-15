import 'package:community_share/model/enum/product_condition.dart';

class Product{
  String id='';
  String title='';
  String description='';
  String uploadDate='';
  ProductCondition condition=ProductCondition.newWithTag;
  int likesNumber=0;
  String urlImage='';

  Product({
  required this.id,
  required this.title,
  required this.description,
  required this.uploadDate,
  required this.condition,
  required this.likesNumber,
  required this.urlImage});


//mancano user e productCat

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uploadDate': uploadDate,
      'condition': condition.toString(),
      'likesNumber': likesNumber,
      'urlImage': urlImage,
    };
  }

}