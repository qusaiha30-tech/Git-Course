import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/custom_text_form.dart';
import 'package:flutter_application_1/Component/custombotton.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController reset = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_reset, color: Colors.blueAccent, size: 32),
            ),
          ),
          const Text(
            "Reset Password",
            style: TextStyle(
              color: Color(0xFF0F2B48),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Enter Your email and we will send you a reset code",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          SizedBox(height: 12),
          CustomTextForm(
            hinttext: "Enter Your Email",
            obscureText: false,
            title: "Email",
            mycontroller: reset,
            validator: (value) {
              if (value == null) {
                return "This Field is required";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Custombotton(
            text: "Reset Password",
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: reset.text,
                );
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType
                      .success, // يمكن تغيير نوع الأيقونة (success, error, warning, info...)
                  animType: AnimType.scale,
                  title: "",
                  desc:
                      'The Reset Password Link is actuall send, check the mail',

                  // تخصيص الألوان والستايل
                  dialogBackgroundColor: Colors.white,
                  borderSide: const BorderSide(
                    color: Color(0xFF2979FF),
                    width: 1.5,
                  ),

                  // تخصيص زر القبول (matching the app blue color)
                  btnOkText: 'Ok',
                  btnOkColor: const Color(0xFF2979FF),
                  btnOkOnPress: () {},

                  // تخصيص زر الإلغاء
                  btnCancelText: 'Cacel',
                  btnCancelColor: Colors.grey.shade400,
                  btnCancelOnPress: () {},
                ).show();
              } catch (e) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.scale,
                  title: 'Error',
                  desc: e.toString(),
                  btnOkColor: const Color(0xFF2979FF),
                  btnOkText: 'Ok',
                ).show();
              }
            },
          ),
        ],
      ),
    );
  }
}
