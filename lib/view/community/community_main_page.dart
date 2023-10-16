import 'package:community_share/view/community/screen/communities_list.dart';
import 'package:flutter/material.dart';

import '../../navigation/community_route_generator.dart';

class CommunitiesMainPage extends StatefulWidget{
  final GlobalKey<NavigatorState> navigatorKey;

  const CommunitiesMainPage({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<CommunitiesMainPage> createState() => _CommunitiesMainPageState();
}

class _CommunitiesMainPageState extends State<CommunitiesMainPage> {
  Widget? _currentWidget;



  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Navigator(
        key: widget.navigatorKey,
        initialRoute: '/community_main_page',
        onGenerateRoute: CommunityRouteGenerator(widget.navigatorKey).generateRoute,

      )
    );
  }
}