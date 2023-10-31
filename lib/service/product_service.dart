import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductService {
  final ProductRepository _productRepository = ProductRepository();

  void createProduct(BuildContext context, Product product) async {



    await _productRepository.createProduct(context,product);
  }

  Future<List<Product>> getProducts(BuildContext context) async {
    List<Product> products =[];
    products = await _productRepository.getProducts(context);
    return products;
  }

}

