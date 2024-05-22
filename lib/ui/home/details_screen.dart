import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c10_maadi/model/newsresponse/Article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailsScreen extends StatelessWidget {
  static const String routeName = 'detailsScreen';
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Article article = ModalRoute.of(context)?.settings.arguments as Article;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title ?? '',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * .02, horizontal: width * .02),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                height: 0.25 * height,
                width: double.infinity,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Text(article.source?.name ?? ""),
            Text(article.title ?? ""),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  article.publishedAt ?? "",
                )),
            Text(
              article.description ?? '',
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                    onPressed: () {
                      launchMyUli(article.url ?? '');
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    label: Text('view full article ')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void launchMyUli(String url) async {
  final Uri _url = Uri.parse(url);
  bool canLaunch = await canLaunchUrl(_url);
  if (canLaunch) {
    launchUrlString(url);
    launchUrl(_url);
  } else {
    print('cannot launch');
  }
}
