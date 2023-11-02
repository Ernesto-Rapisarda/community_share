import 'package:community_share/l10n/l10n.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/navigation/app_router.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view/main_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  UserProvider userProvider = UserProvider();
  UserService userService = UserService(userProvider);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CommunityProvider())
    ],
    child: MyApp(userService: userService),
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter _router = AppRouter().router;
  final UserService _userService;

  MyApp({Key? key, required UserService userService})
      : _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Auth().currentUser != null){
      _userService.initializeUser(context);
    }
    return MaterialApp.router(
      title: 'Community Share',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue
                .shade100 /*, primary: Color(int.parse("ff77536c", radix: 16))*/),
        useMaterial3: true,
        /*iconTheme: IconThemeData(color: Color(int.parse("ff77536c", radix: 16))),
        tabBarTheme: TabBarTheme(
          labelColor: Color(int.parse("ff77536c", radix: 16)), // Imposta il colore del testo della tab selezionata a bianco
          unselectedLabelColor: Color(int.parse("ff77536c", radix: 16)).withOpacity(0.5),
          dividerColor: Color(int.parse("ff77536c", radix: 16)),*/
        // Imposta il colore del testo delle tab non selezionate a bianco con opacità 0.5
        /*indicator: BoxDecoration(
            color: Colors.white, // Imposta il colore del riquadro di indicazione delle tab a bianco
          ),
        ),*/
      ),

      //internationalization
      supportedLocales: L10n.all,
      locale: const Locale('en'),

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
/*      routeInformationParser: AppRouter().router.routeInformationParser,
      routerDelegate: AppRouter().router.routerDelegate,*/

      //end internationalization

      /*home: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const MyHomePage(title: 'title');
          }else{
            return const AuthPage();
          }
        },
      ),*/
    );
  }
}
