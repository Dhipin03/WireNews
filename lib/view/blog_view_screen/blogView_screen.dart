import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wirenews/controller/home_screen_controller.dart';
import 'package:wirenews/utils/constants/colorconstants.dart';
import 'package:wirenews/utils/constants/image_constants.dart';

class BlogviewScreen extends StatefulWidget {
  String imgurl;
  String title;
  String content;
  String author;
  String url;
  BlogviewScreen(
      {super.key,
      required this.content,
      required this.title,
      required this.imgurl,
      required this.author,
      required this.url});

  @override
  State<BlogviewScreen> createState() => _BlogviewScreenState();
}

class _BlogviewScreenState extends State<BlogviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          context.watch<HomeScreenController>().issaved
              ? Icon(
                  Icons.bookmark_added_outlined,
                  color: Colorconstants.whitecolor,
                )
              : IconButton(
                  onPressed: () {
                    context.read<HomeScreenController>().saveArticle(
                        url: widget.url,
                        imgurl: widget.imgurl,
                        title: widget.title,
                        content: widget.content,
                        author: widget.author);
                    context.read<HomeScreenController>().savearticle(true);
                  },
                  icon: Icon(
                    Icons.bookmark_outline,
                    color: Colorconstants.whitecolor,
                  )),
          IconButton(
              onPressed: () {
                context.read<HomeScreenController>().shareArticles(widget.url);
              },
              icon: Icon(
                Icons.share,
                color: Colorconstants.whitecolor,
              ))
        ],
        leading: GestureDetector(
          onTap: () {
            context.read<HomeScreenController>().savearticle(false);
            Navigator.pop(context);
          },
          child: Icon(
            size: 18,
            Icons.arrow_back_ios,
            color: Colorconstants.whitecolor,
          ),
        ),
        backgroundColor: Colorconstants.primarycolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                fit: BoxFit.cover,
                height: 210,
                width: double.infinity,
                widget.imgurl == ''
                    ? ImageConstants.noimagetodisplay
                    : widget.imgurl),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.author == ''
                      ? SizedBox()
                      : Container(
                          decoration: BoxDecoration(
                              color: Colorconstants.greycolor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.author,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colorconstants.blackcolor),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        ),
                  SizedBox(height: 16),
                  Text(
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                          color: Colorconstants.blackcolor),
                      softWrap: true,
                      widget.title == '' ? 'No Data' : widget.title),
                  SizedBox(height: 16),
                  Text(
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colorconstants.blackcolor),
                      softWrap: true,
                      widget.content == '' ? 'No Data' : widget.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
