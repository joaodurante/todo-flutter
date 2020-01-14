import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../model.dart/Task.dart';
import './Home.dart';

class Completed extends StatefulWidget {
  @override
  CompletedState createState() => CompletedState();
}

class CompletedState extends State<Completed> {
  static const DB_TABLE = 'tasks';
  DatabaseHelper db = DatabaseHelper.instance;
  List<Task> _list = [];

  /* Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();
    _query().then((list) => setState(() => _list = list));
  }

  @override
  Widget build(BuildContext context) {
    _query().then((list) => _list = list);

    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Center(
        child: Row(children: <Widget>[_buildList(_list)],)
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Todo List',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()
                    )
                );
              },
            ),
            ListTile(
              title: Text('Completed'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      )
    );
  }

  /* Return ListView Widget */
  Widget _buildList(List<Task> list) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            padding: EdgeInsets.only(left: 10.0),
            child: ListTile(
              title: Text(
                list[index].description,
              ),
              subtitle: Text(
                '${list[index].updateAt.hour}:${list[index].updateAt.minute} '
                '${list[index].updateAt.day}/${list[index].updateAt.month}',
                style: TextStyle(color: Colors.black45),
              ),
            )
          );
        }
      )
    );
  }

  /* Get all the completed tasks stored in database */
  Future<List<Task>> _query() async {
    final data = await db.rawQuery(
      'SELECT * FROM $DB_TABLE WHERE done = 1'
    );
    
    List<Task> list = [];

    data.forEach((i) {
      bool done = i['done'] == 1 ? true : false;
      DateTime createdAt = DateTime.parse(i['createdAt']);
      DateTime updateAt = DateTime.parse(i['updateAt']);
      list.add(Task(i['id'], i['description'], done, createdAt, updateAt));
    });

    return list;
  }
}