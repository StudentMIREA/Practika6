import 'package:flutter/material.dart';
import 'package:pr6/Pages/EditPage.dart';
import 'package:pr6/Pages/component/Person.dart';
import 'package:pr6/model/person.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void navToEdit(BuildContext context) async {
    Person person = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage()),
    );
    setState(() {
      PersonList.removeAt(0);
      PersonList.add(person);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.white70,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(PersonList.elementAt(0).image),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 246, 218),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 35.0),
                      child: Text(
                        PersonList.elementAt(0).name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Телефон: ${PersonList.elementAt(0).phone}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Почта: ${PersonList.elementAt(0).mail}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ))),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () => navToEdit(context),
                                icon: const Icon(Icons.edit)),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
