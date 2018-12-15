import 'package:dawaey/types/drug.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Drug>>fetchDrugs() async{
  var response = await http.get('https://dawaey.com/api/v3/eg/drugs.json');
  var l = json.decode(response.body)['drugs'] as List;
  List<Drug> drugs = l.map((model)=> Drug.fromJson(model)).toList();
  print('done');
  return drugs;
}
