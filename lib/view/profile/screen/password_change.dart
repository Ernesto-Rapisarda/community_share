import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/show_snack_bar.dart';

class PasswordChange extends StatefulWidget{
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repeatPassword = TextEditingController();

  bool hideOldPassword = true;
  bool hidePassword = true;
  bool hideRepeatPassword = true;


  bool validOldPassword = false;
  bool validPassword = true;
  bool correctRepeatPassword = false;

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void _changePassword()async{
    try{
      bool passwordChanged = await Auth().changePassword(_oldPassword.text, _password.text, context.read<UserProvider>().userDetails.email);
      if(passwordChanged){
        passwordChangedMessage();
        await Future.delayed(const Duration(seconds: 3));
        await Auth().signOut();
        closeDialog();
      }
    }
    catch (error){
      callError(error.toString());
    }

  }

  void passwordChangedMessage(){
    print('password message');
    showSnackBar(context, AppLocalizations.of(context)!.passwordChanged);
  }

  void closeDialog(){
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.changePassword, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimaryContainer
          ),),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _oldPassword,
                obscureText: hideOldPassword,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3
                        ),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!.oldPassword),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hideOldPassword = !hideOldPassword;
                        });
                      },
                    )),
                keyboardType: TextInputType.visiblePassword,
                /*onChanged: (value) {
                  bool isValid = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
                  ).hasMatch(value);

                  if (isValid) {
                    setState(() {
                      validPassword = true;
                    });
                  } else {
                    setState(() {
                      validPassword = false;
                    });
                  }
                },*/
              ),
            ),
          ),
          SizedBox(height: 20,),


          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: validPassword
                              ? Colors.green
                              : Colors.red,
                        ),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!.newPassword),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )),
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  bool isValid = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$',
                  ).hasMatch(value);

                  if (isValid) {
                    setState(() {
                      validPassword = true;
                    });
                  } else {
                    setState(() {
                      validPassword = false;
                    });
                  }
                },
              ),
            ),
          ),
          !validPassword
              ? Text(
            AppLocalizations.of(context)!.rightPass,
            style: const TextStyle(fontSize: 12),
          )
              : const Center(),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 50.0,
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: 50.0,
                  maxHeight: 50.0),
              child: TextField(
                controller: _repeatPassword,
                obscureText: hideRepeatPassword,
                decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 10.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: correctRepeatPassword
                              ? Colors.green
                              : Colors.red,
                        ),
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    label: Text(AppLocalizations.of(context)!
                        .repeatNewPassword),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hideRepeatPassword =
                          !hideRepeatPassword;
                        });
                      },
                    )),
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  setState(() {
                    correctRepeatPassword =
                        value == _password.text;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: (){
                FocusScope.of(context).unfocus();
                _changePassword();
                }, child: Text(AppLocalizations.of(context)!.change, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),
              SizedBox(width: 8,),
              ElevatedButton(onPressed: (){
                closeDialog();
              }, child: Text(AppLocalizations.of(context)!.abort, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)))

            ],
          ),
        ],
      ),
    );
  }


}