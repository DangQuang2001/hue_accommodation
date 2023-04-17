// import 'package:queue/queue.dart';
// import 'package:http/http.dart' as http;
//
// final Queue queue = Queue(concurrency: 1);
//
// void addToQueue(Function() task) {
//   queue.add(() async {
//     await task();
//   });
// }
//
// void callApi() async {
//   var response = await http.get(Uri.parse('https://example.com/api'));
//   print(response.statusCode);
// }
//
// void main() {
//   addToQueue(() => callApi());
//   addToQueue(() => callApi());
//   addToQueue(() => callApi());
// }
import 'dart:collection';

