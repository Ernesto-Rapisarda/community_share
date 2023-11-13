import 'package:community_share/view/product/product_card.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

class ProductGrid extends StatefulWidget {
  late final List<Product> products;

  ProductGrid(this.products, {super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
/*    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 16) / 2;*/

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 16, mainAxisExtent: 250),
        itemCount: widget.products.length,
        itemBuilder: (_, index) {
          return ProductCard(product: widget.products[index]);
        }
        /*shrinkWrap: true,

      padding: EdgeInsets.all(8),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2/3),
      children: [for (Product product in widget.products) ProductCard(product: product,boxSize: boxSize, )],*/
        );
  }
}
