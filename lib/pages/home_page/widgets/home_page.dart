import 'package:Pokedex/consts/consts_app.dart';
import 'package:Pokedex/models/pokeapi.dart';
import 'package:Pokedex/pages/home_page/widgets/app_bar_home.dart';
import 'package:Pokedex/pages/home_page/widgets/poke_item.dart';
import 'package:Pokedex/stores/pokeapi_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore pokeApiStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pokeApiStore = PokeApiStore();
    pokeApiStore.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statuswidth = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: -(240 / 4.7),
            left: screenWidth - (240 / 1.6),
            child: Opacity(
              child: Image.asset(
                ConstsApp.blackPokeball,
                height: 240,
                width: 240,
              ),
              opacity: 0.1,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: statuswidth,
                ),
                AppBarHome(),
                Expanded(
                  child: Container(
                    child: Observer(
                      builder: (BuildContext context) {
                        PokeAPI _pokeApi = pokeApiStore.pokeAPI;
                        return (_pokeApi != null)
                            ? AnimationLimiter(
                                child: GridView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(12),
                                addAutomaticKeepAlives: false,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: pokeApiStore.pokeAPI.pokemon.length,
                                itemBuilder: (context, index) {
                                  Pokemon pokemon =
                                      pokeApiStore.getPokemon(index: index);
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    columnCount: 2,
                                    duration: const Duration(milliseconds: 375),
                                    child: ScaleAnimation(
                                      child: GestureDetector(
                                        //child: Container(color: Colors.red),
                                        child: PokeItem(
                                          index: index,
                                          types: pokemon.type,
                                          name: pokemon.name,
                                          color: Colors.red,
                                          num: pokemon.num,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Container(),
                                                fullscreenDialog: true),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ))
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
