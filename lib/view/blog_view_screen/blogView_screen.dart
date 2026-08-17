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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isSaved = await context.read<HomeScreenController>().checkIfSaved(
            title: widget.title,
            url: widget.url,
          );
      context.read<HomeScreenController>().savearticle(isSaved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          context.watch<HomeScreenController>().issaved
              ? IconButton(
                  onPressed: () async {
                    await context
                        .read<HomeScreenController>()
                        .removeSavedArticle(
                          url: widget.url,
                          title: widget.title,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Article removed from saved list.'),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.bookmark_added,
                    color: Colorconstants.whitecolor,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    final error =
                        await context.read<HomeScreenController>().saveArticle(
                              url: widget.url,
                              imgurl: widget.imgurl,
                              title: widget.title,
                              content: widget.content,
                              author: widget.author,
                            );
                    if (context.mounted) {
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Article saved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
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
              widget.imgurl.isEmpty
                  ? ImageConstants.noimagetodisplay
                  : widget.imgurl,
              fit: BoxFit.cover,
              height: 210,
              width: double.infinity,
              headers: const {
                'User-Agent':
                    'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
                'Accept': 'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 210,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Image.asset(
                      ImageConstants.wirenewslogopng,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
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
