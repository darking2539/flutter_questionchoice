import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Network{
  static Query() async{

    const query = """
     query{
        questions{
          question_text
          id
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

      List<String> quest = [];
      List<String> id = [];
      List<String> ans = [];

      for (var i = 0; i < repositories.length; i++){

        var count = repositories[i]['choices'].length;
        var choicer = "";

        for (var j = 0 ; j < count; j++){
          choicer = choicer + (j+1).toString() + ". " + repositories[i]['choices'][j]['choice_text']+  "\n"  ;
        }

        quest.add(repositories[i]['question_text']);
        id.add(repositories[i]['id']);
        ans.add(choicer);
      }

    return [quest,id,ans];
  }

  static addchoices(question_id,choice_text) async{

    const String createChoice = r"""
    mutation CreateChoice($question_id: String!, $choice_text: String!)  {
      createChoice(input: { question_id: $question_id, choice_text: $choice_text }) {
        id
        choice_text
        question{
          id
          question_text
        }
      }
    }
""";

    final MutationOptions options = MutationOptions(
      document: gql(createChoice),
      variables: <String, dynamic>{
        'question_id': question_id,
        'choice_text' :  choice_text
      },
    );

    final HttpLink link = HttpLink(
      "http://192.168.1.117:8080/query",
    );

    GraphQLClient client;
    client = GraphQLClient(link: link, cache: GraphQLCache(),);
    final QueryResult result = await client.mutate(options);

    return result;

  }

}