import 'package:flutter/material.dart';
import 'package:fox_tales/services/image_service.dart';
import 'package:fox_tales/widgets/atoms/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fox_tales/data/colors.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() {
    return _UploadScreenState();
  }
}

class _UploadScreenState extends State<UploadScreen> {
  final _descriptionController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
    });
  }

  void _uploadImage() async {
    if (_image == null) return;
    setState(() {
      _isLoading = true;
    });

    uploadImage('public_feed', _image!, _descriptionController.text);

    setState(() {
      _isLoading = false;
    });

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Upload new Image'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: InkWell(
                    onTap: _pickImage,
                    child: _image == null
                        ? const Icon(Icons.image_search,
                            size: 50, color: primary)
                        : Image.file(_image!, fit: BoxFit.contain),
                  )),
              SizedBox(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  controller: _descriptionController,
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Button('Upload Image', _uploadImage)
            ],
          ),
        ),
      ),
    );
  }
}
