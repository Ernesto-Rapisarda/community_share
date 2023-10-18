import 'package:community_share/model/auth.dart';
import 'package:flutter/material.dart';

class IntroProfile extends StatelessWidget{
  const IntroProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/user_photos/examples/foto_profilo4.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              //todo sistemare le dimensioni
            ),
          ),
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text('Nome non presente',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text('Visualizza profilo pubblico',style: TextStyle(fontSize: 16)),
          ],
        )
      ],
    );
  }

}