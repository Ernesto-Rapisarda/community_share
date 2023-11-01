import 'package:flutter/material.dart';

import '../model/enum/product_availability.dart';
import '../model/enum/product_condition.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  late Product _productVisualized;

  Product get productVisualized => _productVisualized;

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

  void setProductVisualized(Product product){
    _productVisualized = product;
    notifyListeners();
  }

  void setOrRemoveLikes(){
  }
}