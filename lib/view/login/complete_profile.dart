import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/view/login/components/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class CompleteProfile extends StatefulWidget{
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  //UserDetails _userDetails =  ;
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  Future<void> completeRegistration() async{
    context.read<UserProvider>().updateUser(
      fullName: _fullName.text,
      location: _location.text,
      phoneNumber: _phoneNumber.text,
    );
    await UserRepository().createUserDetails(context);
    context.go('/');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            WelcomeWidget(),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _fullName,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!.choiceDisplayedName)),
              ),
            ),
            SizedBox(height: 8,),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _location,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!.choiceLocation)),
              ),
            ),
            SizedBox(height: 8,),
            ConstrainedBox(

              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!.addYourPhoneNumber)),
              ),
            ),
            SizedBox(height: 8,),
            OutlinedButton(
                onPressed: () {
                  completeRegistration();

                },
                child: Text(AppLocalizations.of(context)!.completeRegistration)),


          ],

        ),

      ),

    );
  }
}