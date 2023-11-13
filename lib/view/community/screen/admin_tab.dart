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

class _AdminTabState extends State<AdminTab> with SingleTickerProviderStateMixin{
  late TabController _innerTabController;

  List<ProductOrder> _productsOrder = [];
  final CommunityService _communityService = CommunityService();

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 3, vsync: this);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: [
            Tab(text: 'Orders'),
            Tab(text: 'Events'),
            Tab(text: 'Reports'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              // Il tuo elenco di ordini
              ListView.builder(
                shrinkWrap: true,
                itemCount: _productsOrder.length,
                itemBuilder: (context, index) {
                  ProductOrder order = _productsOrder[index];
                  return OrderCard(order: order, isAdministrator: true);
                },
              ),
              // La scheda degli eventi
              // Includi qui il codice per la scheda degli eventi
              Container(
                child: Center(
                  child: Text('Events Tab Content'),
                ),
              ),
              // La scheda dei report
              // Includi qui il codice per la scheda dei report
              Container(
                child: Center(
                  child: Text('Reports Tab Content'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}