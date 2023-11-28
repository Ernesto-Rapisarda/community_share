


import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/view/community/components/full_order.dart';
import 'package:community_share/view/community/screen/add_community.dart';
import 'package:community_share/view/community/screen/community_main_screen.dart';
import 'package:community_share/view/login/registration.dart';
import 'package:community_share/view/message/chat_screen.dart';
import 'package:community_share/view/product/add_product.dart';
import 'package:community_share/view/product/full_product.dart';
import 'package:community_share/view/main_page.dart';
import 'package:community_share/view/login/login.dart';
import 'package:community_share/view/profile/screen/orders_list.dart';
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

import '../service/auth.dart';
import '../model/community.dart';
import '../model/product.dart';
import '../view/product/checkout_product.dart';
import '../view/profile/profile.dart';

class AppRouter {
  late GoRouter _router;

  AppRouter() {
    _router = _createRouter();
  }

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation:
          Auth().currentUser != null /*&& Auth().currentUser!.emailVerified*/ &&
                  !UserProvider().firstSignIn
              ? '/'
              : '/login',
      routes: [
        GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: MainPage(),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'communities/home/:communityName',
                  pageBuilder: (context, state) {
                    String? communityName =
                        state.pathParameters['communityName'];
                    //Community community = state.extra as Community;
                    return MaterialPage(child: CommunityMainScreen());
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'edit',
                        pageBuilder: (context, state) {
                          return MaterialPage(child: AddCommunity(isEdit: true,));
                        }),
                    GoRoute(
                      path: 'order/:orderId',
                      pageBuilder: (context, state){
                        ProductOrder productOrder = state.extra as ProductOrder;
                        return MaterialPage(child: FullOrder(productOrder: productOrder,));
                      }
                    )
                  ]

                  ),
              GoRoute(
                  path: 'product/details/:productId',
                  pageBuilder: (context, state) {
                    /*
                  String? communityName = state.pathParameters['communityName'];
                  Product product = state.extra as Product;*/
                    return MaterialPage(child: FullProduct());
                  },
                routes: <RouteBase>[
                  GoRoute(path: 'edit',
                    pageBuilder: (context, state){
                    return MaterialPage(child: AddProduct(isEdit: true,));
                    },),
                  GoRoute(
                      path: 'checkout',
                      pageBuilder: (context, state){
                        return MaterialPage(child: CheckoutProduct());
                      } )
                ]
                  ),
              GoRoute(path: 'message_box/:conversationId',
                pageBuilder: (context,state){
                Conversation conversation = state.extra as Conversation;
                return MaterialPage(child: ChatScreen(conversation: conversation,));
                }

              ),

              GoRoute(
                  path: 'profile/paletta_colori',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: PalettaColori());
                  }),
              GoRoute(
                  path: 'profile/donated_products',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: DonatedProducts());
                  }),
              GoRoute(
                  path: 'profile/received_products',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: ReceivedProducts());
                  }),
              GoRoute(
                  path: 'profile/needed_products',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: NeededProducts());
                  }),
              GoRoute(
                  path: 'profile/orders',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: MyOrders());
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: ':orderId',
                        pageBuilder: (context, state){
                          ProductOrder productOrder = state.extra as ProductOrder;
                          return MaterialPage(child: FullOrder(productOrder: productOrder,));
                        }
                    )
                  ]
                  ),
              GoRoute(
                  path: 'profile/notifications',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: Notifications());
                  }),
              GoRoute(
                  path: 'profile/settings',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: ProfileSettings());
                  }),
              GoRoute(
                  path: 'profile/email_change',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: EmailChange());
                  }),
              GoRoute(
                  path: 'profile/password_change',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: PasswordChange());
                  }),
              GoRoute(
                  path: 'profile/addresses',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: Addresses());
                  }),
              GoRoute(
                  path: 'communities/add',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: AddCommunity(isEdit: false,));
                  }),
/*              GoRoute(
                  path: 'product/edit/:productId',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: AddProduct(isEdit: true,));
                  })*/
            ]),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: AuthPage(),
            );
          },
            routes: <RouteBase>[
              GoRoute(
                path: 'registration',
                pageBuilder: (context, state) {
                  bool isEmailAndPassword = state.extra as bool;

                  return MaterialPage(
                    child: Registration(isEmailAndPassword: isEmailAndPassword ),
                  );
                },
              ),
            ]
        ),

      ],
    );
  }

  GoRouter get router => _router;
}
