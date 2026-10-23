import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/CastomTextFormadd.dart';
import 'package:flutter_application_1/Component/custombotton.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  CollectionReference catigories = FirebaseFirestore.instance.collection(
    "categories",
  );
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryController.text = widget.oldname;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryController.dispose();
  }

  editCategory() async {
    if (!formstate.currentState!.validate()) {
      return;
    }
    try {
      isloading = true;
      setState(() {});
      await catigories.doc(widget.docid).set({
        "name": categoryController.text,
        "id": FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      isloading = false;
      setState(() {});
      debugPrint("Error $e");
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Category")),
      body: Form(
        key: formstate,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: isloading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    CustomTextFormAdd(
                      hinttext: "Enter Category Name",
                      mycontroller: categoryController,
                      title: "Name",
                      validator: (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return "This Field is required";
                        }
                        return null;
                      },
                      obscureText: false,
                    ),
                    Custombotton(
                      text: "Save",
                      onPressed: () {
                        editCategory();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
