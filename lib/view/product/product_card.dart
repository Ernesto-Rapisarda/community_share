import 'package:community_share/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/enum/product_condition.dart';
import '../../model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double boxSize;

  ProductCard({Key? key, required this.boxSize, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize =
        boxSize - 16; // Sottrai il padding dalla dimensione della card

    return SizedBox(
      width: boxSize,
      child: InkWell(
        onTap: () {
          context
              .read<ProductProvider>()
              .setProductVisualized(context, product);
          context.go('/product/details/${product.id}' /*, extra: product*/);
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
                  product.title,
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
                padding: const EdgeInsets.only(left: 8.0,right: 8),
                child: ClipRect(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // Puoi regolare il raggio del bordo se necessario
                    child: Image.network(
                      product.urlImages,
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
                padding: const EdgeInsets.only(top: 8.0,left: 8,right: 8),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.locationDot, size: 16),
                    SizedBox(
                      width: 6,
                    ),
                    Text(product.locationProduct, style: TextStyle(fontSize: 16)),
                    Expanded(
                        child: SizedBox(
                      width: double.infinity,
                    )),
                    InkWell(
                      onTap: () {},
                      child: FaIcon(FontAwesomeIcons.heart,
                          size: 18, color: Theme.of(context).colorScheme.primary),
                    )
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
                    SizedBox(width: 8,),
                    Text('Details ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                    SizedBox(
                      width: 8,
                    ),
                    FaIcon(FontAwesomeIcons.arrowRight,size: 16,),
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
