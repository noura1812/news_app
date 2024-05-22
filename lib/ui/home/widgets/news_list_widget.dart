import 'package:flutter/material.dart';
import 'package:news_c10_maadi/model/newsresponse/Article.dart';
import 'package:news_c10_maadi/shared/api/api_manager.dart';

import '../../../model/SourcesResponse/Source.dart';
import 'news_item.dart';

class NewsListWidget extends StatefulWidget {
  final Source source;
  const NewsListWidget({Key? key, required this.source}) : super(key: key);

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  ScrollController controller = ScrollController();
  int page = 1;
  List<Article> articles = [];
  bool endPage = false;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        if (articles.length % 8 == 0 && !endPage) {
          ++page;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiManager.getNews(widget.source.id ?? "", page),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              articles.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data?.status == "error") {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data?.message ?? snapshot.error.toString()),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text("Try again"))
              ],
            );
          }
          var newsList = snapshot.data?.articles ?? [];
          if (newsList.isEmpty) {
            endPage = true;
          }
          articles.addAll(newsList);
          return Expanded(
              child: ListView.separated(
            controller: controller,
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemBuilder: (context, index) => NewsItem(
              article: articles[index],
            ),
            itemCount: articles.length,
          ));
        });
  }
}
