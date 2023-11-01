import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/product.dart';

class FullProduct extends StatefulWidget {
  final Product product;

  const FullProduct({super.key, required this.product});

  @override
  State<StatefulWidget> createState() => _FullProductState();
}

class _FullProductState extends State<FullProduct> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Stack(children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(widget.product.urlImages),
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
            //todo aggiungere gestione colore like
            InkWell(
              onTap: () {},
              child: FaIcon(
                FontAwesomeIcons.heart,
                size: 20,
                color: Colors.white,
              ),
            ),
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
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 20,
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
                  widget.product.locationProduct,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black12,
            ),
            Text(
              'Description',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.product.description,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 16),
            ),
            Divider(
              color: Colors.black12,
            ),
            Text(
              'Details: ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Text(
                    'Condition: ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.product.condition.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.product.availability.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('dd-MM-yyyy').format(widget.product.uploadDate),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black12,
            ),
            Text(
              'Giver ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
                        image:
                            NetworkImage(widget.product.giver.urlPhotoProfile),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.giver.fullName,
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
                            widget.product.giver.location,
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
