import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_moder.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _loggedInUsername;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUsername();
  }

  Future<void> _loadLoggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('loggedInUsername');
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.loggedInUsername = username;
    setState(() {
      _loggedInUsername = username;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedInUsername');
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.loggedInUsername = null;
    setState(() {
      _loggedInUsername = null;
    });
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Profile Page: ${widget.userData['username']}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Text('Other Page'),
          ),
        ],
      ),
      body: Stack(
        children: [
          _BackgroundFilter(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Card(
              elevation: 8.0,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Id:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          '${widget.userData['id']}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Text(
                          'Username:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.userData['username']}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Text(
                          'Email:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.userData['email']}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12.0),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Password:',
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 12.0,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       '${widget.userData['mot_de_passe']}',
                    //       style: TextStyle(color: Colors.black),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Text(
                          'Creation date : ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.userData['creation_date']}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Text(
                          'Logged in as :',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_loggedInUsername != null)
                          Text(
                            '$_loggedInUsername',
                            style: TextStyle(color: Colors.black),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200.withOpacity(0.8),
              Colors.deepPurple.shade800.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }
}
