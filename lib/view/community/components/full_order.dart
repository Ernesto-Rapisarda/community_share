import 'package:community_share/model/product_order.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/enum/order_status.dart';

class FullOrder extends StatefulWidget {
  late ProductOrder _productOrder;

  FullOrder({Key? key, required ProductOrder productOrder})
      : _productOrder = productOrder,
        super(key: key);

  @override
  State<FullOrder> createState() => _FullOrderState();
}

class _FullOrderState extends State<FullOrder> {
  final ProductService _productService = ProductService();
  final ConversationService _conversationService = ConversationService();


  void updateStatus(OrderStatus orderStatus) async {
    ProductOrder productOrder = await _productService.updateOrderStatus(
        context, widget._productOrder, orderStatus);
    if(orderStatus == OrderStatus.productDeliveredToHotSpot){

    }
    else if(orderStatus == OrderStatus.completed){

    }

    setState(() {
      widget._productOrder = productOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget._productOrder.product);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            'Order Details',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order ID: ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(widget._productOrder.id,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    //todo
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
                            widget._productOrder.product.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
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
                              child: Image.network(
                                widget._productOrder.product.urlImages,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  children: [
                    Text(
                      'Data ordine: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget._productOrder.orderDate.day}/${widget._productOrder.orderDate.month}/${widget._productOrder.orderDate.year}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Ricevente: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget._productOrder.receiver.fullName,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'HotSpot: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget._productOrder.hotSpot.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Stato ordine: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(widget._productOrder.orderStatus),
                      ),
                    ),
                    Text(
                      orderStatusToString(
                          widget._productOrder.orderStatus, context),
                      style: TextStyle(
                        fontSize: 16,
                        color: getStatusColor(widget._productOrder.orderStatus),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget._productOrder.orderStatus == OrderStatus.pending
                        ? OutlinedButton(
                            onPressed: () {
                              updateStatus(
                                  OrderStatus.productDeliveredToHotSpot);
                            },
                            child: Text('Arrivato in comunità'))
                        : Container(),
                    SizedBox(
                      width: 8,
                    ),
                    widget._productOrder.orderStatus ==
                            OrderStatus.productDeliveredToHotSpot
                        ? OutlinedButton(
                            onPressed: () {
                              updateStatus(OrderStatus.completed);
                            },
                            child: Text('Donazione completata'))
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
