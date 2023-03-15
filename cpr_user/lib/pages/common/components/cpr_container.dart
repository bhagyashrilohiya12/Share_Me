import 'package:flutter/material.dart';

/**
 * Abdallah documentation:
 *   class carry child content page, with loading view at Stack
 */
class CPRContainer extends StatelessWidget {
  final Widget child;
  final Widget loadingWidget;
  final bool rounded;
    CPRContainer(
      {
      required this.child,
      required this.loadingWidget,
      this.rounded = false})
       ;

  @override
  Widget build(BuildContext context) {
    Widget cs = child;
    if (rounded) {
      cs = Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[cs, loadingWidget],
    );
  }
}
