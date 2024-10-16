import 'package:flutter/material.dart';
import 'package:pr6/Pages/component/Items.dart';
import 'package:pr6/model/ShoppingCart.dart';
import 'package:pr6/model/items.dart';

class ItemPage extends StatefulWidget {
  const ItemPage(
      {super.key,
      required this.item,
      required this.updateCount,
      required this.navToShopCart});
  final Items item;
  final Function() updateCount;
  final Function(int i) navToShopCart;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int findIndexById(int id) {
    return ItemsList.indexWhere((item) => item.id == id);
  }

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

  void remItem(int i, BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 246, 218),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
            child: Center(
              child: Text(
                'Удалить карточку товара?',
                style: TextStyle(fontSize: 16.00, color: Colors.black),
              ),
            ),
          ),
        ),
        content: const Padding(
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          child: Text(
            'После удаления востановить товар будет невозможно',
            style: TextStyle(fontSize: 14.00, color: Colors.black),
            softWrap: true,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr,
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
          if (ShoppingCart.any((el) => el.id == i)) {
            ShoppingCart.removeWhere((el) => el.id == i);
            widget.updateCount();
          }
          if (Favorite.any((el) => el == i)) {
            Favorite.remove(i);
          }
          Navigator.pop(context, findIndexById(i));
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

  void increment(index) {
    setState(() {
      ShoppingCart.elementAt(ShoppingCart.indexWhere((el) => el.id == index))
          .count++;
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
      } else {
        ShoppingCart.removeWhere((el) => el.id == index);
      }
      widget.updateCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 246, 218),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 246, 218),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                              ),
                              child: Image.network(
                                widget.item.image,
                                width: MediaQuery.of(context).size.width * 0.65,
                                height:
                                    MediaQuery.of(context).size.width * 0.65,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    height: MediaQuery.of(context).size.width *
                                        0.65,
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
                        ),
// товар не добавлен в корзину
                        !ShoppingCart.any((el) => el.id == widget.item.id)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 40.0),
                                child: Row(children: [
                                  const Text(
                                    'Цена: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${widget.item.cost} ₽',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 6, 196, 9),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () =>
                                                {AddShopCart(widget.item.id)},
                                            icon: const Icon(
                                                Icons.shopping_cart_outlined)),
                                        IconButton(
                                            onPressed: () =>
                                                {AddFavorite(widget.item.id)},
                                            icon: Favorite.any((el) =>
                                                    el == widget.item.id)
                                                ? const Icon(Icons.favorite)
                                                : const Icon(
                                                    Icons.favorite_border)),
                                      ],
                                    ),
                                  ),
                                ]),
                              )
// товар добавлен в корзину
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, right: 40.0),
                                    child: Row(children: [
                                      const Text(
                                        'Цена: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '${widget.item.cost} ₽',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 6, 196, 9),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () => {
                                                      AddFavorite(
                                                          widget.item.id)
                                                    },
                                                icon: Favorite.any((el) =>
                                                        el == widget.item.id)
                                                    ? const Icon(Icons.favorite)
                                                    : const Icon(
                                                        Icons.favorite_border)),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 60.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        const Color.fromARGB(
                                                            255, 0, 0, 0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    160,
                                                                    0,
                                                                    1))),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 246, 218),
                                                  ),
                                                  child: const Text("В корзину",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  onPressed: () => {
                                                        widget.navToShopCart(2),
                                                        Navigator.pop(context)
                                                      }),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () =>
                                                    decrement(widget.item.id),
                                                iconSize: 30,
                                              ),
                                              Container(
                                                height: 40.0,
                                                width: 40.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              255, 160, 0, 1),
                                                      width: 2),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    ShoppingCart.elementAt(
                                                            ShoppingCart
                                                                .indexWhere(
                                                                    (el) =>
                                                                        el.id ==
                                                                        widget
                                                                            .item
                                                                            .id))
                                                        .count
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () =>
                                                    increment(widget.item.id),
                                                iconSize: 30,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 0.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 246, 218),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                        child: Text(
                          'О товаре',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 30.0, left: 30.0, right: 30.0),
                        child: Text(
                          widget.item.describtion,
                          style: const TextStyle(fontSize: 14),
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4,
                    bottom: 15.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: const Text(
                    'Удалить карточку товара',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  onPressed: () {
                    remItem(widget.item.id, context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
