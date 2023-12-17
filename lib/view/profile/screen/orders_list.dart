import 'package:community_share/model/product_order.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.ordersList, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,

        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(

          child: !dataFetched
            ? CircularLoadingIndicator.circularInd(context)
            : Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.outgoingOrders,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
                //SizedBox(height: 20),
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
                  child: Text(AppLocalizations.of(context)!.simpleNothingToShow,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          )),
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.receivingOrders,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
                //SizedBox(height: 20),
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
                  child: Text(AppLocalizations.of(context)!.simpleNothingToShow,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                         )),
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
