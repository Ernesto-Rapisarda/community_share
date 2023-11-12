import 'package:community_share/service/community_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/product_order.dart';
import '../../../providers/community_provider.dart';
import '../components/order_card.dart';

class AdminTab extends StatefulWidget{
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();

}

class _AdminTabState extends State<AdminTab> {
  List<ProductOrder> _productsOrder = [];
  final CommunityService _communityService = CommunityService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async{
    List<ProductOrder> tmp = await _communityService.getCommunityOrders(context, context.read<CommunityProvider>().community.docRef!);
    setState(() {
      _productsOrder =tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _productsOrder.length,
      itemBuilder: (context, index) {
        ProductOrder order = _productsOrder[index];
        return OrderCard(order: order,isAdministrator: true,);
      },
    );
  }


}