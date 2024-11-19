import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wirenews/controller/home_screen_controller.dart';
import 'package:wirenews/main.dart';
import 'package:wirenews/utils/constants/colorconstants.dart';
import 'package:wirenews/utils/constants/image_constants.dart';

class NewscardWidget extends StatefulWidget {
  bool deletebutton;
  String imgurl;
  String title;
  String author;
  String? id;
  NewscardWidget(
      {super.key,
      required this.author,
      required this.imgurl,
      required this.title,
      this.id,
      this.deletebutton = false});

  @override
  State<NewscardWidget> createState() => _NewscardWidgetState();
}

class _NewscardWidgetState extends State<NewscardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              width: 2,
              style: BorderStyle.solid,
              color: Colorconstants.greycolor.withOpacity(0.2))),
      width: 350,
      height: widget.deletebutton ? 220 : 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
              widget.imgurl == ''
                  ? ImageConstants.noimagetodisplay
                  : widget.imgurl),
          const SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        widget.author == '' ? 'Unknown' : widget.author,
                        style: GoogleFonts.roboto(
                          color: Colorconstants.greycolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      widget.deletebutton == true
                          ? IconButton(
                              onPressed: () {
                                context
                                    .read<HomeScreenController>()
                                    .deleteArticles(id: widget.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colorconstants.primarycolor,
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          constraints:
                              BoxConstraints(maxWidth: constraints.maxWidth),
                          child: Text(
                            widget.title == '' ? 'No Data' : widget.title,
                            style: GoogleFonts.roboto(
                              color: Colorconstants.blackcolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
