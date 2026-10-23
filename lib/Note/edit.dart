import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Component/CastomTextFormadd.dart';
import 'package:flutter_application_1/Component/custombotton.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String Categorydocid;
  final String value;
  const EditNote({
    super.key,
    required this.notedocid,
    required this.Categorydocid, required this.value,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isloading = false;
  EditNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.Categorydocid)
        .collection("note");
    if (!formstate.currentState!.validate()) {
      return;
    }
    try {
      isloading = true;
      setState(() {});
      await collectionnote.doc(widget.notedocid).update({"note": note.text});
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
  void initState() {
    // TODO: implement initState
    super.initState();
    note.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
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
                      text: "Save",
                      onPressed: () {
                        EditNote();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
