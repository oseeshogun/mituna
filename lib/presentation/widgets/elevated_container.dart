part of 'all.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    super.key,
    this.background = Colors.white,
    this.shadowColor = Colors.deepPurpleAccent,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 15.0,
    ),
    this.margin = const EdgeInsets.symmetric(horizontal: 30.0),
    required this.child,
  });

  final Color background;
  final Color shadowColor;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 1.0,
            spreadRadius: 3.0,
            offset: const Offset(-2.0, 4.0),
          ),
        ],
      ),
      margin: margin,
      padding: padding,
      child: child,
    );
  }
}
