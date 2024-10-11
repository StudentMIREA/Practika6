import 'package:flutter/material.dart';
import 'package:pr6/Pages/AddPage.dart';
import 'package:pr6/Pages/ItemPage.dart';
import 'package:pr6/Pages/component/Items.dart';
import 'package:pr6/model/ShoppingCart.dart';
import 'package:pr6/model/items.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key, required this.updateCount});

  final Function() updateCount;

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  void AddFavorite(int index) {
    setState(() {
      if (!Favorite.any((el) => el == index)) {
        Favorite.add(index);
      } else {
        Favorite.remove(index);
      }
    });
  }

  void AddShopCart(index) async {
    setState(() {
      if (!ShoppingCart.any((el) => el.id == index)) {
        ShoppingCart.add(ShoppingCartItem(index, 1));
      } else {
        ShoppingCart.removeWhere((el) => el.id == index);
      }
      widget.updateCount();
    });
  }

  void NavToAdd(BuildContext context) async {
    Items item = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPage(
                items: ItemsList,
              )),
    );
    setState(() {
      ItemsList.add(item);
    });
  }

  void NavToItem(index) async {
    int? answ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
          item: ItemsList.elementAt(index),
          updateCount: () => widget.updateCount(),
        ),
      ),
    );
    setState(() {
      if (answ != null) {
        ItemsList.removeAt(answ);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Товары'),
        backgroundColor: Colors.white70,
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
            onPressed: () {
              NavToAdd(context);
            },
          ),
        ],
      ),
      body: ItemsList.length != 0
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.63,
              ),
              itemCount: ItemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    NavToItem(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 5.0, left: 5.0, top: 2.0, bottom: 5.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 246, 218),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Image.network(
                                ItemsList.elementAt(index).image,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.4,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    color: Colors.amber[200],
                                    child: const Center(
                                        child: Text(
                                      'нет картинки',
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    )),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, bottom: 0.0, right: 15.0, left: 15.0),
                            child: SizedBox(
                              height: 35.0,
                              child: Text(
                                '${ItemsList.elementAt(index).name}',
                                style: const TextStyle(fontSize: 12),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 5.0),
                            child: Row(children: [
                              const Text(
                                'Цена: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${ItemsList.elementAt(index).cost} ₽',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 6, 196, 9),
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () => {
                                            AddFavorite(
                                                ItemsList.elementAt(index).id)
                                          },
                                      icon: Favorite.any((el) =>
                                              el ==
                                              ItemsList.elementAt(index).id)
                                          ? const Icon(Icons.favorite)
                                          : const Icon(Icons.favorite_border)),
                                ),
                              ),
                            ]),
                          ),
                          ShoppingCart.any((el) =>
                                  el.id == ItemsList.elementAt(index).id)
                              ? Expanded(
                                  child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: const Text(
                                        'Убрать',
                                        style: TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                      ),
                                      onPressed: () {
                                        AddShopCart(
                                            ItemsList.elementAt(index).id);
                                      },
                                    ),
                                  ),
                                ))
                              : Expanded(
                                  child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    255, 160, 0, 1))),
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 246, 218),
                                      ),
                                      child: const Text("В корзину",
                                          style: TextStyle(fontSize: 12)),
                                      onPressed: () {
                                        AddShopCart(
                                            ItemsList.elementAt(index).id);
                                      },
                                    ),
                                  ),
                                ))
                        ],
                      ),
                    ),
                  ),
                );
              })
          : const Center(child: Text('Нет товаров')),
    );
  }
}
