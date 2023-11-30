import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/basic/product_basic.dart';
import '../../../model/product.dart';

class OffersTab extends StatefulWidget{
  const OffersTab({super.key});

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  List<Product> _communityProducts = [];
  final CommunityService _communityService = CommunityService();

  @override
  void initState() {
    super.initState();
    loadProducts();

  }

  void loadProducts()async{
    List<Product> products = await _communityService.getCommunitysProducts(context);
    setState(() {
      _communityProducts = products;
    });
  }



  @override
  Widget build(BuildContext context) {
    return ProductGrid(_communityProducts, route: '/communities/home/${context.read<CommunityProvider>().community.id}/product/details/',);
  }
}

