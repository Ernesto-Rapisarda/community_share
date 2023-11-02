import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MemberRow extends StatelessWidget{
  final UserDetailsBasic userDetailsBasic;

  const MemberRow({super.key, required this.userDetailsBasic});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(userDetailsBasic.urlPhotoProfile),
          radius: 18,
        ),
        SizedBox(width: 8,),
        Text(userDetailsBasic.fullName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
        Expanded(child: SizedBox(width: double.infinity,)),
        //todo action
        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.eye,size: 20,)),
        //SizedBox(width: 8,),
        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.envelope,size: 20,) )
      ],
    );
  }

}