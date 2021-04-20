import 'package:newsapp/domain/models/news_api_model.dart';
import 'package:dio/dio.dart';

class NewsRepo {
  // final api_key = "c06b3bdad65543e4ae7e16f82fab6f0f";
  final endpoint =
      "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=c06b3bdad65543e4ae7e16f82fab6f0f";

  Future<NewsModel?> getData() async {
    try {
      var response = await Dio().get(endpoint);
      print(response);
      final json = response.data;
      return NewsModel.fromJson(json);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
