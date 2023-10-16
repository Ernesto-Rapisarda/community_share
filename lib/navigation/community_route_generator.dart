import 'package:community_share/model/community.dart';
import 'package:community_share/view/community/community_main_page.dart';
import 'package:community_share/view/community/screen/community_home.dart';
import 'package:community_share/view/error_page.dart';
import 'package:flutter/material.dart';

import '../view/community/screen/communities_list.dart';

class CommunityRouteGenerator{
  final GlobalKey<NavigatorState> navigatorKey;

  CommunityRouteGenerator(this.navigatorKey);

  Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/community_main_page':
        return MaterialPageRoute(builder: (context)=> CommunitiesList());
      case '/community_home':
        if(args is Community) {
          return MaterialPageRoute(
              builder: (context) => CommunityHome(community: args));
        }
        return
          MaterialPageRoute(builder: (context)=>const ErrorPage());
      default:
        return MaterialPageRoute(builder: (context)=>const ErrorPage());

    }
  }
}