import 'package:flutter/material.dart';
class NoDataScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No data available',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}