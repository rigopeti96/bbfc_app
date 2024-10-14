import 'package:bbfc_application/entity/user.dart';
import 'package:flutter/material.dart';

class MatchReportPage extends StatefulWidget {
  final User actUser;
  const MatchReportPage({super.key, required this.actUser});

  @override
  MatchReportPageState createState() => MatchReportPageState();
}

class MatchReportPageState extends State<MatchReportPage> {
  int value = 2;

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: ListView.builder(
          itemCount: this.value,
          itemBuilder: (context, index) => this._buildRow(index)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }

  _buildRow(int index) {
    return Text("Item " + index.toString());
  }
}