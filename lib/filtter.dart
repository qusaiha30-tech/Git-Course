import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FiltterFireStore extends StatefulWidget {
  const FiltterFireStore({super.key});

  @override
  State<FiltterFireStore> createState() => _FiltterFireStoreState();
}

class _FiltterFireStoreState extends State<FiltterFireStore> {
  bool isloading = false;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots();

  Future<void> addBalance(String docId) async {
    final sfDocRef = FirebaseFirestore.instance.collection("users").doc(docId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(sfDocRef);
        if (!snapshot.exists) return;
        final int balance = (snapshot.data() as Map<String, dynamic>)["Balance"] as int? ?? 0;
        transaction.update(sfDocRef, {"Balance": balance + 100});
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تمت الإضافة +100")),
        );
      }
    } catch (e) {
      debugPrint("addBalance error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filtter")),
      body: isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text("Loading....")],
              ),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: _usersStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text("Loading...."),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () => addBalance(doc.id),
                        child: Card(
                          child: ListTile(
                            title: Text("${data['Username'] ?? 'No Name'}"),
                            subtitle: Text("${data['age'] ?? 0}"),
                            trailing: Text("${data['Balance'] ?? 0}\$"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
