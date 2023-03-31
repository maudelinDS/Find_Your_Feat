import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'id : ${widget.userData['id']}',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Username : ${widget.userData['username']}',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Email : ${widget.userData['email']}',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Password : ${widget.userData['mot_de_passe']}',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Creation date : ${widget.userData['creation_date']}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
