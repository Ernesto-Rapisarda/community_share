import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/service/community_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../model/address.dart';
import '../../../model/community.dart';
import '../../../model/enum/community_type.dart';
import '../../../providers/community_provider.dart';
import '../../../service/image_service.dart';

class AddCommunity extends StatefulWidget {
  final bool isEdit;

  const AddCommunity({Key? key, required this.isEdit}) : super(key: key);

  @override
  State<AddCommunity> createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  CommunityType _communityType = CommunityType.undefined;
  String _imageUrl =
      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      // Se si sta modificando, popola i campi con i dati della community esistente
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

  void _saveCommunity() {
    Address address = Address(
      streetName: _streetNameController.text,
      streetNumber: _streetNumberController.text,
      postalCode: _postalCodeController.text,
      city: _cityController.text,
    );

    Community community = Community(
      id: widget.isEdit ?context.read<CommunityProvider>().community.id :IdGenerator.generateUniqueCommunityId(),
      name: _nameController.text,
      description: _descriptionController.text,
      urlLogo: _imageUrl,
      members: widget.isEdit ?context.read<CommunityProvider>().community.members : 1,
      type: _communityType,
      founder: context.read<UserProvider>().getUserBasic(),
      hotSpotAddress: address,

    );
    if(widget.isEdit){
      community.docRef = context.read<CommunityProvider>().community.docRef;
      CommunityService().updateCommunity(context, community);
    }
    else{
      CommunityService().createCommunity(context, community);

    }

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
          padding: EdgeInsets.only(left: 12.0, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
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
                    Positioned(
                        bottom: 0,
                        left: 100,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.background
                          ),
                          child: IconButton(
                            onPressed: () {
                              _selectImage;
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 24,
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                          ),
                        ))
                  ],
                ),
              ),

              SizedBox(height: 10),

/*              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Select Image'),
              ),*/
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Community Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
              SizedBox(
                height: 22,
              ),
              Text(
                'Address: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              //Text('Used for the transactions between members',style: TextStyle(fontSize: 14),),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Theme.of(context).colorScheme.primary;
                            }
                            return Theme.of(context)
                                .colorScheme
                                .primaryContainer;
                          },
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer))),
                    onPressed: _saveCommunity,
                    child: Text('Save Community'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
