import 'dart:io';
import 'dart:typed_data';

import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/service/image_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../providers/UserProvider.dart';

class IntroProfile extends StatefulWidget {
  const IntroProfile({super.key});

  @override
  State<IntroProfile> createState() => _IntroProfileState();
}

class _IntroProfileState extends State<IntroProfile> {
  String? _imageUrl;

  void selectImage() async {
    XFile? imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      String? imageUrl = await ImageService().uploadImage(imageFile);
      /*setState(() {
        _imageUrl = imageUrl;
      });*/
      if (imageUrl != null) {
        context.read<UserProvider>().updateUser(urlPhotoProfile: imageUrl);
        await UserRepository().updateUserDetails(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: (){
          context.go('/profile/public/:userId', extra: context.read<UserProvider>().userDetails );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: context
                              .read<UserProvider>()
                              .userDetails
                              .urlPhotoProfile !=
                          ''
                      ? NetworkImage(context
                          .read<UserProvider>()
                          .userDetails
                          .urlPhotoProfile)
                      : AssetImage(
                              'assets/images/user_photos/examples/UserProfileDefault.png')
                          as ImageProvider<Object>,
                ),
                /*Container(
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
                ),*/
                /*Positioned(
                  bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () { selectImage(); },
                      icon: Icon(Icons.add_a_photo,size: 20,color: Theme.of(context).colorScheme.primary,),

                ))*/
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.read<UserProvider>().userDetails.fullName ??
                      'Nome non presente',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Visualizza profilo pubblico',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(width: 12,),
                    FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
