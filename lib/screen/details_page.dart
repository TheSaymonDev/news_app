import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_app/colors/my_colors.dart';
import 'package:news_app/model/news_model_class.dart';
import 'package:news_app/screen/home_page.dart';
import 'package:news_app/screen/web_view_page.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, this.articles}) : super(key: key);

  Articles? articles;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () async {
          String url = '${widget.articles!.url}';
          await Share.share(url);
        },
        child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 2, color: Colors.cyan),
                color: containerClr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Share',
                  style: myStyle(16, FontWeight.bold, textClr),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.share,
                  size: 18,
                  color: textClr,
                )
              ],
            )),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .30,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('${widget.articles!.urlToImage}'),
                        fit: BoxFit.cover)),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.articles!.title}',
                        style: myStyle(16, FontWeight.bold, textClr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${widget.articles!.description}',
                        style: myStyle(16, FontWeight.normal, textClr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 5,
                            color: Colors.yellow[900],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'By',
                            style: myStyle(16, FontWeight.normal, textClr),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '${widget.articles!.author}',
                            style: myStyle(16, FontWeight.bold, textClr),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        Jiffy(widget.articles!.publishedAt).format('d MMMM y'),
                        style: myStyle(16, FontWeight.bold, textClr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${widget.articles!.content}',
                        style: myStyle(18, FontWeight.normal, textClr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text('For more information')),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                    url: widget.articles!.url,
                                  )));
                        },
                        child: Text(
                          '${widget.articles!.url}',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.blue[900]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.articles!.source!.name}',
                            style: myStyle(16, FontWeight.bold, textClr),
                          )),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
