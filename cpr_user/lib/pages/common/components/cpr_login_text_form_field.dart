import 'package:cpr_user/theming/styles.dart';
import 'package:flutter/material.dart';

class CPRLoginTextFormField extends StatelessWidget {

  final TextEditingController _controller;
  final String _hintText;
  final Color _color;
  final IconData _icon;
  final Widget? _progress;
  final bool _oscureText;
  final Function? _onChanged;

    CPRLoginTextFormField({

    required TextEditingController controller,
    String hintText = '',
    Color color = Colors.white,
    bool oscureText = false,
    IconData icon = Icons.info_outline,
       Widget? progress,
       Function? onChanged
  })  : _controller = controller,
        _hintText = hintText,
        _color = color,
        _icon = icon,
        _oscureText = oscureText,
        _progress = progress,
        _onChanged = onChanged ;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: _color),
      controller: _controller,
      onChanged: (v){
        if(_onChanged!=null)
          _onChanged!(v);
      },
      validator: (string) =>
          string == null || string.isEmpty ? "Required" : null,
      obscureText: _oscureText,
      decoration: CPRInputDecorations.cprInput.copyWith(
        suffixIcon: _progress??Icon(
          _icon,
          color: _color,
        ),
        hintText: _hintText,
        hintStyle: CPRTextStyles.buttonSmallWhite
            .copyWith(color: _color, fontSize: 14, fontWeight: FontWeight.w100),
        labelStyle: TextStyle(color: _color),
        helperStyle: TextStyle(color: _color),
        contentPadding: EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(CPRDimensions.loginTextFieldRadius),
          borderSide: BorderSide(color: _color, width: 0.5),
        ),
      ),
    );
  }
}
