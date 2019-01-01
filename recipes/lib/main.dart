import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';
import 'recipe.dart';
import 'viewRecipe.dart';
import 'uniWidgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Recipe App Name'),
    );
  }
}

//widget
class RecipeListView extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeListView({Key key, this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: recipes.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 5.0),
                  ListTile(
                    title: Text('${recipes[position].title}'),
                    subtitle: Text('${recipes[position].publisher}'),
                    onTap: () => _onTapItem(context, recipes[position]),
                  ),
                ],
              );
            }));
  }

  void _onTapItem(BuildContext context, Recipe recipe) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new RecipePage(
                  recipeID: recipe.id,
                  title: recipe.title,
                )));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      'https://www.food2fork.com/api/search?key=c170274c40994703421ea66c402d9d05';

  Future<List<Recipe>> getList() async {
    final response = await http.get('$url');
    return recipesListFromJson(response.body);
  }

  List<Recipe> recipesListFromJson(String jsonResponse) {
    List<Recipe> recipeList = new List<Recipe>();
    var decoded = json.decode(jsonResponse);
    int count = decoded['count'] as int;
    for (int i = 0; i < count; i++) {
      recipeList.add(Recipe.fromJson(decoded['recipes'][i]));
    }
    return recipeList;
  }

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
                      return ErrorWidgetUni();
                    }
                    return RecipeListView(recipes: snapshot.data);
                  } else
                    return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}
