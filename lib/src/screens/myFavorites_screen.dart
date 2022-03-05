// ignore_for_file: file_names

import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/components/my_drawer.dart';
import 'package:cookbook/src/components/recipe_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/recipe.dart';

class MyFavoritesScreen extends StatefulWidget {
  final ServerController serverController;
  const MyFavoritesScreen(this.serverController, {Key key}) : super(key: key);

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Favoritos"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getFavoritesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;

            if (list.length == 0) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      size: 120,
                      color: Colors.grey[300],
                    ),
                    Text(
                      "Ud. no tiene favoritos",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () {
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
