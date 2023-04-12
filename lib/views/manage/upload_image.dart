// ignore_for_file: library_private_types_in_public_api

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MultiImageUploadScreen extends StatefulWidget {
  const MultiImageUploadScreen({super.key});

  @override
  _MultiImageUploadScreenState createState() => _MultiImageUploadScreenState();
}

class _MultiImageUploadScreenState extends State<MultiImageUploadScreen> {
  List<AssetEntity> _images = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _selectImages(),
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Center(
                child: Text(
                  'Choose Image',
                  style: GoogleFonts.readexPro(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _images.isEmpty
                    ? const Text('')
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<File?>(
                            future: _images[index].file,
                            builder: (BuildContext context,
                                AsyncSnapshot<File?> snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image.file(
                                    snapshot.data!,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Error loading image');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImages() async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
    setState(() {
      _images = result!;
    });
  }

  Future<void> uploadImages() async {
    setState(() {
      _isLoading = true;
    });
    final storage = FirebaseStorage.instance;
    for (var asset in _images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images').child(fileName);
      final File? file = await asset.file;
      if (file != null) {
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() => null);
        String imageUrl = await reference.getDownloadURL();
        print('Uploaded image: $imageUrl');
        // rest of the code here
      } else {
        // handle error, e.g. file is null
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
