import 'package:community_share/view/community/screen/communities_list.dart';
import 'package:flutter/material.dart';


class CommunitiesMainPage extends StatefulWidget{
  const CommunitiesMainPage({super.key});



  @override
  State<CommunitiesMainPage> createState() => _CommunitiesMainPageState();
}

class _CommunitiesMainPageState extends State<CommunitiesMainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Center(
        child: CommunitiesList(),
      )
    );
  }
}