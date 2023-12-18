import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../model/user_details.dart';
import '../../../navigation/app_router.dart';
import '../../../providers/product_provider.dart';
import '../../../service/user_service.dart';
import '../../../utils/show_snack_bar.dart';

class MemberRow extends StatefulWidget{
  final UserDetailsBasic userDetailsBasic;

  const MemberRow({super.key, required this.userDetailsBasic});

  @override
  State<MemberRow> createState() => _MemberRowState();
}

class _MemberRowState extends State<MemberRow> {
  final UserService userService = UserService();


  void viewGiverPublicProfile() async {
    try {
      UserDetails userDetails = await userService.getUserByIdDoc(
          widget.userDetailsBasic.id);

      String currentRoute =
      AppRouter().router.routerDelegate.currentConfiguration.uri.toString();
      print(currentRoute);
      String destinationRoute =
          '$currentRoute/profile/public/${userDetails.id}';
      print(destinationRoute);
      goToTheGiverPage(userDetails, destinationRoute);
    } catch (error) {
      callError(error.toString());
    }
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.userDetailsBasic.urlPhotoProfile),
          radius: 18,
        ),
        SizedBox(width: 8,),
        Text(widget.userDetailsBasic.fullName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
        Expanded(child: SizedBox(width: double.infinity,)),
        //todo action
        InkWell(
          onTap: (){},
          child: FaIcon(FontAwesomeIcons.ban, size: 20,),
        ),
        SizedBox(width: 8,),
        InkWell(
          onTap: (){
            viewGiverPublicProfile();
          },
          child: FaIcon(FontAwesomeIcons.eye,size: 20,),
        ),
        SizedBox(width: 8,),
        InkWell(
          onTap: (){},
          child: FaIcon(FontAwesomeIcons.envelope, size: 20,),
        ),
        SizedBox(width: 8,),
/*        InkWell(
          onTap: (){},
          child: FaIcon(FontAwesomeIcons.crown, size: 20,),
        )*/


      ],
    );
  }

  void goToTheGiverPage(UserDetails userDetails, String route) {
    context.go(route, extra: userDetails);
  }
}