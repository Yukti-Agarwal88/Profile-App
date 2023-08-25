import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/repository/user_repo.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final repoUser = Get.put(UserRepo());

  Future<void> createUser(UserModel user) async {
    await repoUser.createUser(user);
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://picsum.photos/id/237/200/300'),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            print(file!.path);

                            if (file == null) return;

                            String uniqueFileName = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            Reference referenceImageToUpload =
                                referenceDirImages.child(uniqueFileName);
                            try {
                              await referenceImageToUpload
                                  .putFile(File(file.path));
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (error) {}
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                color: Colors.blue),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", hintText: 'Enter your name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email", hintText: 'Enter your e-mail'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    }
                    final RegExp emailRegex =
                        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: occupationController,
                  decoration: const InputDecoration(
                      labelText: "Occupation",
                      hintText: 'Enter your Occupation'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Occupation/Designation';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(
                      labelText: "Country", hintText: 'Enter your Country'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: statusController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Log-In Time (in mins)",
                      hintText: 'Enter your log-in time'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter numbers for your time';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final user = UserModel(
                              fullName: nameController.text.trim(),
                              occupation: occupationController.text.trim(),
                              email: emailController.text.trim(),
                              country: placeController.text.trim(),
                              photoUrl: imageUrl,
                              status: statusController.text.trim());

                          createUser(user);
                        }
                      },
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
