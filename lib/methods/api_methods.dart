import 'package:http/http.dart' as http;

class ApiMethods {
  Future getDataFromApi() async {
    final res =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    // dynamic jsonResponse = jsonDecode(res.body);

    return res.body;
  }
}
