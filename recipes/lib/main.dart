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

class ChangePageButton extends StatelessWidget {
  final bool nextPage;
  final Function nextPageFunction;
  ChangePageButton({Key key, this.nextPage, this.nextPageFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return nextPage
        ? IconButton(
            onPressed: () => nextPageFunction(1),
            icon: new Icon(Icons.chevron_right))
        : IconButton(
            onPressed: () => nextPageFunction(-1),
            icon: new Icon(Icons.chevron_left));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page;

  Future<List<Recipe>> getList(int page) async {
    String url =
        'https://www.food2fork.com/api/search?key=696dcc4625a221d4741899f9761c69a2';
    if (page > 1) {
      url = url + "&page=" + page.toString();
    }
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

  void nextPage(int amount) {
    setState(() {
      page += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: FutureBuilder<List<Recipe>>(
                future: getList(page),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorWidgetUni();
                    }
                    return Column(children: <Widget>[
                      new Container(
                          child: RecipeListView(recipes: snapshot.data)),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          page == 1
                              ? new Container()
                              : ChangePageButton(
                                  nextPage: false, nextPageFunction: nextPage),
                          ChangePageButton(
                              nextPage: true, nextPageFunction: nextPage)
                        ],
                      )
                    ]);
                  } else
                    return CircularProgressIndicator();
                })));
  }

  @override
  void initState() {
    page = 1;
    super.initState();
  }
}
