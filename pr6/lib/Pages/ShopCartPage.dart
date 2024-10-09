import 'package:flutter/material.dart';
import 'package:pr6/Pages/ItemPage.dart';
import 'package:pr6/Pages/component/Items.dart';
import 'package:pr6/model/items.dart';

class ShopCartPage extends StatefulWidget {
  const ShopCartPage({super.key});

  @override
  State<ShopCartPage> createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  List<Items> ItemsFromCart = ItemsList.where(
      (item) => ShoppingCart.any((element) => element == item.id)).toList();

  int findIndexById(int id) {
    return ItemsList.indexWhere((item) => item.id == id);
  }

  void DelCart(int index) {
    setState(() {
      ShoppingCart.remove(index);
      ItemsFromCart = ItemsList.where(
          (item) => ShoppingCart.any((element) => element == item.id)).toList();
    });
  }

  void NavToItem(index) async {
    bool answ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItemPage(item: ItemsList.elementAt(findIndexById(index))),
      ),
    );
    setState(() {
      ItemsList.elementAt(findIndexById(index)).favorite = answ;
      ItemsFromCart = ItemsList.where(
          (item) => ShoppingCart.any((element) => element == item.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor: Colors.white70,
      ),
      body: ItemsFromCart.length != 0
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: ItemsFromCart.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    NavToItem(ItemsFromCart.elementAt(index).id);
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
                                ItemsFromCart.elementAt(index).image,
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
                                '${ItemsFromCart.elementAt(index).name}',
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
                                '${ItemsFromCart.elementAt(index).cost} ₽',
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
                                            DelCart(
                                                ItemsFromCart.elementAt(index)
                                                    .id)
                                          },
                                      icon: const Icon(Icons.delete)),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : const Center(child: Text('Корзина пуста')),
    );
  }
}
