import 'dart:convert';
import 'package:flutter_news/model/show_category.dart';
import 'package:http/http.dart' as http;

class ShowCategoryNews{
  List<ShowCategoryModel> categories=[];



  Future<void>getCategoriesNews(String category)async{
    String url="https://newsapi.org/v2/everything?q=apple&from=2024-07-11&to=2024-07-11&sortBy=popularity&apiKey=301a1f3772834e95af27a459a24322dd";
    var response= await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if (element["urlToImage"]!=null && element['description']!=null){
          ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element["title"],
            description: element ["description"],
            url: element ["url"],
            urlToImage: element ["urlToImage"],
            content: element ["content"],
            author: element ["author"],
          );
          categories.add(categoryModel );
        }
      });
    }
  }
}