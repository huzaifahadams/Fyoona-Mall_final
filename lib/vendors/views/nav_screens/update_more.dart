// update_more_information_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateMoreInformationScreen extends StatefulWidget {
  const UpdateMoreInformationScreen({super.key});

  @override
  _UpdateMoreInformationScreenState createState() =>
      _UpdateMoreInformationScreenState();
}

class _UpdateMoreInformationScreenState
    extends State<UpdateMoreInformationScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reasonController =
      TextEditingController(); // Add this controller for the reason

  // Add more controllers for other fields if needed

  XFile? _logo; // This will store the selected logo file

  Future<void> _selectLogo() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logo = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update More Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _businessNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Add more input fields...

            // Logo selection
            ListTile(
              title: const Text('Select Logo'),
              trailing: const Icon(Icons.image),
              onTap: _selectLogo,
            ),
            _logo != null
                ? Image.file(
                    File(_logo!.path),

                    width: 100, // Set the width of the displayed image
                    height: 100, // Set the height of the displayed image
                    fit: BoxFit.cover,
                  )
                : const Text('')
            // const Placeholder()
            , // Display the selected logo

            TextFormField(
              controller: _reasonController,
              keyboardType: TextInputType.text,
              maxLength: 1000,
              decoration: const InputDecoration(labelText: 'Reason for Change'),
            ),

            ElevatedButton(
              onPressed: () {
                // Implement logic to update more information
                // You can access the values using _businessNameController.text, _locationController.text, _emailController.text, _reasonController.text, etc.
                // Also, use _logo for the selected logo file.
              },
              child: const Text('not working for now'),
            ),
          ],
        ),
      ),
    );
  }
}
