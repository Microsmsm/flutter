



import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/cupertino.dart';

import '../providers/drug.dart';
import '../types/drug.dart';

class DrugModel extends ChangeNotifier {

  String error;
  bool isLoading = true;

  List<Drug> _drugs = [];

  List<Drug> filteredList = [];


  getDrugs() async{
    debugPrint("getDrugs called");
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      debugPrint("calling provider");
      _drugs = await fetchDrugs();
      debugPrint("recived data");
      filteredList = List.from(_drugs);
    }catch(e){
      debugPrint("error: $e");
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
    debugPrint("finished");
  }

  doSearch(term) {
    normalFilter(Drug drug) => drug.tradename.toLowerCase().toString().contains(term);
    fussyFilter(Drug drug){
      var matcher = new DiffMatchPatch();
      matcher.matchThreshold = 0.3;
      matcher.matchDistance = 14;
      return matcher.match(drug.tradename.toLowerCase().toString(), term, 0) >-1?true:false;
    }


    if(filteredList.length >= 1){
      filteredList = _drugs.where(normalFilter).toList();
    }else{
      filteredList = _drugs.where(fussyFilter).toList();
    }
    notifyListeners();
  }


}