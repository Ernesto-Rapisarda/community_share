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

  /*UserProvider userProvider = UserProvider();
  UserService userService = UserService(userProvider);*/

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CommunityProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  static void setTheme(BuildContext context, ThemeData theme){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setTheme(theme);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _locale = Locale('en');
    _theme = ThemeData.dark(useMaterial3: true);
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void setTheme(ThemeData newTheme) {
    setState(() {
      _theme = newTheme;
    });
  }

  final GoRouter _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Community Share',
      theme: _theme,
      //lightTheme: ThemeData.light(useMaterial3: true),
      themeMode: ThemeMode.system,
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue
                .shade100 *//*, primary: Color(int.parse("ff77536c", radix: 16))*//*),
        useMaterial3: true,

      ),*/

      //internationalization
      supportedLocales: L10n.all,
      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,

    );
  }
}
