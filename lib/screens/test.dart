import 'dart:collection';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

final faker = new Faker();

const double ITEM_HEIGHT = 60.0;

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final List<String> namesList = List.generate(200, (index) => faker.person.name());

  @override
  Widget build(BuildContext context) {
    final _listViewController = ScrollController();

    namesList.sort();

    Set<String> lettersSet = Set();
    for (String pc in namesList) {
      lettersSet.add(pc[0]);
    }
    List<String> letters = lettersSet.toList();
    letters.sort();

    SplayTreeMap<String, Set<String>> groupedContacts = SplayTreeMap();

    for (String pc in namesList) {
      if (!groupedContacts.containsKey(pc[0])) {
        /// If a key is missing, add it
        groupedContacts[pc[0]] = Set<String>();
      }

      /// Then add a name as well
      groupedContacts[pc[0]].add(pc);
    }

    goToLetter(String letter) {
      int totalNamesBetween = 0;

      for (var key in groupedContacts.keys) {
        if (key != letter) {
          totalNamesBetween += groupedContacts[key].length;
        } else {
          break;
        }
      }

      _listViewController.jumpTo(totalNamesBetween * ITEM_HEIGHT);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: SafeArea(
        child: Container(
          child: Row(
            children: [
              Container(
                child: Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: _listViewController,
                    itemExtent: ITEM_HEIGHT,
                    itemCount: namesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Center(
                              child: Text(
                                namesList[index],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: letters
                    .asMap()
                    .map((index, letter) => MapEntry(
                          index,
                          Expanded(
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(letter),
                              ),
                              onTap: () {
                                goToLetter(letter);
                              },
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
