import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Note/add.dart';
import 'package:flutter_application_1/Note/edit.dart';

class ViewNote extends StatefulWidget {
  final String categoryId;
  const ViewNote({super.key, required this.categoryId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];
  bool loading = true;

  getdata() async {
    try {
      QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("note")
          .get();
      data.addAll(queryDocumentSnapshot.docs);
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
    if (!mounted) {
      return;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  refresh() {
    if (!mounted) return;
    setState(() {
      loading = true;
      data.clear();
    });
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AddNote(docid: widget.categoryId),
                ),
              )
              .then((_) => refresh());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed("Login");
              }
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("Homepage", (route) => false);
          return Future.value(false);
        },
        child: loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  const Text("Loading...."),
                ],
              ),
            )
          : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //عدد العناصر بصف الواحد
                  mainAxisExtent: 160, // طول العناصر يلي داخل ال ال GridView
                  mainAxisSpacing: 10, // المسافة بين الصفوف
                  crossAxisSpacing: 10, // المسافة بين الأعمدة
                ),
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Are you sure',
                        btnOkText: "Cancel",
                        btnCancelText: "Delete",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(widget.categoryId)
                              .collection("note")
                              .doc(data[i].id)
                              .delete();
                          if (mounted) {
                            setState(() {
                              data.removeAt(i);
                            });
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewNote(categoryId: widget.categoryId),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            notedocid: data[i].id,
                            Categorydocid: widget.categoryId,
                            value: data[i]["note"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              data[i]["note"] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
