import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Recipe>> getList() async {
    final response = await http.get('$url/1');
    return recipesListFromJson(response.body);
  }

  List<Recipe> recipesListFromJson(String json) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<Recipe>>(
                future: getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorWidget();
                    }
                    return ListView.builder();
                  } else
                    return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}

class Recipe {
  String title;
  String body;
  String id;
  Recipe({this.id, this.title, this.body});
}

class RecipeListView extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeListView({Key key, this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: recipes.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text('${recipes[position].title}'),
                  subtitle: Text('${recipes[position].body}'),
                  onTap: () => _onTapItem(context, recipes[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, Recipe recipe) {}
}
