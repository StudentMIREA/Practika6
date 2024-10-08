import 'package:flutter/material.dart';
import 'package:pr5/Pages/component/Items.dart';
import 'package:pr5/model/items.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.item});
  final Items item;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int findIndexById(int id) {
    return ItemsList.indexWhere((item) => item.id == id);
  }

  void AddFavorite(int index) {
    setState(() {
      ItemsList.elementAt(findIndexById(index)).favorite
          ? ItemsList.elementAt(findIndexById(index)).favorite = false
          : ItemsList.elementAt(findIndexById(index)).favorite = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text(widget.item.name),
        backgroundColor: const Color.fromARGB(255, 255, 246, 218),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.item.favorite);
          },
        ),
      ),
      body: Container(
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
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Image.network(
                              widget.item.image,
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width * 0.65,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const CircularProgressIndicator();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  height:
                                      MediaQuery.of(context).size.width * 0.65,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
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
                        ]),
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
            widget.item.favorite
                ? Expanded(
                    child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        child: const Text(
                          'Удалить из избранного',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        onPressed: () {
                          AddFavorite(widget.item.id);
                        },
                      ),
                    ),
                  ))
                : Expanded(
                    child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(255, 160, 0, 1))),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 246, 218),
                        ),
                        child: const Text("Добавить в избранное",
                            style: TextStyle(fontSize: 15)),
                        onPressed: () {
                          AddFavorite(widget.item.id);
                        },
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
