import 'package:community_share/view/product/product_card.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

class ProductGrid extends StatelessWidget {
  late final List<Product> products;

  ProductGrid(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 16) / 2;


    return GridView(

      padding: EdgeInsets.all(8),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/3),
      children: [for (Product product in products) ProductCard(product: product,boxSize: boxSize, )],
    );
  }
}
