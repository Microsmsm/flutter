import 'package:dawaey/models/drug_model.dart';
import 'package:dawaey/providers/drug.dart';
import 'package:dawaey/types/drug.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DrugModel model;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){
      model.getDrugs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrugModel>(
      builder: (context,model,_){
        this.model = model;
        return ListView(
          children: <Widget>[
            searchCard(model),
            SizedBox(
              height: MediaQuery.of(context).size.height - 30,
              child: drugList(model),
            )
          ],
        );
      },
    );

  }

  Widget searchCard(DrugModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.search),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Find our product"),
                  onChanged: (text){
                    model.doSearch(text);
                  },
                ),
              ),
              Icon(Icons.menu),
            ],
          ),
        ),
      ),
    );
  }

  Widget drugList(DrugModel model) {
    if (model.error != null){
      return Text("Error: ${model.error}");
    }

    if (model.isLoading){
      return Text("Loading...");
    }

    return new ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        return drugCard(model.filteredList[index]);
      },
    );
  }

  Widget drugCard(Drug drug) {
    return new Column(
      children: <Widget>[
        new ListTile(
            leading: Icon(Icons.healing),
            title: Text(drug.tradename),
            subtitle: drug.activeingredient.length != null
                ? Text(drug.activeingredient)
                : null),
        new Divider(
          height: 2.0,
        ),
      ],
    );
  }
}