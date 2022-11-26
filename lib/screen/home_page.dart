import 'package:flutter/material.dart';
import 'package:news_app/colors/my_colors.dart';
import 'package:news_app/http_request/custom_http.dart';
import 'package:news_app/model/news_model_class.dart';
import 'package:news_app/screen/details_page.dart';
import 'package:news_app/screen/search_page.dart';
import 'package:news_app/theme_pref/theme_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = false;
  int pageNo = 1;
  String sortBy = "popularity";
  List<String> list = <String>['popularity', "relevancy", "publishedAt"];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          leading: Container(
            margin: EdgeInsets.all(9),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: scaffoldClr),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(PageTransition(
                      child: SearchBarDemo(),
                      type: PageTransitionType.rightToLeft,
                      inheritTheme: true,
                      ctx: context));
                },
                icon: Icon(
                  Icons.search,
                  size: 18,
                  color: textClr,
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                      themeNotifier.isDark
                          ? Icons.nightlight_round
                          : Icons.wb_sunny,
                      color: themeNotifier.isDark == true
                          ? Colors.white
                          : Colors.black),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  }),
            ),
          ],
          centerTitle: true,
          title: Container(
            width: MediaQuery.of(context).size.width * .35,
            child: Image.asset('images/aljazeera.png'),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sort By',
                        style: myStyle(18, FontWeight.bold, textClr),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: scaffoldClr),
                        child: DropdownButton<String>(
                          underline: SizedBox(),
                          dropdownColor: containerClr,
                          elevation: 0,
                          value: sortBy,
                          icon: Icon(Icons.arrow_downward,
                              size: 18, color: textClr),
                          style: myStyle(12, FontWeight.bold, textClr),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              sortBy = value!;
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Articles>>(
                  future: Custom_http()
                      .fetchAllData(pageNo: pageNo, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Something error");
                    } else if (snapshot.data == null) {
                      return Text("No Data Found");
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        articles: snapshot.data![index],
                                      )));
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: containerClr),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .20,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              '${snapshot.data![index].urlToImage}'),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${snapshot.data![index].title}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: textClr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (pageNo == 1) {
                          } else {
                            setState(() {
                              pageNo = pageNo - 1;
                            });
                          }
                        },
                        child: Text(
                          'Previous',
                          style: myStyle(12, FontWeight.bold, textClr),
                        ),
                        style:
                            TextButton.styleFrom(backgroundColor: containerClr),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pageNo = index + 1;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index + 1 == pageNo
                                            ? containerClr
                                            : Colors.transparent),
                                    child: Text(
                                      '${index + 1}',
                                      style: myStyle(
                                          12, FontWeight.normal, textClr),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 5,
                                ),
                            itemCount: 5),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          if (pageNo == 5) {
                          } else {
                            setState(() {
                              pageNo = pageNo + 1;
                            });
                          }
                        },
                        child: Text(
                          'Next',
                          style: myStyle(12, FontWeight.bold, textClr),
                        ),
                        style:
                            TextButton.styleFrom(backgroundColor: containerClr),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  mydropDown() {
    return DropdownButton<String>(
      value: sortBy,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          sortBy = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
