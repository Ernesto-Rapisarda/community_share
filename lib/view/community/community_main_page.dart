import 'package:community_share/view/community/components/communities_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.go('/communities/add');
        },
        tooltip: 'Create new community',
        child: const Icon(Icons.add),
      ),
    );
  }
}