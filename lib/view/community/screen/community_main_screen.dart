import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/screen/chat_tab.dart';
import 'package:community_share/view/community/screen/home_community.dart';
import 'package:community_share/view/community/screen/offers_tab.dart';
import 'package:community_share/view/community/screen/admin_tab.dart';
import 'package:community_share/view/community/screen/user_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/community.dart';
import '../../../service/auth.dart';

class CommunityMainScreen extends StatefulWidget{
  const CommunityMainScreen({super.key});

  @override
  State<CommunityMainScreen> createState() => _CommunityMainScreenState();
}

class _CommunityMainScreenState extends State<CommunityMainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    int length=3;
    if(Auth().currentUser?.uid == context.read<CommunityProvider>().community.founder.id) {
    length=4;};
    _tabController = TabController(length: length, vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    if(context.watch<CommunityProvider>().isLoading){
      return CircularProgressIndicator();

    }
    else{
      return Scaffold(
        appBar: CommunityAppBar(tabController: _tabController),
        body:TabBarView(
          controller: _tabController,
          children: Auth().currentUser?.uid == context.read<CommunityProvider>().community.founder.id ?[

            HomeCommunity(),
            OffersTab(),
            CommunityUsersList(),AdminTab()



          ]:[
            HomeCommunity(),
            OffersTab(),
            CommunityUsersList()
          ],
        ),

      );
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}