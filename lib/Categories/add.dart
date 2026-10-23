import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/CastomTextFormadd.dart';
import 'package:flutter_application_1/Component/custombotton.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  CollectionReference catigories = FirebaseFirestore.instance.collection(
    "categories",
  );
  bool isloading = false;
  addCategory() async {
    if (!formstate.currentState!.validate()) {
      return;
    }
    try {
      isloading = true;
      setState(() {});
      await catigories.add({"name": categoryController.text});
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
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
                      text: "Add",
                      onPressed: () {
                        addCategory();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
