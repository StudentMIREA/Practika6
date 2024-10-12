import 'package:flutter/material.dart';
import 'package:pr6/Pages/FavouritePage.dart';
import 'package:pr6/Pages/ItemsPage.dart';
import 'package:pr6/Pages/ProfilePage.dart';
import 'package:pr6/Pages/ShopCartPage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pr6/Pages/component/Items.dart';

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
  int count = ShoppingCart.fold(0, (sum, item) => sum + item.count);

  void updateCount() {
    setState(() {
      count = ShoppingCart.fold(0, (sum, item) => sum + item.count);
    });
  }

  static List<Widget> widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    widgetOptions = [
      ItemsPage(updateCount: updateCount),
      FavoritePage(updateCount: updateCount),
      ShopCartPage(updateCount: updateCount),
      const ProfilePage()
    ];
  }

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
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1)),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
              backgroundColor: Color.fromRGBO(255, 236, 179, 1)),
          BottomNavigationBarItem(
              icon: count == 0
                  ? const Icon(Icons.shopping_cart_rounded)
                  : badges.Badge(
                      badgeContent: count > 9
                          ? Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(255, 160, 0, 1),
                              ),
                            )
                          : Text(
                              count.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(255, 160, 0, 1)),
                            ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Color.fromRGBO(255, 162, 0, 0),
                      ),
                      child: const Icon(Icons.shopping_cart_rounded),
                    ),
              label: 'Корзина',
              backgroundColor: const Color.fromRGBO(255, 236, 179, 1)),
          const BottomNavigationBarItem(
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
