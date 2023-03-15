import 'package:cpr_user/pages/user/search_places_and_reviews/search_places_and_reviews_page.dart';
import 'package:fastor_app_ui_widget/fastor_app_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryListItem extends StatelessWidget {
  String name;
  int index;
  String? imageAddress;
  int total;

  CategoryListItem(this.name, this.index,this.total,{this.imageAddress});

  @override
  Widget build(BuildContext context) {
    Log.i( "page  - CategoryListItem - build");

    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Get.to(SearchPlacesAndReviewsPage(category: null, categoryName: name));
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: (index==0)?Radius.circular(5):Radius.zero,
                    topRight: (index==0)?Radius.circular(5):Radius.zero,
                    bottomLeft: (index==total-1)?Radius.circular(5):Radius.zero,
                    bottomRight: (index==total-1)?Radius.circular(5):Radius.zero),
              ),
              child: Row(
                children: [
                  if (imageAddress != null)
                    Image(
                      image: AssetImage(imageAddress!),
                      height: 28,
                      width: 28,
                    )
                  else
                    SizedBox(
                      height: 28,
                    ),
                  if (imageAddress != null)
                    SizedBox(
                      width: 16,
                    ),
                  Expanded(
                      child: Text(
                    this.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  if (imageAddress == null)
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Divider(
            height: 1,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
