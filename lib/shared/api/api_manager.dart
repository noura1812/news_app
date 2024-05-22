import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_c10_maadi/model/SourcesResponse/SourcesResponse.dart';
import 'package:news_c10_maadi/model/newsresponse/NewsResponse.dart';

class ApiManager {
  static const String baseUrl = "newsapi.org";
  static const String apiKey = "050460483215412993fe3f8dcebc160c";
  static Future<SourcesResponse> getSources(String categoryId) async {
    var url = Uri.https(baseUrl, "/v2/top-headlines/sources",
        {"apiKey": apiKey, "category": categoryId});
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    SourcesResponse sourcesResponse = SourcesResponse.fromJson(json);
    return sourcesResponse;
  }

  static Future<NewsResponse> getNews(String sourceId, int page) async {
    print('--$page---');
    var url = Uri.https(baseUrl, "/v2/everything", {
      "apiKey": apiKey,
      "sources": sourceId,
      "pageSize": 8.toString(),
      "page": page.toString(),
    });
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    NewsResponse newsResponse = NewsResponse.fromJson(json);
    return newsResponse;
  }

  static Future<NewsResponse> getSearchNews(String query) async {
    print('---->$query');
    var url =
        Uri.https(baseUrl, "/v2/everything", {"apiKey": apiKey, "q": query});
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    NewsResponse newsResponse = NewsResponse.fromJson(json);
    return newsResponse;
  }
}
