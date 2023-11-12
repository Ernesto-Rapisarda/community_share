import 'package:community_share/model/product_order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/enum/order_status.dart';

class FullOrder extends StatefulWidget{
  final ProductOrder _productOrder;

  FullOrder({Key? key, required ProductOrder productOrder}) : _productOrder = productOrder, super(key: key);

  @override
  State<FullOrder> createState() => _FullOrderState();
}

class _FullOrderState extends State<FullOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${widget._productOrder.id}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                widget._productOrder.product.urlImages,
                                fit: BoxFit
                                    .cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Order Date: ',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                    Text('${widget._productOrder.orderDate.day}/${widget._productOrder.orderDate.month}/${widget._productOrder.orderDate.year}',
                      style: TextStyle(fontSize: 16),)
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Receiver: ',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      'Order Status: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(widget._productOrder.orderStatus),
                      ),
                    ),
                    Text(
                      widget._productOrder.orderStatus.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: getStatusColor(widget._productOrder.orderStatus),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: (){}, child: Text('Community')),
                    SizedBox(width: 8,),
                    OutlinedButton(onPressed: (){}, child: Text('To Receiver'))
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