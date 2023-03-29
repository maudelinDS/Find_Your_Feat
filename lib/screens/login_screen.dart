import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:mysql1/mysql1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late String? _username;
  late String? _password;
  bool isLoggedIn = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      _username = _usernameController.text.trim();
    });

    _passwordController.addListener(() {
      _password = _passwordController.text.trim();
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'www.delescaut.ch',
      port: 3306,
      user: 'mds_admin_db',
      password: 'm4u23L1n2022',
      db: 'mds_db',
    ));

    try {
      // Vérifier l'utilisateur dans la base de données
      if (_username == null || _password == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid username and password')),
        );
        return;
      }
      print('username: $_username');
      print('password: $_password');
      final results = await conn.query(
        'SELECT * FROM users WHERE username = ?',
        [_username],
      );

      if (results.isNotEmpty) {
        final user = results.first;
        final hashedPassword = user['mot_de_passe'];
        // Vérifier le mot de passe hashé
        print(hashedPassword);
        print('password entered: $_password');
        if (BCrypt.checkpw(_password ?? '', hashedPassword)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User log successfully')),
          );
          isLoggedIn = true;

          // ...
        } else {
          // Mot de passe invalide, afficher un message d'erreur
          isLoggedIn = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } else {
        // Adresse e-mail invalide, afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in: $e')),
      );
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade600,
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              style: TextStyle(color: Colors.black),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid username ';
                }
                return null;
              },
              onSaved: (value) {
                _username = value!;
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
            const SizedBox(height: 16.0),
            ElevatedButton(
                child: Text('Login'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurple.shade600),
                ),
                onPressed: () async {
                  await _submitForm();
                }
                //onPressed: _submitForm,
                ),
            SizedBox(height: 16.0),
            TextButton(
              child: Text(
                'Create a Account',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepPurple.shade600),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
