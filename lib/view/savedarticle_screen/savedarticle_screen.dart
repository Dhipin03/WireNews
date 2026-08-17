import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wirenews/utils/constants/colorconstants.dart';
import 'package:wirenews/view/blog_view_screen/blogView_screen.dart';
import 'package:wirenews/view/home_screen/widgets/newscard_widget.dart';

class SavedarticleScreen extends StatefulWidget {
  const SavedarticleScreen({super.key});

  @override
  State<SavedarticleScreen> createState() => _SavedarticleScreenState();
}

class _SavedarticleScreenState extends State<SavedarticleScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('articles').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Saved Articles',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colorconstants.whitecolor),
        ),
        backgroundColor: Colorconstants.primarycolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colorconstants.whitecolor,
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading saved articles:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No saved articles yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>? ?? {};
              final String url = data['url'] ?? '';
              final String content = data['content'] ?? '';
              final String title = data['title'] ?? 'No Title';
              final String imgurl = data['imgurl'] ?? '';
              final String author = data['author'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogviewScreen(
                          url: url,
                          content: content,
                          title: title,
                          imgurl: imgurl,
                          author: author,
                        ),
                      ),
                    );
                  },
                  child: NewscardWidget(
                    id: doc.id,
                    deletebutton: true,
                    author: author,
                    imgurl: imgurl,
                    title: title,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
