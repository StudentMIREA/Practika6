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

  // Удаление из корзины
  void DelCart(int i, BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
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
      ),
    ).then((bool? isDeleted) {
      if (isDeleted != null && isDeleted) {
        setState(() {
          ShoppingCart.removeWhere((el) => el.id == i);
          ItemsFromCart = ItemsList.where((item) =>
              ShoppingCart.any((element) => element.id == item.id)).toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Товар успешно удален',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            backgroundColor: Colors.amber[700],
          ),
        );
      }
    });
  }

  // Переход на страницу с товарами
  void NavToItem(index) async {
    int? answ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
            item: ItemsList.firstWhere((element) => element.id == index)),
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
      ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
          .count++;
      _controllers[ItemsFromCart.indexWhere((item) => item.id == index)].text =
          ShoppingCart.elementAt(
              ShoppingCart.indexWhere((el) => el.id == index)).count.toString();
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
    });
  }

  void changeValue(index, text) {
    setState(() {
      if (int.tryParse(text)! < 1 || int.tryParse(text)! > 99) {
        ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
            .count = 1;
        _controllers[ItemsFromCart.indexWhere((item) => item.id == index)]
                .text =
            ShoppingCart.elementAt(
                    ShoppingCart.indexWhere((el) => el.id == index))
                .count
                .toString();
      } else {
        ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
            .count = int.tryParse(text)!;
        _controllers[ItemsFromCart.indexWhere((item) => item.id == index)]
                .text =
            ShoppingCart.elementAt(
                    ShoppingCart.indexWhere((el) => el.id == index))
                .count
                .toString();
      }
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
                SizedBox(
                  height: 30.0,
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                        child: Text(
                          'Количество коваров в корзине: ${ShoppingCart.fold(0, (sum, item) => sum + item.count)}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: ItemsFromCart.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key:
                              Key(ItemsFromCart.elementAt(index).id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _confirmDismiss();
                          },
                          onDismissed: (direction) {
                            setState(() {
                              ShoppingCart.removeWhere((el) => el.id == index);
                              ItemsFromCart = ItemsList.where((item) =>
                                      ShoppingCart.any(
                                          (element) => element.id == item.id))
                                  .toList();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Товар успешно удален',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                                backgroundColor: Colors.amber[700],
                              ),
                            );
                          },
                          background: Container(
                            color: Colors.amber[700],
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              NavToItem(ItemsFromCart.elementAt(index).id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0,
                                  left: 10.0,
                                  top: 2.0,
                                  bottom: 5.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 246, 218),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: Image.network(
                                          ItemsFromCart.elementAt(index).image,
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
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
                                              style:
                                                  const TextStyle(fontSize: 14),
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
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Цена: ',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    '${ItemsFromCart.elementAt(index).cost * ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == ItemsFromCart.elementAt(index).id)).count} ₽',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 6, 196, 9),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 50.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Row(children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () => decrement(
                                                      ItemsFromCart.elementAt(
                                                              index)
                                                          .id),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 30.0,
                                                    child: TextFormField(
                                                      controller: _controllers[
                                                          ItemsFromCart.indexWhere(
                                                              (item) =>
                                                                  item.id ==
                                                                  ItemsFromCart
                                                                          .elementAt(
                                                                              index)
                                                                      .id)],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets.all(0.0),
                                                      ),
                                                      onChanged: (text) => {
                                                        changeValue(
                                                            ItemsFromCart
                                                                    .elementAt(
                                                                        index)
                                                                .id,
                                                            text)
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () => increment(
                                                      ItemsFromCart.elementAt(
                                                              index)
                                                          .id),
                                                ),
                                                /*
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: IconButton(
                                                      onPressed: () => {
                                                            DelCart(
                                                                ItemsFromCart.elementAt(
                                                                        index)
                                                                    .id,
                                                                context)
                                                          },
                                                      icon: const Icon(Icons.delete)),
                                                ),
                                              ),*/
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
                        const Text('Сумма товаров в корзине: '),
                        Text(
                          '${ShoppingCart.fold(0.0, (sum, item) => sum + item.count * ItemsList.elementAt(ItemsList.indexWhere((el) => el.id == item.id)).cost)} ₽',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 6, 196, 9),
                              fontWeight: FontWeight.bold),
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
