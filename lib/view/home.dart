

import 'package:community_share/main.dart';
import 'package:community_share/model/auth.dart';
import 'package:community_share/view/add_product.dart';
import 'package:community_share/view/community/community_main_page.dart';
import 'package:community_share/view/community/screen/communities_list.dart';
import 'package:community_share/view/community/components/community_app_bar.dart';
import 'package:community_share/view/mail_box.dart';
import 'package:community_share/view/main_page.dart';
import 'package:community_share/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> _children = [MainPage()];

  Future<void> signOut() async{
    await Auth().signOut();
  }

  //For changing the screen
  void _onItemTapped(int index) {
    setState(() {
      if(_children.length==1){
        _children.add(AddProduct());
        _children.add(CommunitiesMainPage(navigatorKey: navigatorKey,));
        _children.add(MailBox());
        _children.add(Profile());
      }
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      /*appBar: _selectedIndex==2? CommunityAppBar(myCommunities: [],): null,*/
        body: Center(child: _children.elementAt(_selectedIndex)),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: Colors.blueAccent,
          buttonBackgroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          animationDuration: Duration(milliseconds: 300),
          items: [
            FaIcon(FontAwesomeIcons.house, color: Colors.white,),
            FaIcon(FontAwesomeIcons.circlePlus, color: Colors.white,),
            FaIcon(FontAwesomeIcons.peopleGroup, color: Colors.white,),
            FaIcon(FontAwesomeIcons.envelope, color: Colors.white,),
            FaIcon(FontAwesomeIcons.user, color: Colors.white,)
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