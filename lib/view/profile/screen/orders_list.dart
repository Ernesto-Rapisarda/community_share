import 'package:community_share/model/product_order.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:flutter/material.dart';

import '../../../model/enum/order_status.dart';
import '../../community/components/order_card.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final UserService userService = UserService();
  bool dataFetched = false;
  late List<ProductOrder> _outcomingOrders;
  late List<ProductOrder> _incomingOrders;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    List<ProductOrder> outcomingOrders = await userService.getMyOrders(context,true);
    List<ProductOrder> incomingOrders = await userService.getMyOrders(context, false);

    setState(() {
      dataFetched = true;
      _outcomingOrders = outcomingOrders;
      _incomingOrders = incomingOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders List',),
        automaticallyImplyLeading: true,
      ),
      body: !dataFetched
          ? CircularLoadingIndicator.circularInd(context)
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Donating products',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _outcomingOrders.length>0
              ?ListView.builder(
                shrinkWrap: true,
                itemCount: _outcomingOrders.length,
                itemBuilder: (context, index) {
                  ProductOrder order = _outcomingOrders[index];
                  return OrderCard(order: order,isAdministrator: false,);
                },
              )
                  : Center(
                child: Text('Nothing to show', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              Text(
                'Receiving products',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _incomingOrders.length>0
              ?ListView.builder(
                shrinkWrap: true,
                itemCount: _incomingOrders.length,
                itemBuilder: (context, index) {
                  ProductOrder order = _incomingOrders[index];
                  return OrderCard(order: order, isAdministrator: false,);
                },
              )
                  : Center(
                child: Text('Nothing to show', style: TextStyle(fontSize: 18)),
              ),
            ],
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
