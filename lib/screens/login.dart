import 'package:flutter/material.dart';
import 'package:rememberme/services/authservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                        onSaved: ((value) => _email = value!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onSaved: ((value) => _password = value!),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Updates _email and _password
                            _formKey.currentState!.save();
                            _submit();
                          }
                        },
                        child: const Text('Log In'),
                      ),
                    ]),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FutureBuilder<String?>(
          future: AuthService.login(_email, _password),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return const Text('Logged in!');
              } else {
                return Text(snapshot.data!);
              }
            } else {
              return const Text('Logging in...');
            }
          },
        ),
      ),
    );
  }
}