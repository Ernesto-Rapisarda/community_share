import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/community.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';

class CheckoutProduct extends StatefulWidget {
  const CheckoutProduct({Key? key});

  @override
  State<CheckoutProduct> createState() => _CheckoutProductState();
}

class _CheckoutProductState extends State<CheckoutProduct> {
  CommunityBasic? selectedCommunity;
  late double maxWidth;

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width - 200.0;
    final _product = context.read<ProductProvider>().productVisualized;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  children: [
                    Text(
                      'Summary product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            _product.urlImages,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Title: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      //color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  Text(
                                    _product.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      //color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Publ. on: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      //color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 170),
                                      child: Text(
                                        context
                                            .read<ProductProvider>()
                                            .productVisualized
                                            .publishedOn
                                            .map((community) => community.name)
                                            .join(', '),
                                        style: TextStyle(
                                          fontSize: 16,
                                          //color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Giver: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      //color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  Text(
                                    _product.giver.fullName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      //color: Theme.of(context).colorScheme.onSecondary
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                //height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              selectedCommunity != null
                                  ? 'Select the community where you want to receive the gift:'
                                  : 'You have selected',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: DropdownButton<CommunityBasic>(
                                  padding: EdgeInsets.only(left: 6,right: 6),
                                  dropdownColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  value: selectedCommunity,
                                  onChanged: (CommunityBasic? newValue) {
                                    setState(() {
                                      selectedCommunity = newValue;
                                    });
                                  },
                                  items: _product.publishedOn.map((community) {
                                    return DropdownMenuItem<CommunityBasic>(
                                      value: community,
                                      child: Text(community.name),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      selectedCommunity != null
                          ? Text(
                              'Hotspot Address: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : Container(),
                      selectedCommunity != null
                          ? communityAddressSpace()
                          : Container()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary;
                          }
                          return Theme.of(context)
                              .colorScheme
                              .primaryContainer;
                        },
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer
                        )

                      )
                    ),
                    onPressed: () {
                      if (selectedCommunity != null) {
                        // Qui puoi gestire la logica per confermare l'ordine
                        // Utilizza selectedCommunity e widget.product per eseguire l'operazione di checkout
                      } else {
                        showSnackBar(context, 'Please select a community for the delivery');
                      }
                    },
                    child: Text('Conferma Ordine'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  communityAddressSpace() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            selectedCommunity!.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            'Via cucuzza, 155',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '88070, Nocera Terinese (CZ)',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Tel. 0968/965865',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    ));
  }
}
