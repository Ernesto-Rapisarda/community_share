import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/service/product_service.dart';
import 'package:flutter/material.dart';

import '../model/enum/product_availability.dart';
import '../model/enum/product_condition.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  late Product _productVisualized;
  late List<UserDetailsBasic> _productLiked;
  final ProductService _productService = ProductService();

  ProductProvider(){
    _productLiked = [];
  }

  Product get productVisualized => _productVisualized;
  List<UserDetailsBasic> get productLiked => _productLiked;

  void updateProductVisualized({
    String? title,
    String? description,
    String? urlImages,
    String? locationProduct,
    ProductCondition? condition,
    ProductAvailability? availability,
  }){
    if(title != null && _productVisualized.title != title){
      _productVisualized.title = title;
    }

    if (description != null && _productVisualized.description != description) {
      _productVisualized.description = description;
    }

    if (urlImages != null && _productVisualized.urlImages != urlImages) {
      _productVisualized.urlImages = urlImages;
    }

    if (locationProduct != null && _productVisualized.locationProduct != locationProduct) {
      _productVisualized.locationProduct = locationProduct;
    }

    if (condition != null && _productVisualized.condition != condition) {
      _productVisualized.condition = condition;
    }

    if (availability != null && _productVisualized.availability != availability) {
      _productVisualized.availability = availability;
    }
    notifyListeners();

  }

  void setProductVisualized(BuildContext context, Product product) async{
    _productVisualized = product;
    _productLiked = await _productService.getProductLikes(context,product.id);
    notifyListeners();
  }


  void setOrRemoveLikes(BuildContext context,bool adding, UserDetailsBasic tmp){
    if(adding){
      _productVisualized.likesNumber = _productVisualized.likesNumber + 1;
      _productLiked.add(tmp);
    }
    else{
      _productVisualized.likesNumber = _productVisualized.likesNumber - 1;
      _productLiked.removeWhere((user)=> user.id == tmp.id);
    }
    notifyListeners();
  }
}