import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/screen/chat_tab.dart';
import 'package:community_share/view/community/screen/presentation_and_events.dart';
import 'package:community_share/view/community/screen/offers_tab.dart';
import 'package:community_share/view/community/screen/search_tab.dart';
import 'package:community_share/view/community/screen/user_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/community.dart';

class CommunityHome extends StatefulWidget{
  const CommunityHome({super.key});

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          children: [
            PresentationAndEventsTab(),
            OffersTab(),
            SearchTab(),
            ChatTab(),
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