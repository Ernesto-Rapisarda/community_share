import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/community/screen/chat_tab.dart';
import 'package:community_share/view/community/screen/events_tab.dart';
import 'package:community_share/view/community/screen/offers_tab.dart';
import 'package:community_share/view/community/screen/search_tab.dart';
import 'package:community_share/view/community/screen/user_list_tab.dart';
import 'package:flutter/material.dart';

import '../../../model/community.dart';

class CommunityHome extends StatefulWidget{
  final Community community;
  const CommunityHome({super.key, required this.community});

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
    return Scaffold(
      appBar: CommunityAppBar(community: widget.community, tabController: _tabController),
      body:TabBarView(
        controller: _tabController,
        children: [
          EventsTab(),
          OffersTab(),
          SearchTab(),
          ChatTab(),
          CommunityUsersList()


        ],
      ),

    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}