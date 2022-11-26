import 'dart:convert';
import 'package:news_app/model/news_model_class.dart';
import 'package:http/http.dart' as http;

class Custom_http {
  Future<List<Articles>> fetchAllData(
      {required int pageNo, required String sortBy}) async {
    List<Articles> getAllNewsData = [];
    Articles articles;
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?domains=aljazeera.com&page=$pageNo&pageSize=10&sortBy=$sortBy&apiKey=ddf5a87e0ad9454183f26d28f63137e5'));
    var data = jsonDecode(response.body);
    for (var i in data['articles']) {
      articles = Articles.fromJson(i);
      getAllNewsData.add(articles);
    }
    return getAllNewsData;
  }

  Future<List<Articles>> fetchSearchData(
      {required int pageNo, required String query}) async {
    List<Articles> getAllNewsData = [];
    Articles articles;
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&domains=aljazeera.com&page=$pageNo&pageSize=10&apiKey=ddf5a87e0ad9454183f26d28f63137e5'));
    var data = jsonDecode(response.body);
    for (var i in data['articles']) {
      articles = Articles.fromJson(i);
      getAllNewsData.add(articles);
    }
    return getAllNewsData;
  }
}
