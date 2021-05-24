
import 'package:boss_app/myquestion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'main.dart';

graphql(question,pubdate) async {

  const String addQuestion = r"""
    mutation AddQuestion($question_text: String!, $pub_date: String!)  {
      createQuestion(input: { question_text: $question_text, pub_date: $pub_date }) {
        id
        question_text
        pub_date
      }
    }
""";

  final MutationOptions options = MutationOptions(
    document: gql(addQuestion),
    variables: <String, dynamic>{
      'question_text': question,
      'pub_date' :  pubdate
    },
  );

  final HttpLink link = HttpLink(
    "http://192.168.1.117:8080/query",
  );

  GraphQLClient client;
  client = GraphQLClient(link: link, cache: GraphQLCache(),);
  final QueryResult result = await client.mutate(options);


}

class Addquestion extends StatefulWidget {

  @override
  _AddquestionState createState() => _AddquestionState();
}

class _AddquestionState extends State<Addquestion> {

  TextEditingController questioncontroller = TextEditingController();
  TextEditingController puddatecontroller = TextEditingController();
  @override

  Widget _main() => ListView(padding: EdgeInsets.all(30), children: <Widget>[
    addquestionSelection1(),
    addquestionSelection2(),
    addquestionSelection3(),
    addquestionSelection4()
  ]);

  Widget addquestionSelection1() => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 50),
      child: Text(
        'Add Question',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 30),
      ));

  Widget addquestionSelection2() => Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      controller: questioncontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Question',
      ),
    ),
  );

  Widget addquestionSelection3() => Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      controller: puddatecontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Publish Date',
      ),
    ),
  );

  Widget addquestionSelection4() => Container(
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
          content: Text("Question is add to My question"),
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
    print("Question = ${questioncontroller.text} ");
    print("Puplish date = ${puddatecontroller.text}");
    await graphql(questioncontroller.text,puddatecontroller.text);

    setState((){
      showAlertDialog();
    });
  }

  Widget build(BuildContext context) {
    return _main();
  }
}
