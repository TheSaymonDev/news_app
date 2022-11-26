import 'package:flutter/material.dart';
import 'package:news_app/colors/my_colors.dart';
import 'package:news_app/screen/details_page.dart';
import 'package:news_app/screen/home_page.dart';
import 'package:news_app/http_request/custom_http.dart';
import 'package:news_app/model/news_model_class.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchBarDemo extends StatefulWidget {
  const SearchBarDemo({Key? key}) : super(key: key);

  @override
  State<SearchBarDemo> createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<SearchBarDemo> {
  List<Articles> searchList = [];
  List<String> searchKeyWord = [
    "Football",
    "World",
    "Fifa",
    "cricket",
    "Sports",
    "Politics",
    "Business"
  ];
  bool isSearch = true;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldClr,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 45,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  onChanged: (value) async {
                    searchList = await Custom_http().fetchSearchData(
                        pageNo: 1, query: searchController.text.toString());
                    isSearch = false;
                    setState(() {});
                  },
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  style: myStyle(16, FontWeight.normal, Colors.black),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: containerClr,
                      focusColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: textClr,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchList = [];
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: textClr,
                        ),
                      ),
                      hintText: 'Search News',
                      hintStyle: myStyle(16, FontWeight.normal, Colors.grey)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 110,
                        child: MasonryGridView.count(
                          crossAxisCount: 4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 8,
                          itemCount: searchKeyWord.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              searchList = await Custom_http().fetchSearchData(
                                  pageNo: 1, query: searchKeyWord[index]);
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: containerClr),
                              child: Text(
                                '${searchKeyWord[index]}',
                                style: myStyle(14, FontWeight.bold, textClr),
                              ),
                            ),
                          ),
                        ),
                      ),
                      searchList.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 15,
                                  ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: searchList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                                  articles: searchList[index],
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .20,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    '${searchList[index].urlToImage}'),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${searchList[index].title}',
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
                              })
                          : Center(
                              child: Text('No data found'),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
