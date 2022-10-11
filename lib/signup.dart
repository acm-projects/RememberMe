import 'package:flutter/material.dart';
import 'login-signup.dart';
import 'package:rememberme/services/authservice.dart';

class SignUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  late String _name, _email ,_password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(hintText: 'Name'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: ((value) => _name = value!),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Email'),
                      obscureText: true,
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
                      child: const Text('Sign Up'),
                    ),

                  ],
                ),
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
    //ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FutureBuilder<String?>(
          future: AuthService.signup(_name, _email, _password),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return const Text('Signed in!');
              } else {
                return Text(snapshot.data!);
              }
            } else {
              return const Text('Signing in...');
            }
          },
        ),
      //),
    );
  }
}