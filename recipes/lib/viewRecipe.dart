import 'package:flutter/material.dart';
import 'recipe.dart';
import 'uniWidgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  RecipePage({Key key, this.recipeID, this.title}) : super(key: key);

  final String recipeID;
  final String title;
  @override
  RecipePageState createState() => RecipePageState();
}

class IngredientListView extends StatelessWidget {
  final List<dynamic> ingredients;

  IngredientListView({Key key, this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ingredients.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Divider(height: 1.0),
              ListTile(
                title: Text('${ingredients[position]}'),
              ),
            ],
          );
        });
  }
}

class RecipePageState extends State<RecipePage> {
  Future<Recipe> getRecipe() async {
    String url =
        'https://www.food2fork.com/api/get?key=696dcc4625a221d4741899f9761c69a2&rId=' +
            widget.recipeID;
    final response = await http.get('$url');
    //Below can be compressed to one line easily
    var decoded = json.decode(response.body);
    var decStuffNeeded = decoded['recipe'];
    Recipe theRecipe = Recipe.fromJsonIndividual(decStuffNeeded);
    return theRecipe;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  double imageSize;
  @override
  Widget build(BuildContext context) {
    imageSize = MediaQuery.of(context).size.width / 3;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: FutureBuilder<Recipe>(
                future: getRecipe(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorWidgetUni();
                    }
                    return Column(children: [
                      Text(snapshot.data.title),
                      new Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(snapshot.data.imageUrl)))),
                      new InkWell(
                          child: new Text('Open Full Recipe',
                              style: new TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                          onTap: () => _launchURL(snapshot.data.url)),
                      Container(
                          child: new Expanded(
                              child: IngredientListView(
                        ingredients: snapshot.data.ingredients,
                      )))
                    ]);
                  } else
                    return CircularProgressIndicator();
                })));
  }
}
