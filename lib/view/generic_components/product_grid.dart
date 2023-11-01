import 'package:community_share/view/product/product_card.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

class ProductGrid extends StatelessWidget {
  late final List<Product> products;

  ProductGrid(this.products);

  @override
  Widget build(BuildContext context) {
    return GridView(

      padding: EdgeInsets.all(8),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/4),
      children: [for (Product product in products) ProductCard(product)],
    );
  }
}
