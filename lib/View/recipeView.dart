import 'package:flutter/material.dart';
import 'package:yusr/Model/RecipeModel.dart';

class recipeView extends StatefulWidget {
  final recipe;
  const recipeView(this.recipe, {super.key});

  @override
  State<recipeView> createState() => _recipeViewState(recipe);
}

class _recipeViewState extends State<recipeView> {
  Recipe? recipe;
  _recipeViewState(recipe) {
    this.recipe = recipe;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(children: [
          Container(
            width: size.width,
            height: 300,
            child: Image.network(
              recipe!.RecipePhoto,
              fit: BoxFit.cover,
            ),
          ),
          Opacity(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 20, 20, 20),
                  Colors.transparent
                ])),
                width: size.width,
                height: 300,
              ),
              opacity: 0.9),
          Padding(
            padding: const EdgeInsets.only(top: 70, right: 40),
            child: Opacity(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.circular(10)),
                  color: Colors.white,
                ),
              ),
              opacity: 0.75,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 65, right: 36),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close_rounded,
                size: 33,
              ),
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 70, right: 330),
          //   child: Opacity(
          //     child: Container(
          //       height: 40,
          //       width: 40,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.vertical(
          //             top: Radius.circular(10), bottom: Radius.circular(10)),
          //         color: Colors.white,
          //       ),
          //     ),
          //     opacity: 0.75,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 66, right: 326),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.favorite_outline,
          //       size: 31,
          //     ),
          //     color: Color.fromARGB(255, 0, 0, 0),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 230),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 270, right: 40, left: 20),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(children: [
                      Text(
                        recipe!.RecipeName,
                        style: new TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.timer_outlined,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(" " + recipe!.time + " دقيقة ",
                            style: new TextStyle(
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5)),
                              color: Color.fromARGB(255, 104, 168, 106)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Text(recipe!.callories + " سعرة حرارية       ",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontFamily: 'Tajawal',
                                  )),
                              SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5)),
                              color: Color.fromARGB(255, 104, 132, 168)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Text(recipe!.persons + " أشخاص       ",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontFamily: 'Tajawal',
                                  )),
                              SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text("طريقة التحضير :",
                            style: new TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      recipe!.description,
                      textAlign: TextAlign.justify,
                      style: new TextStyle(fontFamily: 'Tajawal', fontSize: 17),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("المقادير :",
                            style: new TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      recipe!.ingredients,
                      textAlign: TextAlign.justify,
                      style: new TextStyle(fontFamily: 'Tajawal', fontSize: 17),
                    ),
                    Text("\n\n\n")
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
