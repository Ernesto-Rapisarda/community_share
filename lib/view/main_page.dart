

import 'package:community_share/main.dart';
import 'package:community_share/model/auth.dart';
import 'package:community_share/view/add_product.dart';
import 'package:community_share/view/community/community_main_page.dart';
import 'package:community_share/view/community/screen/communities_list.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/mail_box.dart';
import 'package:community_share/view/home.dart';
import 'package:community_share/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});



  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _children = [Home()];

  Future<void> signOut() async{
    await Auth().signOut();
    context.go('/login');

  }

  //For changing the screen
  void _onItemTapped(int index) {
    setState(() {
      if(_children.length==1){
        _children.add(AddProduct());
        _children.add(CommunitiesMainPage());
        _children.add(MailBox());
        _children.add(Profile());
      }
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('todo'),
        actions: [
          IconButton(onPressed: (){signOut();}, icon: Icon(Icons.logout))
        ],
        automaticallyImplyLeading: true,
      ),
        body: Container(child: _children.elementAt(_selectedIndex)),
        bottomNavigationBar: CurvedNavigationBar(
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
        )

      /*BottomNavigationBar(
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
}