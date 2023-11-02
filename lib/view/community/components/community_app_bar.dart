import 'package:community_share/model/community.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;


  const CommunityAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,

        child: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          title: Text(
            context.watch<CommunityProvider>().community.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          automaticallyImplyLeading: true,

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                //todo
                // Handle menu item selection here
                if (value == 'settings') {
                  // Handle settings action
                } else if (value == 'logout') {
                  // Handle logout action
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Settings', 'Logout'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase(),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
              controller: tabController,
              tabs: [
            Tab(
              icon: FaIcon(FontAwesomeIcons.calendar),
              text: 'Home',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.list),
              text: 'Offerti',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
              text: 'Cerco',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.comments),
              text: 'Chat',
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.users),
              text: 'Users',
            ),
          ]),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(130);
}
