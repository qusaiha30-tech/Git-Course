import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/custom_text_form.dart';
import 'package:flutter_application_1/Component/custombotton.dart';
import 'package:flutter_application_1/Component/logoauth.dart';
import 'package:flutter_application_1/Component/sign_in_method.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isloading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    await GoogleSignIn.instance.initialize();
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading? CircularProgressIndicator()
      : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Form(
                key: formstate,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Logoauth(),
                    SizedBox(height: 10),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "Login To Continue Using The App",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),

                    SizedBox(height: 20),
                    CustomTextForm(
                      hinttext: "Enter your Email",
                      mycontroller: email,
                      title: "Email",
                      obscureText: false,
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextForm(
                      hinttext: "Enter your password",
                      mycontroller: password,
                      title: "Password",
                      obscureText: true,
                      kekeyboardtype: TextInputType.visiblePassword,
                      suffixIcon: Icons.remove_red_eye_outlined,
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("forget");
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Custombotton(
                onPressed: () async {
                  if (!formstate.currentState!.validate()) {
                    return;
                  }
                  try {
                    isloading = true;
                    setState(() {});
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text.trim(),
                      password: password.text,
                    );
                    isloading = false;
                    setState(() {});
                    if (!context.mounted) return;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil("Homepage", (route) => false);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showMessage('No user found for that email.');
                    } else if (e.code == 'wrong-password' ||
                        e.code == 'invalid-credential') {
                      showMessage('Wrong email or password.');
                    } else if (e.code == 'invalid-email') {
                      showMessage('The email address is invalid.');
                    } else {
                      showMessage(e.message ?? 'Login failed.');
                    }
                  } catch (e) {
                    showMessage('An error occurred. Please try again.');
                  }
                },
                text: "Login",
              ),
              const SizedBox(height: 20),
              const Text(
                "OR Login With",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Signinmethod(imagePath: "images/facebook.jpeg", onTap: () {}),
                  Signinmethod(
                    imagePath: "images/google.jpeg",
                    onTap: () async {
                      try {
                        await signInWithGoogle();
                        if (!context.mounted) return;
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil("Homepage", (route) => false);
                      } catch (e) {
                        showMessage('Google login failed: $e');
                      }
                    },
                  ),
                  Signinmethod(imagePath: "images/apple.jpeg", onTap: () {}),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil("Sign up", (route) => false);
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't Have An account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
