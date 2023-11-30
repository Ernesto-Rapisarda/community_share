import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/enum/product_condition.dart';
import '../../model/product.dart';
import '../../service/auth.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final String route;

  //final double boxSize;

  const ProductCard({super.key, required this.product,required this.route});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ProductService _productService = ProductService();
  bool _isProductLiked = false;

  @override
  Widget build(BuildContext context) {
    _isProductLiked =
        context.watch<UserProvider>().productLiked.contains(widget.product);

    return SizedBox(
      child: InkWell(
        onTap: () {
          context
              .read<ProductProvider>()
              .setProductVisualized(context, widget.product);
          context
              .go(widget.route);
        },
        child: Card(
          color: Theme.of(context).cardTheme.color,
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRect(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  child: Image.network(
                    widget.product.urlImages,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit
                        .cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.product.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 8,),
                  Expanded(child: Text(productCategoryToString(widget.product.productCategory, context),maxLines: 1,overflow: TextOverflow.ellipsis, )),
                  InkWell(
                      onTap: () {
                        //todo
/*                        if (Auth().currentUser?.uid !=
                            widget.product.giver.id) {
                          _productService.setLike(
                              context, widget.product, true);
                        }*/
                      },
                      child: FaIcon(
                        FontAwesomeIcons.shareNodes,
                        size: 20,
                        //color: Theme.of(context).cardColor.red,
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                      onTap: () {
                        if (Auth().currentUser?.uid !=
                            widget.product.giver.id) {
                          _productService.setLike(
                              context, widget.product, true);
                        }
                      },
                      child: _isProductLiked
                          ? FaIcon(
                              FontAwesomeIcons.solidHeart,
                              size: 20,
                              color: Colors.red,
                            )
                          : FaIcon(
                              FontAwesomeIcons.heart,
                              size: 20,
                              //color: Theme.of(context).cardColor.red,
                            )),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
