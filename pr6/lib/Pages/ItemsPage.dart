import 'package:flutter/material.dart';
import 'package:pr6/Pages/AddPage.dart';
import 'package:pr6/Pages/ItemPage.dart';
import 'package:pr6/Pages/component/Items.dart';
import 'package:pr6/model/items.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  void AddFavorite(int index) {
    setState(() {
      ItemsList.elementAt(index).favorite
          ? ItemsList.elementAt(index).favorite = false
          : ItemsList.elementAt(index).favorite = true;
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
    bool answ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(item: ItemsList.elementAt(index)),
      ),
    );
    setState(() {
      ItemsList.elementAt(index).favorite = answ;
    });
  }

  void AddShopCart(index) async {
    setState(() {
      if (!ShoppingCart.any((el) => el == index)) {
        ShoppingCart.add(index);
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
                childAspectRatio: 0.6,
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
                      //height: MediaQuery.of(context).size.height * 0.47,
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
                                      onPressed: () => {AddFavorite(index)},
                                      icon: ItemsList.elementAt(index).favorite
                                          ? const Icon(Icons.favorite)
                                          : const Icon(Icons.favorite_border)),
                                ),
                              ),
                            ]),
                          ),
                          !ShoppingCart.any(
                                  (el) => el == ItemsList.elementAt(index).id)
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 1.0,
                                        left: 8.0,
                                        right: 8.0),
                                    side: const BorderSide(
                                        color: Colors.grey,
                                        width:
                                            2), // Установка цвета и толщины границы
                                  ),
                                  child: const Text(
                                    'Добавить в корзину',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            Color.fromARGB(255, 136, 136, 136)),
                                  ),
                                  onPressed: () {
                                    AddShopCart(ItemsList.elementAt(index).id);
                                  },
                                )
                              : const Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Товар в корзине',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color.fromARGB(255, 6, 196, 9)),
                                  ),
                                )
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
