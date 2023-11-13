import 'package:community_share/model/community.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../service/auth.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;


  const CommunityAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    bool isFounder = Auth().currentUser?.uid == context.read<CommunityProvider>().community.founder.id;

    List<Tab> tabs = [
      Tab(
        icon: FaIcon(FontAwesomeIcons.calendar),
        text: 'Home',
      ),
      Tab(
        icon: FaIcon(FontAwesomeIcons.handHoldingHeart),
        text: 'Offerti',
      ),
      Tab(
        icon: FaIcon(FontAwesomeIcons.comments),
        text: 'Chat',
      ),
      Tab(
        icon: FaIcon(FontAwesomeIcons.users),
        text: 'Users',
      ),
    ];

    if(isFounder){
      tabs.add( Tab(
        icon: FaIcon(FontAwesomeIcons.gears),
        text: 'Admin',
      ));
    }

    return DefaultTabController(
        length: 5,

        child: AppBar(
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            context.watch<CommunityProvider>().community.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                //todo
                // Handle menu item selection here
                if (value == 'fast edit'){
                  context.go('/communities/home/${context.read<CommunityProvider>().community.name}/edit');

                }
                else if(value == 'settings') {
                  // Handle settings action
                } else if (value == 'logout') {
                  // Handle logout action
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Fast edit','Settings', 'Logout'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase(),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.white,
              //indicatorColor: Theme.of(context).colorScheme.onPrimary,
              indicatorColor: Theme.of(context).colorScheme.primary,

              controller: tabController,
              tabs:tabs
            /* [
            Tab(
              icon: FaIcon(FontAwesomeIcons.calendar),
              text: 'Home',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.handHoldingHeart),
              text: 'Offerti',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.gears),
              text: 'Admin',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.comments),
              text: 'Chat',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.users),
              text: 'Users',
            ),
          ]*/),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(130);
}
