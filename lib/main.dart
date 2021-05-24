/// ABossZZ App

import 'package:boss_app/addchoices.dart';
import 'package:boss_app/myquestion.dart';
import 'package:boss_app/addquestion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


///void main() => runApp(MyApp());

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink link = HttpLink(
    "http://192.168.1.117:8080/query",
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link
    ),
  );

  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {



  int _selectedIndex = 0;

  //For TextStyle in
  late TextEditingController _controller;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Myquestion(),
    Addquestion(),
    Addchoice()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question-Answer ABoss App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'My Question',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_add),
            label: 'Add Question',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_sharp),
            label: 'Add Choices',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
