import 'package:flutter/material.dart';
import 'package:pr6/Pages/FavouritePage.dart';
import 'package:pr6/Pages/ItemsPage.dart';
import 'package:pr6/Pages/ProfilePage.dart';
import 'package:pr6/Pages/ShopCartPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  static const List<Widget> widgetOptions = <Widget>[
    ItemsPage(),
    FavoritePage(),
    ShopCartPage(),
    ProfilePage()
  ];

  void onTab(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Корзина',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1))
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 201, 127, 0),
        unselectedItemColor: const Color.fromARGB(255, 118, 108, 81),
        onTap: onTab,
      ),
    );
  }
}
