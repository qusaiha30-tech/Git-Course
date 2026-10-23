import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/custom_text_form.dart';
import 'package:flutter_application_1/Component/custombotton.dart';
import 'package:flutter_application_1/Component/logoauth.dart';
import 'package:flutter_application_1/Component/sign_in_method.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize();
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Logoauth(),
                    const SizedBox(height: 10),
                    const Text(
                      "SignUp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create A New Account To Continue Using The App",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    CustomTextForm(
                      hinttext: "Enter your userName",
                      mycontroller: userName,
                      title: "userName",
                      obscureText: false,
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextForm(
                      kekeyboardtype: TextInputType.emailAddress,
                      hinttext: "Enter your Email",
                      mycontroller: email,
                      title: "Email",
                      obscureText: false,
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(p1)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextForm(
                      kekeyboardtype: TextInputType.visiblePassword,
                      obscureText: true,
                      suffixIcon: Icons.remove_red_eye_rounded,
                      hinttext: "Enter your Password",
                      mycontroller: password,
                      title: "Password",
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        if (p1.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextForm(
                      kekeyboardtype: TextInputType.visiblePassword,
                      obscureText: true,
                      suffixIcon: Icons.remove_red_eye_rounded,
                      hinttext: "Re-enter your Password",
                      mycontroller: confirmPassword,
                      title: "Confirm Password",
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        if (p1 != password.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Custombotton(
                text: "SignUp",
                onPressed: () async {
                  if (!formstate.currentState!.validate()) {
                    return;
                  }
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text,
                        );

                    User? user = userCredential.user;

                    if (user != null) {
                      // 1. Reload user state to check the latest emailVerified status
                      await user.reload();
                      user = FirebaseAuth.instance.currentUser;

                      // 2. If email is not verified
                      if (!user!.emailVerified) {
                        if (!context.mounted) return;

                        // Show AwesomeDialog in English
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.scale,
                          title: 'Email Verification Required',
                          desc:
                              'Your account is not verified yet. Tap "Send Link" to receive a verification email, then tap "I\'ve Verified" once done.',
                          btnOkText: 'Send Link',
                          btnCancelText: 'I\'ve Verified',
                          btnOkOnPress: () async {
                            // Send email verification link
                            await user?.sendEmailVerification();
                            showMessage(
                              'Verification email sent! Please check your inbox.',
                            );
                          },
                          btnCancelOnPress: () async {
                            // Reload and check again when user clicks "I've Verified"
                            await user?.reload();
                            User? updatedUser =
                                FirebaseAuth.instance.currentUser;

                            if (updatedUser != null &&
                                updatedUser.emailVerified) {
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                "Homepage",
                                (route) => false,
                              );
                            } else {
                              showMessage(
                                'Email is not verified yet. Please check your inbox.',
                              );
                            }
                          },
                        ).show();

                        return; // Prevent navigating to Homepage until verified
                      }
                    }

                    if (!context.mounted) return;

                    // 3. Navigate directly to Homepage if email is already verified
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
              ),
              const SizedBox(height: 20),
              const Text(
                "OR SignUp With",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
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
                        showMessage('Google signup failed: $e');
                      }
                    },
                  ),
                  Signinmethod(imagePath: "images/apple.jpeg", onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil("Login", (route) => false);
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: "Already Have An Account ? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "Login",
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
