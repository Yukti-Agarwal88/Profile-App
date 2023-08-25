import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:profile_app/screens/add_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AddProfile(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final databaseReference = FirebaseDatabase.instance.reference().child("users");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User List")),
//       body: StreamBuilder(
//         stream: databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();

//           Map<dynamic, dynamic> usersMap = snapshot.data.snapshot.value;
//           List<User> users = [];

//           if (usersMap != null) {
//             usersMap.forEach((key, value) {
//               users.add(User.fromSnapshot(DataSnapshot(value)));
//             });
//           }

//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: CircleAvatar(backgroundImage: NetworkImage(users[index].photoUrl)),
//                 title: Text(users[index].name),
//                 subtitle: Text(users[index].email),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Open dialog to add user
//           showDialog(
//             context: context,
//             builder: (context) => AddUserDialog(databaseReference),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

