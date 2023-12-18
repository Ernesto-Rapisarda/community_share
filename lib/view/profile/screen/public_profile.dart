import 'package:community_share/model/community.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/view/community/components/community_card.dart';
import 'package:community_share/view/generic_components/product_grid.dart';
import 'package:community_share/view/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/enum/product_category.dart';
import '../../../model/product.dart';
import '../../../providers/UserProvider.dart';
import '../../../providers/product_provider.dart';
import '../../../service/auth.dart';
import '../../../service/product_service.dart';

class PublicProfile extends StatefulWidget {
  final UserDetails userDetails;

  const PublicProfile({super.key, required this.userDetails});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> with TickerProviderStateMixin {
  late List<Product> products = [];
  late  List<Community> communities = [];
  final UserService userService = UserService();
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    fetchData();

  }

  void fetchData()async{
     List<Product> temp = await userService.getUserProducts(widget.userDetails.id!);
     List<Community> tempComm = await userService.getUserCommunities(widget.userDetails.id!);
     setState(() {
       products = temp;
       communities = tempComm;
       print(communities.length);
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          AppLocalizations.of(context)!.publicProfile,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: NetworkImage(
                        widget.userDetails.urlPhotoProfile,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.userDetails.fullName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FaIcon(FontAwesomeIcons.triangleExclamation, size: 22),

                          SizedBox(
                            width: 12,
                          ),
                          FaIcon(FontAwesomeIcons.envelope, size: 22),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.donationsOfUser,icon: FaIcon(FontAwesomeIcons.handHoldingHeart),),
                  Tab(text: AppLocalizations.of(context)!.communitiesOfUser,icon: FaIcon(FontAwesomeIcons.users),),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 800,
              child: TabBarView(
                controller: _tabController,
                children: [
                  products.length>0 ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ProductGrid(products, route: ''),
                  )
                  :
                  Center(
                    child: Text(AppLocalizations.of(context)!.nothingToShow,style: TextStyle(fontSize: 20)),
                  ),

                  communities.length>0?
                  GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 16, mainAxisExtent: 330),
                  itemCount: communities.length,
                  itemBuilder: (_, index) {
                    bool isMyProfile = context.read<UserProvider>().userDetails.id == Auth().currentUser?.uid;
                  //String finalRoute = '${widget.route}${widget.products[index].id}';
                  return CommunityCard(community: communities[index], myCommunities: isMyProfile);
                  }

                  )
                      :Center(
                    child: Text(AppLocalizations.of(context)!.nothingToShow,style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
            ),


          ]),
        ),
      ),
    );
  }



}

