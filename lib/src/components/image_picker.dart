import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(File imageFile);

class ImagePickerWidget extends StatelessWidget {
  final File imageFile;
  final OnImageSelected onImageSelected;
  ImagePickerWidget({@required this.imageFile, @required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff4dd0e1),
                Color(0xff00838f),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile), fit: BoxFit.cover)
                : null),
        child: IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            _showPickerOptions(context);
          },
          iconSize: 90,
          color: Colors.white,
        ));
  }

  void _showPickerOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              ListTile(
                title: Text("Cámara"),
                leading: Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  _showPickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Galería"),
                leading: Icon(Icons.image),
                onTap: () {
                  Navigator.pop(context);
                  _showPickImage(context, ImageSource.gallery);
                },
              )
            ],
          );
        });
  }

  void _showPickImage(BuildContext context, source) async {
    var image = await ImagePicker.pickImage(source: source);
    this.onImageSelected(image);
  }
}
