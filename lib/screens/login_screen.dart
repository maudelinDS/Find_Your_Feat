import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_moder.dart';
import 'account_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _isLoading = false;
  late MySqlConnection _connection;
  String? _loggedInUsername;

  @override
  void initState() {
    super.initState();
    _connect();
    // retrieve the user's information
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _loggedInUsername = prefs.getString('loggedInUsername');
      });
    });
  }

  @override
  void dispose() {
    _connection.close();
    super.dispose();
  }

  Future<void> _connect() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'www.delescaut.ch',
      port: 3306,
      user: 'mds_admin_db',
      password: 'm4u23L1n2022',
      db: 'mds_db',
    ));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final result = await _connection.query(
      "SELECT * FROM users WHERE username = ?",
      [_username],
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isNotEmpty) {
      final user = result.first;
      final String hashedPassword = user['mot_de_passe'];

      bool test = await BCrypt.checkpw(_password, hashedPassword);

      if (test == true) {
        setState(() {
          _loggedInUsername = user['username'];
        });
        // login successful

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You are connected"),
            backgroundColor: Colors.green,
          ),
        );

        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        userModel.loggedInUsername = _loggedInUsername;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loggedInUsername', _loggedInUsername!);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserScreen(
              userData: {
                'id': user['id'],
                'username': user['username'],
                'email': user['email'],
                'mot_de_passe': user['mot_de_passe'],
                'creation_date': user['creation_date'],
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid username or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid username or password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  Future<void> _goToUserScreen(String username) async {
    final result = await _connection.query(
      "SELECT * FROM users WHERE username = ?",
      [username],
    );

    if (result.isNotEmpty) {
      final user = result.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(
            userData: {
              'id': user['id'],
              'username': user['username'],
              'email': user['email'],
              'mot_de_passe': user['mot_de_passe'],
              'creation_date': user['creation_date'],
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Login"),
        actions: [
          Text(
            _loggedInUsername == null
                ? "Not logged in"
                : " ${_loggedInUsername!}",
            style: const TextStyle(fontSize: 16.0),
          ),
          SizedBox(width: 16),
          if (_loggedInUsername != null)
            InkWell(
              child: Text(
                _loggedInUsername!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () => _goToUserScreen(_loggedInUsername!),
            )
        ],
      ),
      body: Stack(
        children: [
          const _BackgroundFilter(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(labelText: "username"),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter an username";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Password"),
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a password";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            child: const Text("Login"),
                            onPressed: _submitForm,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.deepPurple),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            child: const Text("Create Account"),
                            onPressed: _goToRegisterPage,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.deepPurple),
                            ),
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
              Colors.deepPurple,
              Colors.deepPurple.shade600.withOpacity(0.0),
              Colors.deepPurple.shade100.withOpacity(0.0),
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
