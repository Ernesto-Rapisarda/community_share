import 'dart:io';

import 'package:community_share/main.dart';
import 'package:community_share/model/enum/provider.dart';
import 'package:community_share/model/user_details.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/auth.dart';
import 'package:community_share/view/login/components/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../service/image_service.dart';
import '../../utils/show_snack_bar.dart';

class Registration extends StatefulWidget {
  final bool isEmailAndPassword;

  const Registration({super.key, required this.isEmailAndPassword});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
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

  Future<void> createUser() async {
    try {
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
    }
  }

  void callError(String error) {
    showSnackBar(context, error, isError: true);
  }

  void accountCreated() {
    showSnackBar(context, AppLocalizations.of(context)!.accountCreated);
  }

  void changePage(UserDetails userDetails) {
    context.read<UserProvider>().setData(userDetails, [], [],0);
    if (widget.isEmailAndPassword) {
      Navigator.of(context).pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    isDarkTheme = currentTheme.colorScheme.background == ThemeData.dark(useMaterial3: true).colorScheme.background;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 12,
          ),
          const WelcomeWidget(),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (!widget.isEmailAndPassword) {
                  Auth().signOut();
                }
                Navigator.of(context).pop();
              });
            },
            child: Text(
              AppLocalizations.of(context)!.haveAnAccount,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: !widget.isEmailAndPassword
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.signingWithGmail,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              Auth().currentUser!.email!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.credential,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              AppLocalizations.of(context)!.needToBeFilled,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
                                  minHeight: 50.0,
                                  maxHeight: 50.0),
                              child: TextField(
                                controller: _email,
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
                                          color: validEmail
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    label: const Text('* email')),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  bool isValid = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                  ).hasMatch(value);

                                  if (isValid) {
                                    setState(() {
                                      validEmail = true;
                                    });
                                  } else {
                                    setState(() {
                                      validEmail = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
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
                                    label: const Text('* password'),
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
                            !validPassword
                                ? Text(
                                    AppLocalizations.of(context)!.rightPass,
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : const Center(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
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
                                        .repeatPassword),
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
                          ],
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
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
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.infoProfile,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppLocalizations.of(context)!.needToBeFilled,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  : const AssetImage(
                                          'assets/images/user_photos/examples/UserProfileDefault.png')
                                      as ImageProvider<Object>,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  selectImage();
                                },
                                child: const Text('Select')),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
                                  minHeight: 40.0,
                                  maxHeight: 40.0),
                              child: TextField(
                                controller: _fullName,
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
                                        .choiceDisplayedName)),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
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
                              height: 8,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 50.0,
                                  maxWidth: MediaQuery.of(context).size.width *
                                          2 /
                                          3 -
                                      40,
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
                      )
                    ],
                  ),
                ],
              )),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
            height: 8,
          ),
          OutlinedButton(
              onPressed: () {
                createUser();
              },
              child: Text(AppLocalizations.of(context)!.completeRegistration)),
        ]),
      ),
    ));
  }
}
