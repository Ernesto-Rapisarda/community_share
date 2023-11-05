import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/reporitory/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductService {
  final ProductRepository _productRepository = ProductRepository();

  Future<String> createProduct(BuildContext context, Product product) async {
    return await _productRepository.createProduct(context,product);
  }

  Future<List<Product>> getProducts(BuildContext context) async {
    return await _productRepository.getProducts(context);
  }

  void setLike(BuildContext context) async{
    UserDetailsBasic tmp = context.read<UserProvider>().getUserBasic();
    bool adding = false;
    Product tmpProduct = context.read<ProductProvider>().productVisualized;

    if(!context.read<ProductProvider>().productLiked.contains(tmp)){
      adding = true;
      tmpProduct.likesNumber =tmpProduct.likesNumber + 1;
    }
    else{
      tmpProduct.likesNumber = tmpProduct.likesNumber -1;
    }
    await _productRepository.setLikes(context, tmpProduct, tmp,adding);
    context.read<ProductProvider>().setOrRemoveLikes(context, adding, tmp);

  }

  getProductLikes(BuildContext context,String? id) async{
    return await _productRepository.getProductLikes(context, id);
  }

  Future<void> updateProduct(BuildContext context, Product product) async{
    return await _productRepository.updateProduct(context, product);

  }

}

