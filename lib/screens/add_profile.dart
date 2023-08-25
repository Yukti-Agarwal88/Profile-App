import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_app/controller/profile_controller.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/repository/user_repo.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // return const AddUserDialog();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Profiles'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<UserModel>>(
          future: controller.getAllUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // UserModel userData = snapshot.data as UserModel;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (c, index) {
                    return Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            trailing: const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            iconColor: Colors.blue,
                            leading: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                buildProfileImage(),
                                buildActiveDot(snapshot.data![index].status),
                              ],
                            ),
                            title: Text(
                              snapshot.data![index].fullName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].occupation,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                                // Text(snapshot.data![index].photoUrl),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.mail,
                                      size: 20,
                                      color: Color.fromARGB(255, 83, 81, 79),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data![index].email,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 83, 81, 79),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_city,
                                      size: 20,
                                      color: Color.fromARGB(255, 83, 81, 79),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data![index].country,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 83, 81, 79),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data![index].status == '0'
                                      ? 'Active now'
                                      : 'Logged in ${snapshot.data![index].status} mins ago',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong!'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open dialog to add user
          showDialog(
            context: context,
            builder: (context) => const AddUserDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildProfileImage() {
    return const CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage('https://picsum.photos/id/237/200/300'),
    );
  }

  Widget buildActiveDot(statusVal) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: statusVal == '0' ? Colors.green : Colors.grey,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final repoUser = Get.put(UserRepo());

  Future<void> createUser(UserModel user) async {
    await repoUser.createUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        //   height: 230,
        //   width: Get.width,
        //   child:
        Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // title: const Text("Add User"),
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
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Colors.blue),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name")),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email")),
                TextField(
                    controller: photoController,
                    decoration: const InputDecoration(labelText: "Photo URL")),
                TextField(
                    controller: occupationController,
                    decoration: const InputDecoration(labelText: "Occupation")),
                TextField(
                    controller: placeController,
                    decoration: const InputDecoration(labelText: "Place")),
                TextField(
                    controller: statusController,
                    decoration: const InputDecoration(labelText: "Status")),
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
                              photoUrl: photoController.text.trim(),
                              status: statusController.text.trim());

                          createUser(user);
                        }
                        // Save user data to Firebase
                        // widget.databaseReference.push().set({
                        //   "name": nameController.text,
                        //   "email": emailController.text,
                        //   "photoUrl": photoController.text,
                        //   "occupation": occupationController.text,
                        //   "place": placeController.text,
                        // });

                        Navigator.of(context).pop();
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
