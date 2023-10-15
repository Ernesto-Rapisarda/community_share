import 'package:community_share/model/community.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget{
  final List<Community> myCommunities;

  CommunityAppBar({required this.myCommunities});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: AppBar(
          bottom: TabBar(
              tabs:[
                Tab(icon: FaIcon(FontAwesomeIcons.calendar),text: 'Eventi',),
                Tab(icon: FaIcon(FontAwesomeIcons.list),text: 'Offerti',),
                Tab(icon: FaIcon(FontAwesomeIcons.magnifyingGlass),text: 'Cerco',),
                Tab(icon: FaIcon(FontAwesomeIcons.comments),text: 'Chat',),
                Tab(icon: FaIcon(FontAwesomeIcons.users),text: 'Users',),
              ]
          ),
        )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);



}