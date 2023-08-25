import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_app/controller/profile_controller.dart';
import 'package:profile_app/model/user_model.dart';
import 'package:profile_app/screens/user_dialog.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
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
                                buildProfileImage(snapshot.data![index].photoUrl
                                        .contains('https')
                                    ? snapshot.data![index].photoUrl
                                    : 'https://picsum.photos/id/237/200/300'),
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
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: snapshot.data![index].status == '0'
                                          ? Colors.green
                                          : Colors.grey,
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

  Widget buildProfileImage(photoUrl) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(photoUrl),
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
