import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class CommunitiesViewModelBuilder extends ViewModelBuilder<CommunitiesViewModel> {
  const CommunitiesViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => CommunitiesViewModel();
}

class CommunitiesViewModel extends ViewModel<CommunitiesViewModel> {
   static CommunitiesViewModel of_(BuildContext context) => getModel<CommunitiesViewModel>(context);
}
      