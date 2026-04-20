import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import 'input_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Gender? selectedGender;
  File? profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _proceedToCalculator() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your gender to continue'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InputPage(
          preSelectedGender: selectedGender,
          profileImage: profileImage,
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: Color(0xFF1B5E7E),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.white),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.image, color: Colors.white),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              if (profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      profileImage = null;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2F51),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF8D8E98),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'BMI CALCULATOR',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Gender Selection
              Column(
                children: [
                  Text(
                    'Select Your Gender',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = Gender.male;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: selectedGender == Gender.male
                                  ? Color(0xFF1B5E7E)
                                  : Color(0xFF1A2637),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: selectedGender == Gender.male
                                    ? Color(0xFFEB1555)
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.user,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'MALE',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = Gender.female;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: selectedGender == Gender.female
                                  ? Color(0xFF1B5E7E)
                                  : Color(0xFF1A2637),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: selectedGender == Gender.female
                                    ? Color(0xFFEB1555)
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.female,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'FEMALE',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Photo Section
              Column(
                children: [
                  Text(
                    'Upload Your Photo',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  if (profileImage != null)
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: FileImage(profileImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF1A2637),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0xFF8D8E98),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 50.0,
                            color: Color(0xFF8D8E98),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'No photo selected',
                            style: TextStyle(
                              color: Color(0xFF8D8E98),
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showPhotoOptions,
                          icon: Icon(Icons.camera),
                          label: Text('Upload Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1B5E7E),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              profileImage = null;
                            });
                          },
                          child: Text('Skip'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8D8E98),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Continue Button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    bool isHovered = false;
                    return MouseRegion(
                      onEnter: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: GestureDetector(
                        onTap: _proceedToCalculator,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Color(0xFF2196F3)
                                : Color(0xFF1B5E7E),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF2196F3).withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
