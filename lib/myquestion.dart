
import 'package:boss_app/services/Network.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

graphql() async {

  print("graphql void");

  const query = """
   query{
      questions{
        question_text
		    choices{
          choice_text
    }
    }
  }

  """;

  final QueryOptions options = QueryOptions(
    document: gql(query),
  );

  final HttpLink link = HttpLink(
    "http://192.168.1.117:8080/query",
  );
  GraphQLClient client;
  client = GraphQLClient(link: link, cache: GraphQLCache(),);
  //print("client = $client");
  final QueryResult result = await client.query(options);
  final List repositories = result.data['questions'];
  return repositories;

}


class Myquestion extends StatefulWidget {


  @override
  _MyquestionState createState() => _MyquestionState();
}

class _MyquestionState extends State<Myquestion> {

  List<String> questions = [];
  List<String> choices = [];
  int range = 0;


  void initState() {
    super.initState();
    var result = Network.Query().then( (result) =>{
      questions = result[0],
      choices = result[2],
      range = questions.length,
      print("rangeeeeeee = $range"),
      setState((){})
    });
  }

  @override
  Widget _main() => ListView(children: <Widget>[
    questionSelection1(),
    questionSelection2(),
  ]);

  Widget questionSelection1() => Card(
    child: ListTile(
      onTap: (){
        refreshvalue();
      },
      leading: Icon(Icons.question_answer),
      trailing: Icon(Icons.refresh) ,
      title: Text('MyQuestions', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget questionSelection2() => ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: range,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: questionSelectiontemplate(questions[index],choices[index]),
        );
      }
  );


  Widget questionSelectiontemplate(question,choice) => Card(
    child: ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(question),
      subtitle: Text(choice),
    ),
  );


  Widget build(BuildContext context) {
    return _main();
  }

  void refreshvalue() async {

    final result = await graphql();
    List<String> quest = [];
    List<String> ans = [];

    for (var i = 0; i < result.length; i++){
      var count = result[i]['choices'].length;
      var choicer = "";
      for (var j = 0 ; j < count; j++){
          choicer = choicer + (j+1).toString() + ". " + result[i]['choices'][j]['choice_text']+  "\n"  ;
      }

      quest.add(result[i]['question_text']);
      ans.add(choicer);
    }

    questions = quest;
    choices = ans;
    range = questions.length;

    print("quest = $questions");



    setState((){
    });
  }

}
