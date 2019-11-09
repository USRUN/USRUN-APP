import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final GestureTapCallback onTap;
  final Gradient gradient;
  final Color color;
  final String text;
  final Color textColor;
  final double textSize;
  final bool enable;
  final Border border;

  UIButton({
    this.width = double.maxFinite,
    this.height = 55,
    this.radius = 4,
    this.onTap,
    this.gradient,
    this.color,
    this.text,
    this.textColor = Colors.white,
    this.textSize = 16,
    this.enable = true,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Gradient gr;
    Color cl;
    if (this.enable) {
      gr = this.gradient;
      cl = this.color;
    }
    else {
      gr = null;
      cl = Color(0xff979797);
    }


    return GestureDetector(
      child: Container(
        width: this.width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(this.radius)),
          border: this.border,
          gradient: gr,
          color: cl,
        ),
        child: Text(text, style: TextStyle(fontSize: this.textSize, color: this.textColor)),
      ),
      onTap: this.enable ? this.onTap : null,
    );
  }
}

class UIImageButton extends StatelessWidget {
  final Image image;
  final double width;
  final double height;
  final GestureTapCallback onTap;

  UIImageButton({
    this.image,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        child: this.image,
      ),
    );
  }
}
