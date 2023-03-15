import 'package:cpr_user/bloc/category/category_event.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc {
  @override
  List get initialState => [];

  @override
  Stream<List> mapEventToState(CategoryEvent event) async* {
    switch (event) {
      case CategoryEvent.bars:
        break;
      case CategoryEvent.cafe:
        break;
      case CategoryEvent.hotels:
        break;
      case CategoryEvent.restaurants:
        break;
      case CategoryEvent.salon:
        break;
      default:
        break;
    }
    yield [];
  }
}
