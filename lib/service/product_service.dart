import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/reporitory/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductService {
  final ProductRepository _productRepository = ProductRepository();

  Future<void> createProduct(BuildContext context, Product product) async {
    return await _productRepository.createProduct(context,product);
    //context.read<ProductProvider>().setProductVisualized(context, product);

    //product.docRef= docRef;

  }

  Future<List<Product>> getProducts(BuildContext context) async {
    return await _productRepository.getProducts(context);
  }

  void setLike(BuildContext context, Product product, bool calledFromCard) async{
    UserDetailsBasic tmp = context.read<UserProvider>().getUserBasic();
    bool adding = false;
    Product tmpProduct = product;

    if(!context.read<UserProvider>().productLiked.contains(product)){
      adding = true;
      tmpProduct.likesNumber =tmpProduct.likesNumber + 1;
    }
    else{
      tmpProduct.likesNumber = tmpProduct.likesNumber -1;
    }
    await _productRepository.setLikes(context, tmpProduct, tmp,adding);
    if(!calledFromCard){
      context.read<ProductProvider>().setOrRemoveLikes(context, adding, tmp);
      context.read<UserProvider>().setOrRemoveLikes(context, tmpProduct);
    }
    else{
      context.read<UserProvider>().setOrRemoveLikes(context, tmpProduct);
    }

  }

  getProductLikes(BuildContext context,String? id) async{
    return await _productRepository.getProductLikes(context, id);
  }

  Future<void> updateProduct(BuildContext context, Product product) async{
    return await _productRepository.updateProduct(context, product);

  }

  Future<bool> createOrder(BuildContext context,ProductOrder productOrder) async{
    return await _productRepository.createOrder(context,productOrder);
  }

}

