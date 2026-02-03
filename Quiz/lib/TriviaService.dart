//////////////////////////////////////////////////
//SERVICE
//Classe per gestire le chiamate API
class TriviaService {
  static const String baseUrl = 'https://opentdb.com/api.php';

  //Metodo per recuperare le domande dall'API
  static Future<List<Question>> fetchQuestions({
    int amount = 10,           
    String? category,         
    String? difficulty,      
  }) async {
    String url = '$baseUrl?amount=$amount';
    if (category != null) url += '&category=$category';
    if (difficulty != null) url += '&difficulty=$difficulty';

    //chiamata HTTP GET
    final response = await http.get(Uri.parse(url));

    //(status code 200)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      //successo nell'API di OpenTriviaDB
      if (data['response_code'] == 0) {
        return (data['results'] as List)
            .map((q) => Question.fromJson(q))
            .toList();
      }
    }
    throw Exception('Errore nel caricamento delle domande');
  }
}