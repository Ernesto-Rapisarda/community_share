import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
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
import 'package:community_share/view/profile/screen/public_profile.dart';
import 'package:community_share/view/temp/addresses.dart';
import 'package:community_share/view/profile/screen/gifts_tabs.dart';
import 'package:community_share/view/temp/email_change.dart';
import 'package:community_share/view/temp/needed_products.dart';
import 'package:community_share/view/temp/notifications.dart';
import 'package:community_share/view/temp/password_change.dart';
import 'package:community_share/view/temp/profile_settings.dart';
import 'package:community_share/view/temp/received_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../service/auth.dart';
import '../view/product/checkout_product.dart';

class AppRouter {
  late GoRouter _router;
  static final AppRouter _singleton = AppRouter._internal();

  factory AppRouter() {
    return _singleton;
  }

/*  AppRouter() {
    _router = _createRouter();
    _listenToAuthChanges();
  }*/

  AppRouter._internal() : _router = _createRouter() {
    _listenToAuthChanges();
  }

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation:
          Auth().currentUser != null /*&& Auth().currentUser!.emailVerified */
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
                    state.pathParameters['communityName'];
                    return const MaterialPage(child: CommunityMainScreen());
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'edit',
                        pageBuilder: (context, state) {
                          return const MaterialPage(
                              child: AddCommunity(
                            isEdit: true,
                          ));
                        }),
                    _productSubRoutes(),
                    GoRoute(
                        path: 'order/:orderId',
                        pageBuilder: (context, state) {
                          ProductOrder productOrder =
                              state.extra as ProductOrder;
                          return MaterialPage(
                              child: FullOrder(
                            productOrder: productOrder,
                          ));
                        })
                  ]),
              _productSubRoutes() ,
              GoRoute(
                  path: 'message_box/:conversationId',
                  pageBuilder: (context, state) {
                    Conversation conversation = state.extra as Conversation;
                    return MaterialPage(
                        child: ChatScreen(
                      conversation: conversation,
                    ));
                  }),
              GoRoute(
                  path: 'profile/paletta_colori',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: PalettaColori());
                  }),
              GoRoute(
                  path: 'profile/object_interactions',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: ProfileProducts());
                  }, routes: <RouteBase>[
                    _productSubRoutes()
              ]

                  ),
              GoRoute(
                  path: 'profile/orders',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: MyOrders());
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: ':orderId',
                        pageBuilder: (context, state) {
                          ProductOrder productOrder =
                              state.extra as ProductOrder;
                          return MaterialPage(
                              child: FullOrder(
                            productOrder: productOrder,
                          ));
                        })
                  ]),
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
                    return MaterialPage(
                        child: AddCommunity(
                      isEdit: false,
                    ));
                  }),
              GoRoute(path: 'profile/public/:userId',
                pageBuilder: (context,state){
                  UserDetails userDetails =
                  state.extra as UserDetails;
                return MaterialPage(child: PublicProfile(userDetails: userDetails,));
                }
              ),
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
                    child: Registration(isEmailAndPassword: isEmailAndPassword),
                  );
                },
              ),
            ]),
      ],
    );
  }

  void _listenToAuthChanges() {
    Auth().authStateChanges.listen((User? user) {
      bool isUserLoggedIn = user != null /*&& user.emailVerified*/;
      if (isUserLoggedIn) {
        _router.go('/');
      } else {
        _router.go('/login');
      }
    });
  }

  static GoRoute  _productSubRoutes(){
    return GoRoute(
        path: 'product/details/:productId',
        pageBuilder: (context, state) {
      return const MaterialPage(child: FullProduct());
    },
    routes: <RouteBase>[
      GoRoute(path: 'profile/public/:userId',
          pageBuilder: (context,state){
            UserDetails userDetails =
            state.extra as UserDetails;
            return MaterialPage(child: PublicProfile(userDetails: userDetails,));
          }
      ),
      GoRoute(
        path: 'edit',
        pageBuilder: (context, state) {
          return const MaterialPage(
              child: AddProduct(
                isEdit: true,
              ));
        },
      ),
      GoRoute(
          path: 'checkout',
          pageBuilder: (context, state) {
            return MaterialPage(child: CheckoutProduct());
          })
    ]);
  }

  GoRouter get router => _router;
  String get currentRoute => _router.toString();
}
