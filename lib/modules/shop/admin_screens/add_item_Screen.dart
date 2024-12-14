import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _imageFile; // Store the picked image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Method to pick an image from camera
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        print("it's ok here");
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage
  Future<String> _uploadImage(File image) async {
    // await FirebaseStorage.instance
    //     .ref()
    //     .child('item_images/${DateTime.now().toString()}')
    //     .putFile(image)
    //     .then((value) {
    //       value.ref.getDownloadURL().then((value){
    //         return value;
    //       }).catchError((e){
    //         throw Exception('Failed to download imageUrl: $e');
    //       });
    //
    // }).catchError((e) {
    //       throw Exception('Failed to upload image: $e');
    // });
      try {
       final storageRef = FirebaseStorage.instance.ref().child('item_images/${DateTime.now().toString()}');
       final uploadTask = storageRef.putFile(image);
       final snapshot = await uploadTask.whenComplete(() {});
       final downloadUrl = await snapshot.ref.getDownloadURL();
       return downloadUrl;
     } catch (e) {
       throw Exception('Failed to upload image: $e');
     }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        title: Text('Add Item',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Item Name',
              icon: Icons.label,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: priceController,
              label: 'Price',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descriptionController,
              label: 'Description',
              icon: Icons.description,
              theme: theme,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: theme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      _imageFile == null
                          ? 'Tap to pick an image'
                          : 'Image Selected',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    _imageFile != null) {
                  try {
                    // Upload image to Firebase Storage
                    String imageUrl = await _uploadImage(_imageFile!);

                    // Add item data to Firestore
                    await FirebaseFirestore.instance.collection('items').add({
                      'name': nameController.text,
                      'price': double.parse(priceController.text),
                      'description': descriptionController.text,
                      'image_url': imageUrl,
                      'quantity': 1, // Default quantity
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error uploading image or data: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please fill in all fields and select an image')),
                  );
                }
              },
              child: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required ThemeData theme,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
      ),
    );
  }
}
