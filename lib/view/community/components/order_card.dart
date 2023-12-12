import 'package:community_share/providers/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/model/enum/order_status.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'full_order.dart';

class OrderCard extends StatelessWidget {
  final bool isAdministrator;
  final ProductOrder order;

  const OrderCard({required this.order, super.key, required this.isAdministrator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          if(isAdministrator){
            //context.go('/communities/home/${context.read<CommunityProvider>().community.id}/order/${order.id}', extra: order);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  // Usa FullOrder come child della Dialog
                  child: FullOrder(productOrder: order),
                );
              },
            );

          }
          else{
            context.go('/profile/orders/${order.id}',extra: order);
          }
        },
        child: Card(
          elevation: 3,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(order.product.urlImages),
                ),
                title: Text(order.product.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Ordine: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    ),

                  ],
                ),
                trailing: Text(
                  'Stato: ${order.orderStatus.name}',
                  style: TextStyle(
                    color: getStatusColor(order.orderStatus),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Order id: ${order.id}'
                ),
              )
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
