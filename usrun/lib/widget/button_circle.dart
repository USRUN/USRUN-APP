import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {

  ButtonCircle({
    @required 
      this.onPressed,
      this.textColor,
      this.color,
      this.shapeBorder,
    @optionalTypeArgs
      this.icon,
      this.string,
      this.height,
      this.iconSize


  });

  final GestureTapCallback onPressed;
  final Color textColor;
  final Color color;
  final ShapeBorder shapeBorder;
  final String icon;
  final String string;
  final double height;
  final double iconSize;
  


  Widget _detectIconOrText() {

    return Center(
        child: icon != null ? Container(
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(icon)
                        )
                    ))
         : Text (string, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),  
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RawMaterialButton(
      constraints: BoxConstraints(
        minHeight: height ?? size.width/5,
        minWidth: height ?? size.width/5,
        maxHeight: height ?? size.width/5,
        maxWidth: height ?? size.width/5,
      ),
      onPressed: onPressed,
      fillColor: color,
      shape: shapeBorder,
      child: _detectIconOrText(),
    );
  }


}