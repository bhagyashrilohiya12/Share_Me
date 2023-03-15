import 'package:cpr_user/interfaces/searchable.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/pages/common/components/result_itemlist_review.dart';
import 'package:cpr_user/pages/common/components/result_list_tile.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/material.dart';

import 'package:cpr_user/models/place.dart';

class ResultListReview <T extends Searchable> extends StatelessWidget {
   List<Review?>? list;
  bool? isDraftReview;


   ResultListReview({
      this.list,
    this.isDraftReview,

  })  ;

  @override
  Widget build(BuildContext context) {


    if (list == null) return Container();

    Log.i( "ResultListReview() - list " + list!.length.toString() );

    return Container(
      color: Colors.black,
      child: Column(
        children: getListWidgetChildren()
      ),
    );
  }


  List<Widget> getListWidgetChildren(){
    /**+
     * #Abdo
        list!.map((review) => ResultListTile(result: review as T,isDraftReview: isDraftReview,)).toList(),
      */
    List<Widget> listResult = [];
    if( list == null ) return listResult;
    if( list!.isEmpty ) return listResult;

    list!.forEach((element) {

      if( element != null ) {
        var w = ResultItemListReview( element );
        listResult.add( w );
      }
      // var w = ResultListTile(result: element as T,isDraftReview: isDraftReview,);

    });

    return listResult;
  }
}
