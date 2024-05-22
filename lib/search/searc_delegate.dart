import 'package:flutter/material.dart';
import 'package:news_c10_maadi/shared/api/api_manager.dart';
import 'package:news_c10_maadi/shared/theme.dart';
import 'package:news_c10_maadi/ui/home/widgets/news_item.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: Icon(Icons.search))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.close));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: ApiManager.getSearchNews(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data?.status == "error") {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data?.message ?? snapshot.error.toString()),
                ElevatedButton(onPressed: () {}, child: Text("Try again"))
              ],
            );
          }
          var newsList = snapshot.data?.articles ?? [];
          return Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemBuilder: (context, index) => NewsItem(
              article: newsList[index],
            ),
            itemCount: newsList.length,
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = ['old', 'age', 'sports'];
    return ListView.separated(
        itemBuilder: (context, index) => TextButton(
            onPressed: () {
              query = suggestions[index];
              showResults(context);
            },
            child: Text(suggestions[index])),
        separatorBuilder: (context, index) => Divider(),
        itemCount: suggestions.length);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return AppTheme.LightTheme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white))));
  }
}
