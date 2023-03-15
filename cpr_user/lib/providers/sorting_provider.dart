import 'package:cpr_user/constants/review_sorting.dart';
import 'package:cpr_user/models/review.dart';
import 'package:cpr_user/providers/review_provider.dart';
import 'package:flutter/material.dart';

class SortingProvider with ChangeNotifier{

  List<String> reviewSortOptions = ["Newest", "Oldest", "Highest star", "Lowest star"];
  ReviewProvider reviewProvider;
  String placeId;
  String excludeReview;
  String _selectedOption = "Newest";


  SortingProvider(this.reviewProvider, this.placeId,this.excludeReview ){
    selectOption(_selectedOption);
  }

  set selectedOption(option){
    this._selectedOption = option;
  }

  Future<void> selectOption(value)async{
    this._selectedOption = value;
    await reviewProvider.loadLastReviewByPlace(
        placeId,
        excludeReview: excludeReview,
        sort: sort,
        desc: desc);



  }
  String get selectedOption => this._selectedOption;


  String get sort{
    switch(selectedOption){
      case "Newest":
      case "Oldest":
        return ReviewSorting.CREATION_TIME;
        break;
      case "Highest star":
      case "Lowest star":
        return ReviewSorting.REVIEW;
        break;
    }
    return ReviewSorting.CREATION_TIME;
  }
  bool get desc{
    switch(selectedOption){
      case "Newest":
      case "Highest star":

        return true;
        break;

      case "Lowest star":
      case "Oldest":
        return false;
        break;
    }
    return true;
  }

  void update(){
    notifyListeners();
  }

}