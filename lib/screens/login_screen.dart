import 'package:flutter/material.dart';
import 'package:fox_tales/widgets/atoms/button.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _email = "";
  var _password = "";
  bool _isLoading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (err) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message ?? 'Unknown Authentication Error.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'FoxTales',
                    style: TextStyle(fontFamily: 'Tahu', fontSize: 100),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    width: 100,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    autocorrect: false,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Password too short. Must be 6 characters or more.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Button('Login', _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
