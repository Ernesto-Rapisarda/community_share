import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/providers/community_provider.dart';
import 'package:community_share/view/community/components/member_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user_details.dart';
import '../../../navigation/app_router.dart';
import '../../../service/community_service.dart';
import '../../../service/user_service.dart';

class CommunityUsersList extends StatefulWidget {
  const CommunityUsersList({super.key});

  @override
  State<CommunityUsersList> createState() => _CommunityUsersListState();
}

class _CommunityUsersListState extends State<CommunityUsersList> {

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      List<UserDetailsBasic> members = await CommunityService().getMembers(context);

      context.read<CommunityProvider>().members = members;

    } catch (error) {
      print('Errore durante il recupero dei membri: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    var members = context.watch<CommunityProvider>().members;


    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Founder:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            MemberRow(userDetailsBasic: context.read<CommunityProvider>().community.founder),
            SizedBox(height: 20,),
            Text('Members: ${context.read<CommunityProvider>().community.members -1}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ...members.map((tmp) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4),
              child: MemberRow(userDetailsBasic: tmp),
            )).toList(),
          ],
        ),
      ),
    );
  }
}