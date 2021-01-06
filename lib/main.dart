import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:technicaltest/comicbook.dart';
import 'package:technicaltest/comicdetail.dart';

void main() => runApp(MaterialApp(
      title: "Comic Book",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

ComicBook comicBook;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var res = await http.get(
        'https://comicvine.gamespot.com/api/issues/?api_key=179f695f57387c3496f05791c798d91da64c6e91&format=json&limit=20&offset=20&filter=date_added:2021-01-01|2021-01-04');
    var decodedJson = jsonDecode(res.body);
    comicBook = ComicBook.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            title: new Center(
                child: new Text("ComicBook", textAlign: TextAlign.center)),
            backgroundColor: Colors.grey),
        body: comicBook == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.count(
                crossAxisCount: 4,
                children: comicBook.results
                    .map((comic) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ComicPage(
                                          results: comic,
                                        )));
                          },
                          child: Card(
                            color: Colors.grey,
                            margin:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    height: 275.0,
                                    width: 275.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            comic.image.originalUrl),
                                      ),
                                    )),
                                if (comic.name == null)
                                  Text(
                                    'Untitled ' + comic.issueNumber,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                if (comic.name != null)
                                  Text(
                                    comic.name + ' ' + comic.issueNumber,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                Text(
                                  comic.dateAdded,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                    .toList(),
              ));
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.grid_view),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          )
        ],
      ),
    );
  }
}
