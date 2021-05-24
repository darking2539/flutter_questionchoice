
import 'package:boss_app/services/Network.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'main.dart';



class Addchoice extends StatefulWidget {

  @override
  _AddchoiceState createState() => _AddchoiceState();
}

class _AddchoiceState extends State<Addchoice> {

  var dropdownvalue ;
  TextEditingController choicecontroller = TextEditingController();
  List<String> items = [];
  List<String> value = [];

  void initState() {
    super.initState();
    var result = Network.Query().then( (result) =>{
      items = result[0],
      value = result[1],
      setState((){})
    });

  }

  @override
  Widget _main() => ListView(padding: EdgeInsets.all(30), children: <Widget>[
    addchoiceSelection1(),
    addchoiceSelection2(),
    addchoiceSelection3(),
    addchoiceSelection4()
  ]);


  Widget addchoiceSelection1() => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 50),
      child: Text(
        'Add Choices',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 30),
      ));

  Widget addchoiceSelection2() => Container(
    padding: EdgeInsets.all(10),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            hint: Text("Select your question"),
            isExpanded: true,
            value: dropdownvalue,
            onChanged: (newValue) {
              setState(() {
                dropdownvalue = newValue;
                print(dropdownvalue);
              });
            },
            icon: Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(value: items, child: new Text(items));
            }).toList(),

          ),
        ],
      ),
    ),
  );

  Widget addchoiceSelection3() => Container(
    padding: EdgeInsets.fromLTRB(10, 20.8, 10, 10),
    child: TextField(
      controller: choicecontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Choice Text',
      ),
    ),
  );

  Widget addchoiceSelection4() => Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.red,
        child: Text('Submit'),
        onPressed: () {
          submit();
        },
      ));

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Choice is Add Already"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  void submit() async {
    print("Question = $dropdownvalue");
    print("Choices = ${choicecontroller.text}");

    int locate = items.indexOf(dropdownvalue);
    var send = value[locate];

    print("send = $send , choice = ${choicecontroller.text}");
    var result = await Network.addchoices(send, choicecontroller.text);

    showAlertDialog();

    setState((){
    });

  }

  Widget build(BuildContext context) {
    return _main();
  }
}
