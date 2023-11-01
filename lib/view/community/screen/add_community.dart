import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  CommunityType _communityType = CommunityType.undefined;
  String _imageUrl = 'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

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
    Community community = Community(
      name: _nameController.text,
      description: _descriptionController.text,
      locationSite: _locationController.text,
      urlLogo: _imageUrl,
      type: _communityType,
      founder: context.read<UserProvider>().getUserBasic()
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
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_imageUrl),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Select Image'),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Community Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              Row(
                children: <Widget>[
                  Text('Community Type: '),
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
                        child: Text(type.toString().split('.')[1]),
                      );
                    }).toList(),
                  ),
                ],
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