import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Categories/edit.dart';
import 'package:flutter_application_1/Note/view.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];
  bool loading = true;

  getdata() async {
    try {
      QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
          .collection("categories")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed("addCategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("HomePage"),
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
      body: loading
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewNote(categoryId: data[i].id),
                      ),
                    );
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'What Do You Want',
                      btnOkText: "Update",
                      btnCancelText: "Delete",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("categories")
                            .doc(data[i].id)
                            .delete();
                        if (mounted) {
                          setState(() {
                            data.removeAt(i);
                          });
                        }
                      },
                      btnOkOnPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCategory(
                              docid: data[i].id,
                              oldname: data[i]["name"],
                            ),
                          ),
                        );
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "images/folder.jpeg",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data[i]["name"] ?? "",
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
    );
  }
}
