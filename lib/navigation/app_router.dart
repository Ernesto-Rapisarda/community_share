import 'package:community_share/view/community/screen/community_home.dart';
import 'package:community_share/view/product/full_product.dart';
import 'package:community_share/view/main_page.dart';
import 'package:community_share/view/login/login.dart';
import 'package:community_share/view/profile/screen/paletta_colori.dart';
import 'package:community_share/view/temp/addresses.dart';
import 'package:community_share/view/temp/donated_products.dart';
import 'package:community_share/view/temp/donations_done.dart';
import 'package:community_share/view/temp/email_change.dart';
import 'package:community_share/view/temp/needed_products.dart';
import 'package:community_share/view/temp/notifications.dart';
import 'package:community_share/view/temp/password_change.dart';
import 'package:community_share/view/temp/profile_settings.dart';
import 'package:community_share/view/temp/received_products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth.dart';
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
      initialLocation: Auth().currentUser != null /*&& Auth().currentUser!.emailVerified*/ ? '/' : '/login',
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
            GoRoute(
                path: 'profile/donated_products',
                pageBuilder: (context,state){
                  return MaterialPage(child: DonatedProducts());
                }
            ),
            GoRoute(
                path: 'profile/received_products',
                pageBuilder: (context,state){
                  return MaterialPage(child: ReceivedProducts());
                }
            ),
            GoRoute(
                path: 'profile/needed_products',
                pageBuilder: (context,state){
                  return MaterialPage(child: NeededProducts());
                }
            ),
            GoRoute(
                path: 'profile/donations_done',
                pageBuilder: (context,state){
                  return MaterialPage(child: DonationsDone());
                }
            ),
            GoRoute(
                path: 'profile/notifications',
                pageBuilder: (context,state){
                  return MaterialPage(child: Notifications());
                }
            ),
            GoRoute(
                path: 'profile/settings',
                pageBuilder: (context,state){
                  return MaterialPage(child: ProfileSettings());
                }
            ),
            GoRoute(
                path: 'profile/email_change',
                pageBuilder: (context,state){
                  return MaterialPage(child: EmailChange());
                }
            ),
            GoRoute(
                path: 'profile/password_change',
                pageBuilder: (context,state){
                  return MaterialPage(child: PasswordChange());
                }
            ),
            GoRoute(
                path: 'profile/addresses',
                pageBuilder: (context,state){
                  return MaterialPage(child: Addresses());
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