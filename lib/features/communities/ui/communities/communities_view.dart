import 'package:flutter/material.dart';
import 'communities_view_model.dart';

class CommunitiesView extends StatelessWidget {
  const CommunitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommunitiesViewModelBuilder(
        builder: (context, model) {
          return Scaffold(
            body: Center(
              child: Text('Home'),
            )
          );
        },
      );
  }
}
      