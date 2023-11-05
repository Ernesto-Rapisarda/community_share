import 'dart:ui';

import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/product_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';

class FullProduct extends StatefulWidget {
  const FullProduct({super.key});

  @override
  State<StatefulWidget> createState() => _FullProductState();
}

class _FullProductState extends State<FullProduct> {
  ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          color: Theme.of(context).colorScheme.background,
          child: Stack(children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                  context.read<ProductProvider>().productVisualized.urlImages),
            ),
            topActionBar(context),
            Positioned(top: 230, left: 0, right: 0, child: scrollableSpace()),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
                    child: Text(
                      'Get as a GIFT',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  topActionBar(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
                child: SizedBox(
              width: double.infinity,
            )),
            InkWell(
                onTap: () {
                  if (Auth().currentUser?.uid !=
                      context
                          .read<ProductProvider>()
                          .productVisualized
                          .giver
                          .id) {
                    _productService.setLike(context);
                  }
                },
                child: context
                        .watch<ProductProvider>()
                        .productLiked
                        .contains(context.read<UserProvider>().getUserBasic())
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
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.share,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  scrollableSpace() {
    return SingleChildScrollView(
        child: Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.read<ProductProvider>().productVisualized.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Auth().currentUser?.uid ==
                        context
                            .read<ProductProvider>()
                            .productVisualized
                            .giver
                            .id
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: InkWell(
                          onTap: () {
                            context.go('/product/details/${context.read<ProductProvider>().productVisualized.id}/edit');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // Padding interno per il pulsante
                            child: FaIcon(
                              FontAwesomeIcons.pen,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      context
                          .read<ProductProvider>()
                          .productVisualized
                          .description,
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    Text(
                      'Details: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            context
                                .read<ProductProvider>()
                                .productVisualized
                                .locationProduct,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Text(
                            'Condition: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            context
                                .read<ProductProvider>()
                                .productVisualized
                                .condition
                                .name,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Text(
                            'Availability: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            context
                                .read<ProductProvider>()
                                .productVisualized
                                .availability
                                .name,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Text(
                            'Online from: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(context
                                .read<ProductProvider>()
                                .productVisualized
                                .uploadDate),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Giver ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover, // Adatta l'immagine al cerchio
                        image: NetworkImage(context
                            .read<ProductProvider>()
                            .productVisualized
                            .giver
                            .urlPhotoProfile),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context
                            .read<ProductProvider>()
                            .productVisualized
                            .giver
                            .fullName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            context
                                .read<ProductProvider>()
                                .productVisualized
                                .giver
                                .location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                  )),
                  OutlinedButton(onPressed: () {}, child: Text('Ask info')),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
