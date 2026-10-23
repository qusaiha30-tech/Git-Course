import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/CastomTextFormadd.dart';
import 'package:flutter_application_1/Component/custombotton.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isloading = false;
  addNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docid)
        .collection("note");
    if (!formstate.currentState!.validate()) {
      return;
    }
    try {
      isloading = true;
      setState(() {});
      await collectionnote.add({"note": note.text});
    } catch (e) {
      isloading = false;
      setState(() {});
      debugPrint("Error $e");
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Form(
        key: formstate,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: isloading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    CustomTextFormAdd(
                      hinttext: "Enter Your Note",
                      mycontroller: note,
                      title: "Note",
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
                        addNote();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
