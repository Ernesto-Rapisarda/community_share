import 'package:community_share/main.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/user_service.dart';
import 'package:community_share/utils/circular_load_indicator.dart';
import 'package:community_share/view/product/add_product.dart';
import 'package:community_share/view/community/communities_main_screen.dart';
import 'package:community_share/view/community/components/communities_list.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/mail_box.dart';
import 'package:community_share/view/home.dart';
import 'package:community_share/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool _isLoading ;
  int _selectedIndex = 0;
  List<Widget> _children = [Home()];

  @override
  void initState() {
    super.initState();
    UserService().initializeUser(context);
    print(context.read<UserProvider>().userDetails);
  }

/*  Future<void> signOut() async{
    await Auth().signOut();
    context.go('/login');

  }*/

  //For changing the screen
  void _onItemTapped(int index) {
    setState(() {
      if (_children.length == 1) {
        _children.add(AddProduct(
          isEdit: false,
        ));
        _children.add(CommunitiesMainScreen());
        _children.add(MailBox());
        _children.add(Profile());
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = context.watch<UserProvider>().isLoading;
    if (!_isLoading) {
      print(context.read<UserProvider>().userDetails);

      return SafeArea(
          child: Scaffold(
/*      appBar: AppBar(
        title: Text('todo'),
        actions: [
          IconButton(onPressed: (){signOut();}, icon: Icon(Icons.logout))
        ],
        automaticallyImplyLeading: true,
      ),*/
        body: Container(child: _children.elementAt(_selectedIndex)),
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
              padding: EdgeInsets.all(16),
              onTabChange: _onItemTapped,
              tabs: [
                GButton(
                  text: "Home",
                  icon: FontAwesomeIcons.house,
                ),
                GButton(
                  text: "Inserisci",
                  icon: FontAwesomeIcons.circlePlus,
                ),
                GButton(
                  text: "Comunità",
                  icon: FontAwesomeIcons.peopleGroup,
                ),
                GButton(
                  text: "Messaggi",
                  icon: FontAwesomeIcons.envelope,
                ),
                GButton(
                  text: "Profilo",
                  icon: FontAwesomeIcons.user,
                ),
              ],
            ),
          ),
        ),

        /* navigazione curva CurvedNavigationBar(
          height: 60,
          color: Theme.of(context).colorScheme.primary,
          buttonBackgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.white,
          animationDuration: Duration(milliseconds: 300),
          items: [
            FaIcon(FontAwesomeIcons.house, color: Theme.of(context).colorScheme.onPrimary,),
            FaIcon(FontAwesomeIcons.circlePlus, color: Theme.of(context).colorScheme.onPrimary,),
            FaIcon(FontAwesomeIcons.peopleGroup, color: Theme.of(context).colorScheme.onPrimary,),
            FaIcon(FontAwesomeIcons.envelope, color: Theme.of(context).colorScheme.onPrimary,),
            FaIcon(FontAwesomeIcons.user, color: Theme.of(context).colorScheme.onPrimary,)
          ],
          onTap: _onItemTapped,
        )*/

        /*my version BottomNavigationBar(
        iconSize: 32.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: FaIcon(FontAwesomeIcons.house),
          ),
          BottomNavigationBarItem(
              label: "Inserisci",
              icon: FaIcon(FontAwesomeIcons.circlePlus)
          ),
          BottomNavigationBarItem(
              label: "Community",
              icon: FaIcon(FontAwesomeIcons.peopleGroup)
          ),
          BottomNavigationBarItem(
              label: "InBox",
              icon: FaIcon(FontAwesomeIcons.envelope)
          ),
          BottomNavigationBarItem(
              label: "Profile",
              icon: FaIcon(FontAwesomeIcons.user)
          )
        ],
        onTap: _onItemTapped,
      ),*/
      ));
    }
    else{
      return CircularLoadingIndicator.circularInd(context);
    }
  }
}
