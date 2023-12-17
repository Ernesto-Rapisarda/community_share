import 'dart:async';

import 'package:community_share/main.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/product/add_product.dart';
import 'package:community_share/view/community/communities_main_screen.dart';
import 'package:community_share/view/message/mail_box.dart';
import 'package:community_share/view/home.dart';
import 'package:community_share/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //final UserProvider _userProvider = UserProvider();
  final ConversationService _conversationService = ConversationService();
  late bool _isLoading;
  int unreadMessage = 0;

  int _selectedIndex = 0;
  final List<Widget> _children = [Home()];
  String appBarTitle = 'HOME';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    startBackgroungUnreadedMessage();
  }

  void startBackgroungUnreadedMessage(){
    const Duration updateInterval = Duration(minutes: 3);
    Timer.periodic(updateInterval,(Timer timer) async{
    context.read<UserProvider>().unreadMessage = await _conversationService.unreadedMessageNumber();
    context.read<UserProvider>().notifyListeners();
    });
  }


  void fetchUserData() async {
    await UserService().initializeUser(context);
    setPreference();
  }

  void setPreference() {
    ThemeData theme;
    Locale locale;
    if (context.read<UserProvider>().userDetails.theme == 'light') {
      theme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue));
    } else {
      theme = ThemeData.dark(useMaterial3: true);
    }
    if (context.read<UserProvider>().userDetails.language == 'it') {
      locale = const Locale('it');
    } else {
      locale = const Locale('en');
    }
    MyApp.setTheme(context, theme);
    MyApp.setLocale(context, locale);
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_children.length == 1) {
        _children.add(const AddProduct(
          isEdit: false,
        ));
        _children.add(const CommunitiesMainScreen());
        _children.add(const MailBox());
        _children.add(const Profile());
      }
      _selectedIndex = index;

      switch (index) {
        case 0:
          appBarTitle = AppLocalizations.of(context)!.pageHome;
          break;
        case 1:
          appBarTitle = AppLocalizations.of(context)!.pageDonate;
          break;
        case 2:
          appBarTitle = AppLocalizations.of(context)!.pageCommunities;
          break;
        case 3:
          appBarTitle = AppLocalizations.of(context)!.pageMessageBox;
          break;
        case 4:
          appBarTitle = AppLocalizations.of(context)!.pageProfile;
          break;
        default:
          appBarTitle = AppLocalizations.of(context)!.pageHome;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = context.watch<UserProvider>().isLoading;
    unreadMessage = context.watch<UserProvider>().unreadMessage;

    if (!_isLoading) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: _children.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: GNav(
              gap: 8,
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
              tabBackgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.all(16),
              onTabChange: _onItemTapped,
              tabs: [
                GButton(
                  text: AppLocalizations.of(context)!.barHome,
                  icon: FontAwesomeIcons.house,
                ),
                GButton(
                  text: AppLocalizations.of(context)!.barDonate,
                  icon: FontAwesomeIcons.circlePlus,
                ),
                GButton(
                  text: AppLocalizations.of(context)!.barCommunities,
                  icon: FontAwesomeIcons.peopleGroup,
                ),
                GButton(
                  text: AppLocalizations.of(context)!.barMessageBox,
                  icon: FontAwesomeIcons.envelope,
                  leading: unreadMessage==0 ?null :Badge(
                      label: Text(unreadMessage.toString()),
                      textColor: Colors.red.shade100,
                      child: FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 24,
                        color: _selectedIndex == 3
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onPrimary,
                      )),
                ),
                GButton(
                  text: AppLocalizations.of(context)!.barProfile,
                  icon: FontAwesomeIcons.user,
                ),
              ],
            ),
          ),
        ),
      ));
    } else {
      return CircularLoadingIndicator.circularInd(context);
    }
  }
}
