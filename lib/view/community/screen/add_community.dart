import 'dart:io';

import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/address.dart';
import '../../../model/community.dart';
import '../../../model/enum/community_type.dart';
import '../../../providers/community_provider.dart';
import '../../../service/image_service.dart';

class AddCommunity extends StatefulWidget {
  final bool isEdit;

  const AddCommunity({super.key, required this.isEdit});

  @override
  State<AddCommunity> createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  late double _screenSize;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  CommunityType _communityType = CommunityType.undefined;
  String _imageUrl =
      "https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg";

  File? _selectedPdf;
  bool verified = false;

  void _selectPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedPdf = File(result.files.single.path!);
      });
    }

  }

  Future<bool> _uploadPdf() async {
    if (_selectedPdf != null) {
      String? pdfUrl = await ImageService().uploadPdf(_selectedPdf!);
      if (pdfUrl != null) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      Community community = context.read<CommunityProvider>().community;
      _nameController.text = community.name;
      _descriptionController.text = community.description;
      _streetNameController.text = community.hotSpotAddress.streetName;
      _streetNumberController.text = community.hotSpotAddress.streetNumber;
      _postalCodeController.text = community.hotSpotAddress.postalCode;
      _cityController.text = community.hotSpotAddress.city;
      _communityType = community.type;
      _imageUrl = community.urlLogo;
    }
  }

  void _selectImage() async {
    XFile? imageFile = await ImageService().pickImage(ImageSource.gallery);
    if (imageFile != null) {
      String? imageUrl = await ImageService().uploadImage(imageFile);
      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    }
  }

  void _saveCommunity() async{
    Address address = Address(
      streetName: _streetNameController.text,
      streetNumber: _streetNumberController.text,
      postalCode: _postalCodeController.text,
      city: _cityController.text,
    );

    verified = await _uploadPdf();

    Community community = Community(
      id: widget.isEdit
          ? context.read<CommunityProvider>().community.id
          : IdGenerator.generateUniqueCommunityId(),
      name: _nameController.text,
      description: _descriptionController.text,
      urlLogo: _imageUrl,
      members: widget.isEdit
          ? context.read<CommunityProvider>().community.members
          : 1,
      type: _communityType,
      founder: context.read<UserProvider>().getUserBasic(),
      hotSpotAddress: address,
      verified: verified
    );
    if (widget.isEdit) {
      community.docRef = context.read<CommunityProvider>().community.docRef;
      CommunityService().updateCommunity(context, community);
    } else {
      CommunityService().createCommunity(context, community);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size.width - 36;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.addCommunity,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context)!.colorScheme.onPrimaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'LOGO',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer),
                              ),
                            )),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: _screenSize / 3,
                          height: _screenSize / 9 * 4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_imageUrl),
                              )),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        OutlinedButton(
                            onPressed:
                              _selectImage
                            ,
                            child: Text(AppLocalizations.of(context)!.select)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  AppLocalizations.of(context)!.info,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText:
                                    AppLocalizations.of(context)!.communityName,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: _descriptionController,
                            maxLength: 200,
                            maxLines: null,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                labelText:
                                    AppLocalizations.of(context)!.description),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  //color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(children: <Widget>[
                              SizedBox(width: 4, ),
                              Text(
                                AppLocalizations.of(context)!.type,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.primary),
                              ),
                              DropdownButton<CommunityType>(
                                value: _communityType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _communityType = newValue!;
                                  });
                                },
                                items: CommunityType.values.map((type) {
                                  return DropdownMenuItem<CommunityType>(
                                    value: type,
                                    child: Text(communityTypeToString(type, context)),
                                  );
                                }).toList(),
                              ),
                            ]),
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      AppLocalizations.of(context)!.addressProductChange,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                  )),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _streetNameController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                          labelText: AppLocalizations.of(context)!.streetName),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _streetNumberController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                          labelText:
                              AppLocalizations.of(context)!.streetNumber),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                          labelText: AppLocalizations.of(context)!.postalCode),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                          labelText: AppLocalizations.of(context)!.city),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Text(AppLocalizations.of(context)!.uploadForVerified),
            ),
            //todo
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Text(
                    'Uploaded File: ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(_selectedPdf!=null ?_selectedPdf!.path.split('/').last  :'Nessun file selezionato', overflow: TextOverflow.ellipsis, maxLines: 1,),
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                  )),
                  OutlinedButton(
                      onPressed: _selectPdf,
                      child: Text(AppLocalizations.of(context)!.select)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed:
                    _showSummaryDialog
                    ,
                    child: Text(
                      AppLocalizations.of(context)!.create,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.summary),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _screenSize / 3,
                height: _screenSize / 9 * 4,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2),
                    borderRadius:
                    BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_imageUrl),
                    )),
              ),
              Text('${_nameController.text}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              SizedBox(height: 8,),
              Text('${_descriptionController.text}'),
              SizedBox(height: 8,),
              Text('${AppLocalizations.of(context)!.addressProductChange}:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              Text('${_streetNameController.text}, ${_streetNumberController.text}'),
              Text('${_postalCodeController.text}, ${_cityController.text}'),

              SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.confirmMessage,style: TextStyle(fontSize: 18),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog senza salvare
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
                _saveCommunity(); // Salva la community
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }
}
