import 'package:community_share/view/community/screen/communities_list.dart';
import 'package:flutter/material.dart';

class CommunitiesMainPage extends StatelessWidget{
  const CommunitiesMainPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommunitiesList(),
    );
  }

}