import 'package:flutter/material.dart';

class NoDataScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Record found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}