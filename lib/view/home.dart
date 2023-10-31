import 'package:community_share/controllers/show_snack_bar.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';

import '../model/enum/product_condition.dart';
import '../model/product.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Product> _products =[];

  Future<void> fetchProducts() async{
    try {
      List<Product> products = await ProductService().getProducts(context);
      setState(() {
        _products = products;
      });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  void initState(){
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return ProductGrid(_products);
  }
}
