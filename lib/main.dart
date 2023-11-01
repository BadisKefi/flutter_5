import 'package:flutter/material.dart';
import 'package:flutter_application_5/util/dbuse.dart';
import 'package:flutter_application_5/models/scol_list.dart';
import 'package:flutter_application_5/ui/students_screen.dart';
import 'package:flutter_application_5/ui/scol_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Classes List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ShList());
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  late ScolListDialog dialog; // i added this manually the late
  @override
  void initState() {
    dialog = ScolListDialog();
    super.initState();
  }

  List<ScolList> scolList = [];
  dbuse helper = dbuse();
  @override
  Widget build(BuildContext context) {
    ScolListDialog dialog = ScolListDialog();
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text(' Classes list'),
      ),
      body: ListView.builder(
          itemCount: (scolList != null) ? scolList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(scolList[index].nomClass),
              onDismissed: (direction) {
                String strName = scolList[index].nomClass;
                //helper.deleteList(scolList[index]);
                setState(() {
                  scolList.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("$strName deleted")));
              },
              child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentsScreen(scolList[index])),
                    );
                  },
                  title: Text(scolList[index].nomClass),
                  leading: CircleAvatar(
                    child: Text(scolList[index].codClass.toString()),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog.buildDialog(
                              context, scolList[index], false));
                    },
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ScolList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }
}
