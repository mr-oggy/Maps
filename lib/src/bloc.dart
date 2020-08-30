import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:maps/models/post_model.dart';

import 'package:rxdart/subjects.dart';

class Bloc {
  final _posts = BehaviorSubject<List<PostModel>>();

  Stream<List<PostModel>> get posts => _posts.stream;

  Future<void> init() async {
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      _posts.add(postModelFromJson(response.body));
    } else {
      _posts.addError('Something went wrong');
    }
  }

  void removeData(int index) {
    var temp = _posts.value..removeAt(index);
    _posts.add(temp);
  }

  void dispose() {
    _posts.close();
  }
}
