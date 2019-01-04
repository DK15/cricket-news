import 'package:cricket_news/details.dart';
import 'package:cricket_news/news.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cricket_news/recent_news.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Cricket News', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ))
                  ],
                ),

                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.blueAccent,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab
                  ),
                  tabs: <Widget>[
                    Tab(text: 'Top News'),
                    Tab(text: 'Recent News')
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Center(
                    child: TopNews(),
                  ),
                  Center(child: RecentNews())
                ],
              ),
            )));
  }
}

class TopNews extends StatefulWidget {
  @override
  _TopNewsState createState() => new _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  final List<NewsCard> _news = <NewsCard>[];

  bool loading = true;

  FetchNews() async {
    var response = await http.get(
        'https://newsapi.org/v2/top-headlines?sources=espn-cric-info&apiKey=apikey');

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
        body: Center(child: UI()));
  }
}

class NewsCard extends StatelessWidget {
  final String title, description, url, urlToImage, content;

  NewsCard(
      {this.title, this.description, this.url, this.urlToImage, this.content});

  @override
  Widget build(BuildContext context) {
    News news = new News(title, description, url, urlToImage, content);

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
