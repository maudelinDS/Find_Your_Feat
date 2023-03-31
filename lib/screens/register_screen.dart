import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class RegisterScreen extends StatefulWidget {
  static late String variableStatic;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _password;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'www.delescaut.ch',
      port: 3306,
      user: 'mds_admin_db',
      password: 'm4u23L1n2022',
      db: 'mds_db',
    ));

    try {
      final hashedPassword = await hashPassword(_password);
      RegisterScreen.variableStatic = hashedPassword;

      final result = await conn.query(
        'SELECT * FROM users WHERE username = ? OR email = ?',
        [_name, _email],
      );

      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Username or email already exists',
                style: TextStyle(color: Colors.white),
              )),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await conn.query(
        'INSERT INTO users (username, email, mot_de_passe) VALUES (?, ?, ?)',
        [_name, _email, hashedPassword],
      );
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'User added successfully',
              style: TextStyle(color: Colors.white),
            )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: $e')),
      );
    } finally {
      await conn.close();
    }
  }

  Future<String> hashPassword(String password) async {
    const saltRounds = 10;
    final String hashedPassword =
        await BCrypt.hashpw(password, BCrypt.gensalt(logRounds: saltRounds));
    RegisterScreen.variableStatic = hashedPassword;
    return hashedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Add User',
        ),
      ),
      body: Stack(
        children: [
          _BackgroundFilter(),
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
                            decoration: InputDecoration(labelText: 'Name'),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            child: Text('Add User'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepPurple.shade600),
                            ),
                            onPressed: _submitForm,
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
