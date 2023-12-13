import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../model/user_details.dart';
import '../../../providers/UserProvider.dart';
import '../../../service/auth.dart';
import '../../../service/image_service.dart';
import '../../../utils/show_snack_bar.dart';


class ProfileSettings extends StatefulWidget{
  final bool isEmailAndPassword;

  const ProfileSettings({super.key, required this.isEmailAndPassword});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repeatPassword = TextEditingController();
  String _language = 'en';
  String _theme = 'dark';
  bool hideRepeatPassword = true;
  bool hidePassword = true;

  bool validEmail = false;
  bool validPassword = true;
  bool correctRepeatPassword = false;

  bool _showImagePreview = false;
  XFile? imageFile;

  late ThemeData currentTheme;
  late bool isDarkTheme;

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  void selectImage() async {
    imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _showImagePreview = true;
      });
    }
  }

  Future<String?> uploadImage() async {
    return await ImageService().uploadImage(imageFile!);
  }

  bool checkAllComplete() {
    if (widget.isEmailAndPassword &&
        validEmail &&
        validPassword &&
        correctRepeatPassword &&
        _fullName.text != '' &&
        _phoneNumber.text != '') {
      return true;
    } else if (_fullName.text != '' && _phoneNumber.text != '') {
      return true;
    }
    return false;
  }

  Future<void> updateUser() async {
    /*try {
      if (checkAllComplete()) {
        if (widget.isEmailAndPassword) {
          await Auth().createUserInWithEmailAndPassword(
              email: _email.text, password: _password.text);
          await Auth().signInWithEmailAndPassword(
              email: _email.text, password: _password.text);
        } else {}
        String? urlImage = await uploadImage();
        UserDetails userDetails = UserDetails(
            id: Auth().currentUser?.uid,
            fullName: _fullName.text,
            location: _location.text,
            phoneNumber: _phoneNumber.text,
            email: _email.text,
            provider: widget.isEmailAndPassword
                ? ProviderName.email
                : ProviderName.google,
            urlPhotoProfile: urlImage ?? '',
            lastTimeOnline: DateTime.now(),
            lastUpdate: DateTime.now(),
            language: _language,
            theme: _theme);
        await Auth().completeRegistration(Auth().currentUser!.uid, userDetails);
        accountCreated();
        await Future.delayed(const Duration(seconds: 3));
        if (widget.isEmailAndPassword) {
          await Auth().signOut();
        }

        changePage(userDetails);
      } else {
        callError(AppLocalizations.of(context)!.fillField);
      }
    } on FirebaseAuthException catch (error) {
      callError(error.message!);
    }*/
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void accountCreated() {
    showSnackBar(context, AppLocalizations.of(context)!.accountCreated);
  }

  void changePage(UserDetails userDetails) {
    context.read<UserProvider>().setData(userDetails, [], []);
    if (widget.isEmailAndPassword) {
      Navigator.of(context).pop();
    } else {
      context.go('/');
    }
  }


  @override
  void initState() {
    super.initState();
    _location.text = context.read<UserProvider>().userDetails.location;
    _phoneNumber.text = context.read<UserProvider>().userDetails.phoneNumber;
    _language = context.read<UserProvider>().userDetails.language;
    _theme = context.read<UserProvider>().userDetails.theme;

  }

  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    isDarkTheme = currentTheme.colorScheme.background == ThemeData.dark(useMaterial3: true).colorScheme.background;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(AppLocalizations.of(context)!.editProfile, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onPrimaryContainer),),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              const SizedBox(
                height: 20,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(width: 12,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.white,
                          backgroundImage: _showImagePreview
                              ? Image.file(File(imageFile?.path ?? ""))
                              .image
                              : NetworkImage(context.read<UserProvider>().userDetails.urlPhotoProfile),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              selectImage();
                            },
                            child: const Text('Select')),

                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              color:
                              Theme.of(context).colorScheme.secondaryContainer),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.preference,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.languageUsed,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        MyApp.setLocale(context, const Locale('it'));
                                        _language = 'it';
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border: AppLocalizations.of(context)
                                              ?.localeName ==
                                              'it'
                                              ? Border.all(
                                              width: 4,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                              : Border.all(color: Colors.transparent),
                                        ),
                                        child: Image.asset(
                                          'assets/images/flags/ita.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        MyApp.setLocale(context, const Locale('en'));
                                        _language = 'en';
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border: AppLocalizations.of(context)
                                              ?.localeName ==
                                              'en'
                                              ? Border.all(
                                              width: 4,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                              : Border.all(color: Colors.transparent),
                                        ),
                                        child: Image.asset(
                                          'assets/images/flags/eng.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(AppLocalizations.of(context)!.currentTheme,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isDarkTheme
                                            ? Border.all(
                                            width: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                            : Border.all(color: Colors.transparent),
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            MyApp.setTheme(context,
                                                ThemeData.dark(useMaterial3: true));
                                            _theme = 'dark';
                                          },
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.moon,
                                              size: 25,
                                              color: isDarkTheme
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSecondaryContainer,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: !isDarkTheme
                                            ? Border.all(
                                            width: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                            : Border.all(color: Colors.transparent),
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            MyApp.setTheme(context,
                                                ThemeData(
                                                    useMaterial3: true,
                                                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)
                                                ));
                                            _theme = 'light';
                                          },
                                          child: Center(
                                            child: FaIcon(FontAwesomeIcons.sun,
                                              size: 25,
                                              color: !isDarkTheme
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSecondaryContainer,),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8,bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)!.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onBackground
                                )
                              ),
                              TextSpan(
                                text: context.read<UserProvider>().userDetails.fullName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary
                                )
                              )
                            ]
                          )),
                          SizedBox(height: 12,),
                          RichText(text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Email: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onBackground
                                )
                              ),
                              TextSpan(
                                text: context.read<UserProvider>().userDetails.email,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.primary
                                  )
                              )
                            ]
                          )),
                          SizedBox(height: 6,),
                          RichText(text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Provider: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onBackground
                                    )
                                ),
                                TextSpan(
                                    text: context.read<UserProvider>().userDetails.provider.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.primary
                                    )
                                )
                              ]
                          )),
                          SizedBox(height: 20,),

                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 50.0,
                                maxWidth: MediaQuery.of(context).size.width,
                                minHeight: 40.0,
                                maxHeight: 40.0),
                            child: TextField(
                              controller: _location,
                              decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.only(left: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  label: Text(AppLocalizations.of(context)!
                                      .choiceLocation)),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 50.0,
                                maxWidth: MediaQuery.of(context).size.width,
                                minHeight: 40.0,
                                maxHeight: 40.0),
                            child: TextField(
                              controller: _phoneNumber,
                              decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.only(left: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  label: Text(AppLocalizations.of(context)!
                                      .addYourPhoneNumber)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),


              OutlinedButton(
                  onPressed: () {
                    updateUser();
                  },
                  child: Text(AppLocalizations.of(context)!.save)),
            ]),
          ),
        ));
  }
}
