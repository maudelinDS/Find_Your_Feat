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

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

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
      await conn.query(
        'INSERT INTO users (username, email, mot_de_passe) VALUES (?, ?, ?)',
        [_name, _email, hashedPassword],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
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
    //final salt = await genSalt(saltRounds);
    final String hashedPassword = BCrypt.hashpw('password', BCrypt.gensalt());
    RegisterScreen.variableStatic = hashedPassword;
    return hashedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade600,
        title: Text(
          'Add User',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurple.shade600),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
