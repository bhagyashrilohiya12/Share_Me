import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/result_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:cpr_user/models/place.dart';

class ResultListGeneric<T extends Searchable> extends StatelessWidget {
   List<T>? list;
  bool? isDraftReview;


   ResultListGeneric({
      this.list,
    this.isDraftReview,

  })  ;

  @override
  Widget build(BuildContext context) {
    if (list == null) return Container();
    return Container(
      color: Colors.black,
      child: Column(
        children: list!.map((review) => ResultListTile(result: review as T,isDraftReview: isDraftReview,)).toList(),
      ),
    );
  }
}
