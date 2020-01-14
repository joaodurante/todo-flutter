import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../model.dart/Task.dart';
import './Completed.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              _buildForm(),
              _buildList(_list)
            ],
          )
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
                },
              ),
              ListTile(
                title: Text('Completed'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Completed()),
                  );
                },
              )
            ],
          ),
        )
      ); 
  }

  /* Return Form Widget */
  Widget _buildForm() {
    TextEditingController inputController = new TextEditingController();
    var _formKey = GlobalKey<FormState>();

    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: TextFormField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: 'Enter your task'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if(_formKey.currentState.validate()){
                  _insert(inputController.text);
                  _query().then((list) => setState(() => _list = list));
                }
              },
              child: Text('Add task'),
            )
          ],
        ),
      ),
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
              trailing: Icon(
                Icons.check_circle_outline,
                size: 30.0,
                color: Colors.black26,
              ),
              onTap: () {
                _complete(list[index].id);
                _query().then((list) => setState(() => _list = list));
              },
            ),
          );
        },
      ),
    );
  }

  /* Get all the tasks that is not completed yet */
  Future<List<Task>> _query() async {
    final data = await db.rawQuery(
      'SELECT * FROM $DB_TABLE WHERE done = 0'
    );
    
    List<Task> list = [];

    data.forEach((i) {
      bool done = i['done'] == 1 ? true : false;
      DateTime date = DateTime.parse(i['createdAt']);
      list.add(Task(i['id'], i['description'], done, date));
    });

    return list;
  }

  /* Insert a new task in dabatase */
  void _insert(String description) async {
    String date = DateTime.now().toString();
    Map<String, dynamic> row = {
      'description': description,
      'done': 0,
      'createdAt': date,
      'updateAt': date
    };

    await db.insert(DB_TABLE, row);
  }

  /* Complete a task using it's id */
  void _complete(int id) async {
    String date = DateTime.now().toString();
    await db.rawUpdate('UPDATE $DB_TABLE SET done = 1, updateAt = \'$date\' WHERE id = $id');
  }
}