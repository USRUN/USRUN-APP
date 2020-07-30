class CheckBoxItem {
  String content;
  bool isSelected;

  CheckBoxItem({this.content = "", this.isSelected = false})
      : assert(content != null && isSelected != null);
}
