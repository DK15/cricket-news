import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cricket_news/news.dart';
import 'package:cricket_news/details.dart';

class RecentNews extends StatefulWidget {
  @override
  _RecentNewsState createState() => new _RecentNewsState();
}

class _RecentNewsState extends State<RecentNews> with AutomaticKeepAliveClientMixin<RecentNews> {
  final List<NewsCard> _news = <NewsCard>[];

  bool loading = true;

  FetchNews() async {
    var response = await http.get(
        'https://newsapi.org/v2/everything?sources=espn-cric-info&apiKey=a5bac0eb82474fb3af734ab8b98320eb');

    if (response.statusCode == 200) {
      _news.clear();
      var responseBody = jsonDecode(response.body);

      for (var data in responseBody['articles']) {
        _news.add(new NewsCard(
          title: data['title'],
          description: data['description'],
          url: data['url'],
          urlToImage: data['urlToImage'],
          content: data['content'],
        ));
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    FetchNews();
  }

  Widget UI() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _news[index],
              itemCount: _news.length,
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Center(
            child: UI()
        )
    );
  }

  @override

  bool get wantKeepAlive => true;
}

class NewsCard extends StatelessWidget {
  final String title,description,url,urlToImage,content;

  NewsCard({this.title, this.description,this.url,this.urlToImage,this.content});

  @override
  Widget build(BuildContext context) {

    News news = new News(title, description,url,urlToImage,content);

    final makeListTile = ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new Details(news)));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Colors.white24),
            ),
          ),
          child: Image(
            height: 60.0,
            width: 80.0,
            fit: BoxFit.cover,
            image: NetworkImage(urlToImage),
          ),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        trailing: Icon(Icons.keyboard_arrow_right, size: 30.0));
    return Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 110.0,
          child: makeListTile,
        ));
  }
}
