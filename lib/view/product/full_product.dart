import 'dart:ui';

import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:community_share/utils/show_snack_bar.dart';
import 'package:community_share/view/generic_components/message_composer.dart';
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
  ConversationService _conversationService = ConversationService();
  ProductService _productService = ProductService();
  TextEditingController _messageController = TextEditingController();
  bool _isAsking = false;

  void sendMessage() async {
    //todo controlli del caso
    ProductBasic productBasic =
        context.read<ProductProvider>().getProductBasic();
    UserDetailsBasic sender = context.read<UserProvider>().getUserBasic();
    UserDetailsBasic receiver =
        context.read<ProductProvider>().productVisualized.giver;
    Message message = Message(
        id: IdGenerator.generateUniqueMessageId(sender.id, receiver.id),
        sender: sender,
        receiver: receiver,
        text: _messageController.text,
        date: DateTime.now());

    bool sended = await _conversationService.createNewConversation(
        context, context.read<ProductProvider>().getProductBasic(), message, 'Info about ${productBasic.title}',false);
    if(sended){
      //todo
      print('todo');
      //showSnackBar(context, 'Message sended!');

    }
    else{
      //todo
      print('todo');
      //showSnackBar(context, 'Something goes wrong, message not sended');
    }
  }

  void closeMessageComposer() {
    setState(() {
      _isAsking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: double.infinity,
                color: Theme.of(context).colorScheme.background,
                child: Stack(children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(context
                        .read<ProductProvider>()
                        .productVisualized
                        .urlImages),
                  ),
                  topActionBar(context),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context
                                        .read<ProductProvider>()
                                        .productVisualized
                                        .title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            context.go(
                                                '/product/details/${context.read<ProductProvider>().productVisualized.id}/edit');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.pen,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ))),
                  //Positioned(top: 230, left: 0, right: 0, child: scrollableSpace()),
                  /*Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: _isAsking
                          ? Center()
                          : Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: FloatingActionButton(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  context.go(
                                      '/product/details/${context.read<ProductProvider>().productVisualized.id}/checkout');
                                },
                                child: Text(
                                  'Get as a GIFT',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                  )*/
                ]),
              ),
              scrollableSpace()
            ],
          ),
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
                    _productService.setLike(
                        context,
                        context.read<ProductProvider>().productVisualized,
                        false);
                  }
                },
                child: context.watch<UserProvider>().productLiked.contains(
                        context.read<ProductProvider>().productVisualized)
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
    return /*SingleChildScrollView(
        child: Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: */
        Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Row(
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
                            context.go(
                                '/product/details/${context.read<ProductProvider>().productVisualized.id}/edit');
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
            ),*/
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        Text('Availability: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
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
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go(
                      '/product/details/${context.read<ProductProvider>().productVisualized.id}/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 2, // Imposta a 0 per rimuovere l'ombra
                ),
                child: Text(
                  'Get as a GIFT',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          // Adatta l'immagine al cerchio
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
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isAsking = !_isAsking;
                          });
                        },
                        child: Text('Ask info')),
                  ],
                ),
                !_isAsking
                    ? Center()
                    : MessageComposer(
                        messageController: _messageController,
                        onSendPressed: sendMessage,
                        onClose: closeMessageComposer,
                      ),
                SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
