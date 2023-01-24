
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/sqlhelper/sqlhelper.dart';
import 'package:sqflite/sqflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _journal = [];
  bool _isloading = true;
  double? height;
  double? width;


   _refreshjournal() async{
    var data = await SQLHelper.getItems();
      setState(() {
        _journal = data;
        _isloading = false;
      });
      return _journal;
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _description = TextEditingController();


  Future<void> _addItem()async{
    await SQLHelper.createItem(
        _titleController.text,
        _description.text);
      _refreshjournal();
    print('...number of items ${_journal.length ?? 1000}');
  }

  void _delete(int id)async{
    await SQLHelper.deleteItem(id);
    _refreshjournal();
  }

    void _showForm(int? id)async{
      if(id != null){
      final existingJournal =
          _journal.firstWhere((element) => element['id'] == id);
        _titleController.text = existingJournal['title'];
        _description.text = existingJournal['description'];
     }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_)=> Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom+120,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                SizedBox(height: 30,),
                TextField(
                  controller: _description,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: ()async{
                      if(id == null){
                        await _addItem();
                      }
                      if(id != null){
                        //await _updateItem(id);
                      }
                      _titleController.text = "";
                      _description.text = "";
                      Navigator.pop(context);
                    },
                    child: Text("Create New")
                   ),
              ],
            ),
          ),
       ));
    }



  @override
  void initState() {
    _refreshjournal();
    print('...number of items ${_journal.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          body:  ListView.builder(
              itemCount: _journal.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange,
                child: ListTile(
                  title: Text(_journal[index]['id'].toString()),
                  subtitle: Text(_journal[index]["title"].toString()),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        InkWell(child: Icon(Icons.edit),
                        onTap: (){
                          _showForm(_journal[index]['id']);
                        }),
                        SizedBox(width: 20,),
                        InkWell(child: Icon(Icons.delete),
                            onTap: (){
                          _delete(_journal[index]['id']);
                            }),
                      ],
                    ),
                  ),
                ),
              )
          ),
          // Column(
          //   children: [
          //     //Text('${_journal.length}'),
          //   //  Text('${_journal.map((e) => e.values)}'),
          //   //   ListView.builder(
          //   //     itemCount: _journal.length,
          //   //       itemBuilder: (context, index) => Card(
          //   //         color: Colors.orange,
          //   //         child: ListTile(
          //   //           title: Text(_journal[index]['id']),
          //   //           //subtitle: Text(_journal[index["title"]),
          //   //         ),
          //   //       )
          //   //   ),
          //     // TextButton(onPressed: (){
          //     //   setState(() {
          //     //   });
          //     // }, child: Text("Delete"))
          //   ],
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
                 _showForm(null);
            },
            child: Icon(Icons.add),
          ),
        ),
    );
  }
}
