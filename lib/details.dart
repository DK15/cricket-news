import 'package:cricket_news/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class Details extends StatelessWidget {

  final News news;

  Details(this.news);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Image(
              image: NetworkImage('${news.urlToImage}'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text('${news.description}',style: TextStyle(
              fontSize: 16.0,
              color: Colors.black
            ),),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text('${news.content}',style: TextStyle(
              fontSize: 16.0
            ),),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Container(
              margin: EdgeInsets.all(5.0),
            child: Linkify(
              onOpen: (url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              text: '${news.url}', style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ),
          Container(
            padding: EdgeInsets.only(left:60.0, right: 60.0),
            child: RaisedButton(
              onPressed: () => Share.share('${news.url}'),
              child:Text('Share'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              color: Colors.blue,
            ),
          )
      ]
          )
      );
  }
}