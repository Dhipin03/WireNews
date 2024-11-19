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
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView.separated(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final article = snapshot.data!.docs;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogviewScreen(
                              url: article[index]['url'],
                              content: article[index]['content'],
                              title: article[index]['title'],
                              imgurl: article[index]['imgurl'],
                              author: article[index]['author']),
                        ));
                  },
                  child: NewscardWidget(
                      id: article[index].id,
                      deletebutton: true,
                      author: article[index]['author'],
                      imgurl: article[index]['imgurl'],
                      title: article[index]['title']),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
          );
        },
      ),
    );
  }
}
