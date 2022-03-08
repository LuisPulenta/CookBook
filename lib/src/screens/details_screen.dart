import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/components/tabIngredients_widget.dart';
import 'package:cookbook/src/components/tabPreparation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/recipe.dart';

class DetailsScreen extends StatefulWidget {
  Recipe recipe;
  final ServerController serverController;

  DetailsScreen(this.recipe, this.serverController, {Key key})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
//********************************************************************
//*************** Iniciación de variables ****************************
//********************************************************************
  bool favorite = false;

//********************************************************************
//*************** Init State *****************************************
//********************************************************************
  @override
  void initState() {
    super.initState();
    loadState();
  }

//********************************************************************
//********************* Pantalla *************************************
//********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(widget.recipe.name),
              expandedHeight: 320,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(widget.recipe.photo),
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(.5),
                ),
              ),
              pinned: true,
              bottom: TabBar(
                indicatorWeight: 5,
                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "Ingredientes",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Preparación",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                if (widget.recipe.user.id ==
                    widget.serverController.loggedUser.id)
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final nRecipe = await Navigator.of(context).pushNamed(
                            "/edit_recipe",
                            arguments: widget.recipe);
                        setState(() {
                          widget.recipe = nRecipe;
                        });
                      }),
                getFavoriteWidget(),
                IconButton(
                    onPressed: () {
                      _showAboutIt(context);
                    },
                    icon: Icon(Icons.help_outline)),
              ],
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            TabIngredientsWidget(
              recipe: widget.recipe,
            ),
            TabPreparationWidget(
              recipe: widget.recipe,
            ),
          ],
        ),
      ),
    ));
  }

//********************************************************************
//********************* Métodos **************************************
//********************************************************************
  Widget getFavoriteWidget() {
    if (favorite != null) {
      if (favorite) {
        return IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () async {
            await widget.serverController.deleteFavorite(widget.recipe);
            setState(() {
              favorite = false;
            });
          },
        );
      } else {
        return IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.white,
          onPressed: () async {
            await widget.serverController.addFavorite(widget.recipe);
            setState(() {
              favorite = true;
            });
          },
        );
      }
    } else {
      return Container(
          margin: EdgeInsets.all(15),
          width: 30,
          child: CircularProgressIndicator());
    }
  }

  void loadState() async {
    final state = await widget.serverController.getIsFavorite(widget.recipe);
    setState(() {
      this.favorite = state;
    });
  }

  void _showAboutIt(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Acerca de la Receta"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nombre:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.recipe.name),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Usuario:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.recipe.user.nickname),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Fecha:  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "${widget.recipe.date.day}/${widget.recipe.date.month}/${widget.recipe.date.year}"),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cerrar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
