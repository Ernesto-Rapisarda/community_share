import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/product_service.dart';
import 'package:community_share/utils/show_snack_bar.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../model/product.dart';
import '../../../service/user_service.dart';


class ProfileProducts extends StatefulWidget{
  const ProfileProducts({super.key});

  @override
  State<ProfileProducts> createState() => _ProfileProductsState();
}

class _ProfileProductsState extends State<ProfileProducts> with TickerProviderStateMixin{
  final UserService _userService = UserService();
  late TabController _tabController;
  late List<Product> _products = [];

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchProduct('given_products');
  }

  void fetchProduct(String collection) async{
    try
    {
      List<Product> tmp = [];
      if(collection != 'products_liked'){
        tmp = await _userService.getUserProductsFromCollection(collection);
      }
      else{
        tmp = context.read<UserProvider>().productLiked;
      }

      setState(() {
        _products = tmp;
      });
    }catch (error)
    {
      print(error.toString());
      callError(error.toString());
    }
  }

  void callError(String error){
    showSnackBar(context, error);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          AppLocalizations.of(context)!.gifts,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TabBar(
                controller: _tabController,
                onTap: (index){
                  if(index == 0){
                    fetchProduct('given_products');
                  }
                  else if( index == 1){
                    fetchProduct('received_products');
                  }
                  else{
                    fetchProduct('products_liked');
                  }
                },
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.donated,icon: FaIcon(FontAwesomeIcons.handHoldingHeart),),
                  Tab(text: AppLocalizations.of(context)!.received, icon: FaIcon(FontAwesomeIcons.handshakeAngle),),
                  Tab(text: AppLocalizations.of(context)!.liked,icon: FaIcon(FontAwesomeIcons.heart),),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 800,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12,top: 20, bottom: 30),
                    child: Container(
                        child: _products.length >0
                            ?ProductGrid(_products, route: '/profile/object_interactions')
                            :Text(AppLocalizations.of(context)!.nothingToShow)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12,top: 20, bottom: 30),
                    child: Container(
                        child: _products.length >0
                            ?ProductGrid(_products, route: '/profile/object_interactions')
                            :Text(AppLocalizations.of(context)!.nothingToShow)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12,top: 20, bottom: 30),
                    child: Container(
                        child: _products.length >0
                            ?ProductGrid(_products, route: '/profile/object_interactions')
                            :Text(AppLocalizations.of(context)!.nothingToShow)
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),),
    );
  }
}