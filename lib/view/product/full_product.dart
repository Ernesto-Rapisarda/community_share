import 'dart:ui';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/enum/product_availability.dart';
import 'package:community_share/model/enum/product_category.dart';
import 'package:community_share/model/enum/product_condition.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/navigation/app_router.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/service/user_service.dart';
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
  final UserService userService = UserService();
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
        context,
        context.read<ProductProvider>().getProductBasic(),
        message,
        'Info about ${productBasic.title}',
        false);
    if (sended) {
      //todo
      print('todo');
      //showSnackBar(context, 'Message sended!');
    } else {
      //todo
      print('todo');
      //showSnackBar(context, 'Something goes wrong, message not sended');
    }
  }

  void viewGiverPublicProfile() async {
    try {
      UserDetails userDetails = await userService.getUserByIdDoc(
          context.read<ProductProvider>().productVisualized.giver.id);

      String currentRoute =
          AppRouter().router.routerDelegate.currentConfiguration.uri.toString();
      String destinationRoute =
          '$currentRoute/profile/public/${userDetails.id}';
      goToTheGiverPage(userDetails, destinationRoute);
    } catch (error) {
      callError(error.toString());
    }
  }

  void goToTheGiverPage(UserDetails userDetails, String route) {
    context.go(route, extra: userDetails);
  }

  void closeMessageComposer() {
    setState(() {
      _isAsking = false;
    });
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
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
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context
                                        .read<ProductProvider>()
                                        .productVisualized
                                        .title
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ))),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.black87,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
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
                                        context
                                            .read<ProductProvider>()
                                            .productVisualized,
                                        false);
                                  }
                                },
                                child: context
                                        .watch<UserProvider>()
                                        .productLiked
                                        .contains(context
                                            .read<ProductProvider>()
                                            .productVisualized)
                                    ? FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 22,
                                        color: Colors.red,
                                      )
                                    : FaIcon(
                                        FontAwesomeIcons.heart,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.share,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Auth().currentUser?.uid ==
                                    context
                                        .read<ProductProvider>()
                                        .productVisualized
                                        .giver
                                        .id
                                ? InkWell(
                                    onTap: () {
                                      context.go(
                                          '/product/details/${context.read<ProductProvider>().productVisualized.id}/edit');
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.pen,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }

  scrollableSpace() {
    String publishedOn = context
        .watch<ProductProvider>()
        .productVisualized
        .publishedOn
        .map((community) => community.name)
        .join(', ');
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Theme.of(context).colorScheme.secondaryContainer,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Descrizione',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  Text(
                    context
                        .watch<ProductProvider>()
                        .productVisualized
                        .description,
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  Row(
                    children: [
                      Text('Categoria: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(
                        productCategoryToString(
                            context
                                .watch<ProductProvider>()
                                .productVisualized
                                .productCategory,
                            context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Condizioni: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(productConditionToString(context
                          .watch<ProductProvider>()
                          .productVisualized
                          .condition, context)

                            ,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Disponibilità: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(productAvailabilityToString(context
                          .watch<ProductProvider>()
                          .productVisualized
                          .availability, context)

                            ,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Pubblicato su: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        publishedOn,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: Theme.of(context).dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Donatore ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    viewGiverPublicProfile();
                                  },
                                  child: Row(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    ],
                                  ),
                                )
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
                                child: Text('Chiedi info')),
                          ],
                        ),
                        !_isAsking
                            ? Center()
                            : MessageComposer(
                                messageController: _messageController,
                                onSendPressed: sendMessage,
                                onClose: closeMessageComposer,
                              ),
/*                SizedBox(
                    height: 200,
                  )*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
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
                  'Ricevi in dono',
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
        ],
      ),
    );
  }
}
