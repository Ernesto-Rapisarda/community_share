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
  final double boxSize;

  ProductCard({Key? key, required this.boxSize, required this.product})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ProductService _productService = ProductService();
  bool _isProductLiked = false;

  @override
  Widget build(BuildContext context) {
    _isProductLiked =  context
        .watch<UserProvider>()
        .productLiked
        .contains(widget.product);
    double imageSize =
        widget.boxSize - 16; // Sottrai il padding dalla dimensione della card

    return SizedBox(
      width: widget.boxSize,
      child: InkWell(
        onTap: () {
          context
              .read<ProductProvider>()
              .setProductVisualized(context, widget.product);
          context
              .go('/product/details/${widget.product.id}' /*, extra: product*/);
        },
        child: Card(
          color: Theme.of(context).cardTheme.color,
          elevation: 3,
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: ClipRect(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // Puoi regolare il raggio del bordo se necessario
                    child: Image.network(
                      widget.product.urlImages,
                      width: imageSize, // Fissa la larghezza dell'immagine
                      height: imageSize, // Fissa l'altezza dell'immagine
                      fit: BoxFit
                          .cover, // Adatta l'immagine alla dimensione specificata senza distorsioni
                    ),
                  ),
                ),
              ),
              //SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.locationDot, size: 16),
                    SizedBox(
                      width: 6,
                    ),
                    Text(widget.product.locationProduct,
                        style: TextStyle(fontSize: 16)),
                    Expanded(
                        child: SizedBox(
                      width: double.infinity,
                    )),

                  ],
                ),
              ),
              Container(
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${widget.product.likesNumber} ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    InkWell(
                        onTap: () {
                          if (Auth().currentUser?.uid !=
                              widget.product.giver.id) {
                            _productService.setLike(context, widget.product,true);
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
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              /*Container(
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 8,),
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage(product.giver.urlPhotoProfile),
                      radius: 11,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      product.giver.fullName,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
