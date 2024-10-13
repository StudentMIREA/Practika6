import 'package:flutter/material.dart';
import 'package:pr6/Pages/ItemPage.dart';
import 'package:pr6/Pages/component/Items.dart';
import 'package:pr6/model/items.dart';

class ShopCartPage extends StatefulWidget {
  const ShopCartPage(
      {super.key, required this.updateCount, required this.navToShopCart});

  final Function() updateCount;
  final Function(int i) navToShopCart;

  @override
  State<ShopCartPage> createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  List<Items> ItemsFromCart = ItemsList.where(
      (item) => ShoppingCart.any((element) => element.id == item.id)).toList();

  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < ItemsFromCart.length; i++) {
      _controllers.add(TextEditingController(
        text: ShoppingCart.elementAt(
                ShoppingCart.indexWhere((el) => el.id == ItemsFromCart[i].id))
            .count
            .toString(),
      ));
    }
  }

  int findIndexById(int id) {
    return ItemsList.indexWhere((item) => item.id == id);
  }

  // Удаление из корзины
  Future<bool?> _confirmDismiss() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 246, 218),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Удалить товар из корзины?',
                  style: TextStyle(fontSize: 16.00, color: Colors.black),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
              child: const Text('Ок',
                  style: TextStyle(color: Colors.black, fontSize: 14.0)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Отмена',
                  style: TextStyle(color: Colors.black, fontSize: 14.0)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> confirmDismiss() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 246, 218),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Удалить товар из корзины?',
                  style: TextStyle(fontSize: 16.00, color: Colors.black),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
              child: const Text('Ок',
                  style: TextStyle(color: Colors.black, fontSize: 14.0)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Отмена',
                  style: TextStyle(color: Colors.black, fontSize: 14.0)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  // Переход на страницу с товарами
  void NavToItem(index) async {
    int? answ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
          item: ItemsList.firstWhere((element) => element.id == index),
          updateCount: () => widget.updateCount(),
          navToShopCart: (i) => widget.navToShopCart(i),
        ),
      ),
    );
    setState(() {
      if (answ != null) {
        ItemsList.removeAt(answ);
      }

      ItemsFromCart = ItemsList.where(
              (item) => ShoppingCart.any((element) => element.id == item.id))
          .toList();
    });
    void initState() {
      super.initState();
      for (var i = 0; i < ItemsFromCart.length; i++) {
        _controllers = [];
        _controllers.add(TextEditingController(
          text: ShoppingCart.elementAt(
                  ShoppingCart.indexWhere((el) => el.id == ItemsFromCart[i].id))
              .count
              .toString(),
        ));
      }
    }
  }

  void increment(index) {
    setState(() {
      if (ShoppingCart.elementAt(
              ShoppingCart.indexWhere((el) => el.id == index)).count <
          99) {
        ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
            .count++;
        _controllers[ItemsFromCart.indexWhere((item) => item.id == index)]
                .text =
            ShoppingCart.elementAt(
                    ShoppingCart.indexWhere((el) => el.id == index))
                .count
                .toString();
      }
      widget.updateCount();
    });
  }

  void decrement(index) {
    setState(() {
      if (ShoppingCart.elementAt(
              ShoppingCart.indexWhere((el) => el.id == index)).count >
          1) {
        ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
            .count--;
        _controllers[ItemsFromCart.indexWhere((item) => item.id == index)]
                .text =
            ShoppingCart.elementAt(
                    ShoppingCart.indexWhere((el) => el.id == index))
                .count
                .toString();
      }
      widget.updateCount();
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
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: ItemsFromCart.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return index == ItemsFromCart.length
                            ? SizedBox(
                                height: 30.0,
                                child: Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 5.0),
                                      child: Text(
                                        'Количество товаров в корзине: ${ShoppingCart.fold(0, (sum, item) => sum + item.count)}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
// удаление с помощью свайпа влево
                            : Dismissible(
                                key: Key(ItemsFromCart.elementAt(index)
                                    .id
                                    .toString()),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await _confirmDismiss();
                                },
                                onDismissed: (direction) {
                                  setState(() {
                                    int itemId =
                                        ItemsFromCart.elementAt(index).id;
                                    ShoppingCart.removeWhere(
                                        (el) => el.id == itemId);
                                    ItemsFromCart = ItemsList.where((item) =>
                                        ShoppingCart.any((element) =>
                                            element.id == item.id)).toList();
                                    _controllers = [];
                                    for (var i = 0;
                                        i < ItemsFromCart.length;
                                        i++) {
                                      _controllers.add(TextEditingController(
                                        text: ShoppingCart.elementAt(
                                                ShoppingCart.indexWhere((el) =>
                                                    el.id ==
                                                    ItemsFromCart[i].id))
                                            .count
                                            .toString(),
                                      ));
                                    }

                                    widget.updateCount();
                                  });
                                },
                                background: Container(
                                  color: Colors.amber[700],
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
// карточка товара
                                child: GestureDetector(
                                  onTap: () {
                                    NavToItem(
                                        ItemsFromCart.elementAt(index).id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0,
                                        left: 10.0,
                                        top: 2.0,
                                        bottom: 5.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 246, 218),
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1),
                                              ),
                                              child: Image.network(
                                                ItemsFromCart.elementAt(index)
                                                    .image,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const CircularProgressIndicator();
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    color: Colors.amber[200],
                                                    child: const Center(
                                                        child: Text(
                                                      'нет картинки',
                                                      softWrap: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0,
                                                right: 5.0,
                                                left: 10.0,
                                                bottom: 10.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 50.0,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Text(
                                                    '${ItemsFromCart.elementAt(index).name}',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20.0,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Цена: ',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          '${ItemsFromCart.elementAt(index).cost * ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == ItemsFromCart.elementAt(index).id)).count} ₽',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      6,
                                                                      196,
                                                                      9),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                ),
//изменение количества товара
                                                SizedBox(
                                                  height: 50.0,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 5.0),
                                                    child: Row(children: [
                                                      IconButton(
                                                        icon:
                                                            Icon(Icons.remove),
                                                        onPressed: () => decrement(
                                                            ItemsFromCart
                                                                    .elementAt(
                                                                        index)
                                                                .id),
                                                      ),
                                                      Container(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromRGBO(255,
                                                                  160, 0, 1),
                                                              width: 2),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            ShoppingCart
                                                                    .elementAt(
                                                                        index)
                                                                .count
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () => increment(
                                                            ItemsFromCart
                                                                    .elementAt(
                                                                        index)
                                                                .id),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 246, 218),
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(255, 224, 130, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Сумма товаров: '),
                        Text(
                          '${ShoppingCart.fold(0.0, (sum, item) => sum + item.count * ItemsList.elementAt(ItemsList.indexWhere((el) => el.id == item.id)).cost)} ₽',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 6, 196, 9),
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(255, 160, 0, 1))),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 246, 218),
                                ),
                                child: const Text("Купить",
                                    style: TextStyle(fontSize: 12)),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : const Center(child: Text('Корзина пуста')),
    );
  }
}
