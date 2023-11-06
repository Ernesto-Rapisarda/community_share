import 'package:community_share/view/community/components/communities_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CommunitiesMainScreen extends StatefulWidget{
  const CommunitiesMainScreen({super.key});



  @override
  State<CommunitiesMainScreen> createState() => _CommunitiesMainScreenState();
}

class _CommunitiesMainScreenState extends State<CommunitiesMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: CommunitiesList(),

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