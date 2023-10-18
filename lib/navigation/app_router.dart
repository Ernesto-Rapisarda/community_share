import 'package:community_share/view/community/screen/community_home.dart';
import 'package:community_share/view/product/full_product.dart';
import 'package:community_share/view/main_page.dart';
import 'package:community_share/view/login/login.dart';
import 'package:community_share/view/profile/screen/paletta_colori.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/auth.dart';
import '../model/community.dart';
import '../model/product.dart';
import '../view/profile/profile.dart';

class AppRouter {
  late GoRouter _router;

  AppRouter() {
    _router = _createRouter();
  }

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: Auth().currentUser != null ? '/' : '/login',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MainPage(),);
          },
          routes: <RouteBase>[
            GoRoute(
                path: 'communities/home/:communityName',
                pageBuilder: (context, state){
                  String? communityName = state.pathParameters['communityName'];
                  Community community = state.extra as Community;
                  return MaterialPage(child: CommunityHome(community: community));
                }
            ),
            GoRoute(
                path: 'product/details/:productId',
                pageBuilder: (context, state){/*
                  String? communityName = state.pathParameters['communityName'];*/
                  Product product = state.extra as Product;
                  return MaterialPage(child: FullProduct(product: product));
                }
            ),
            GoRoute(
                path: 'profile/paletta_colori',
              pageBuilder: (context,state){
                  return MaterialPage(child: PalettaColori());
              }
            ),

          ]
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: AuthPage(),);
          },
        ),

      ],
    );
  }

  GoRouter get router => _router;
}