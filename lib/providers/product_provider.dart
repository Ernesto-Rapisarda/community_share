import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/service/product_service.dart';
import 'package:flutter/material.dart';

import '../model/enum/product_availability.dart';
import '../model/enum/product_category.dart';
import '../model/enum/product_condition.dart';
import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  Product _productVisualized = Product(
      id: '',
      title: '',
      description: '',
      urlImages: '',
      locationProduct: '',
      uploadDate: DateTime.now(),
      lastUpdateDate: DateTime.now(),
      condition: ProductCondition.unknown,
      availability: ProductAvailability.pending,
      productCategory: ProductCategory.other,
      likesNumber: 0,
      giver: UserDetailsBasic(id: '', fullName: '', location: '', urlPhotoProfile: ''),
      publishedOn: []
  );

  late List<UserDetailsBasic> _productLiked;
  final ProductService _productService = ProductService();

  ProductProvider() {
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
  }) {
    if (title != null && _productVisualized.title != title) {
      _productVisualized.title = title;
    }

    if (description != null && _productVisualized.description != description) {
      _productVisualized.description = description;
    }

    if (urlImages != null && _productVisualized.urlImages != urlImages) {
      _productVisualized.urlImages = urlImages;
    }

    if (locationProduct != null &&
        _productVisualized.locationProduct != locationProduct) {
      _productVisualized.locationProduct = locationProduct;
    }

    if (condition != null && _productVisualized.condition != condition) {
      _productVisualized.condition = condition;
    }

    if (availability != null &&
        _productVisualized.availability != availability) {
      _productVisualized.availability = availability;
    }
    notifyListeners();
  }

  void setProductVisualized(BuildContext context, Product product) async {
    _productVisualized = Product(id: product.id,
        title: product.title,
        description: product.description,
        urlImages: product.urlImages,
        locationProduct: product.locationProduct,
        uploadDate: product.uploadDate,
        lastUpdateDate: product.lastUpdateDate,
        condition: product.condition,
        availability: product.availability,
        giver: product.giver,
        productCategory: product.productCategory,
        publishedOn: product.publishedOn
    );
    _productVisualized.docRef = product.docRef;
    _productLiked =
    await _productService.getProductLikes(context, product.docRef);
    notifyListeners();
  }

  void setOrRemoveLikes(BuildContext context, bool adding,
      UserDetailsBasic tmp) {
    if (adding) {
      _productVisualized.likesNumber = _productVisualized.likesNumber + 1;
      _productLiked.add(tmp);
    } else {
      _productVisualized.likesNumber = _productVisualized.likesNumber - 1;
      _productLiked.removeWhere((user) => user.id == tmp.id);
    }
    notifyListeners();
  }

  ProductBasic getProductBasic() {
    return ProductBasic(
        id: _productVisualized.id,
        title: _productVisualized.title,
        urlImages: _productVisualized.urlImages,
        uploadDate: _productVisualized.uploadDate,
        availability: _productVisualized.availability,
        docRefCompleteProduct: _productVisualized.docRef!);
  }
}
