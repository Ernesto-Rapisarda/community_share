import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../model/address.dart';
import '../../../model/community.dart';
import '../../../model/enum/community_type.dart';
import '../../../service/image_service.dart';

class AddCommunity extends StatefulWidget{
  const AddCommunity({super.key});

  @override
  State<AddCommunity> createState() => _AddCommunity();
  
}

class _AddCommunity extends State<AddCommunity>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  CommunityType _communityType = CommunityType.undefined;
  String _imageUrl =
      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

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

  void _saveCommunity() {
    Address address = Address(
      streetName: _streetNameController.text,
      streetNumber: _streetNumberController.text,
      postalCode: _postalCodeController.text,
      city: _cityController.text,
    );

    Community community = Community(
      id: IdGenerator.generateUniqueCommunityId(),
      name: _nameController.text,
      description: _descriptionController.text,
      locationSite: _locationController.text,
      urlLogo: _imageUrl,
      members: 1,
      type: _communityType,
      founder: context.read<UserProvider>().getUserBasic(),
      hotSpotAddress: address,
    );

    CommunityService().createCommunity(context, community);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Community'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ... (codice rimanente rimane invariato)
              TextField(
                controller: _streetNameController,
                decoration: InputDecoration(labelText: 'Street Name'),
              ),
              TextField(
                controller: _streetNumberController,
                decoration: InputDecoration(labelText: 'Street Number'),
              ),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveCommunity,
                child: Text('Save Community'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}