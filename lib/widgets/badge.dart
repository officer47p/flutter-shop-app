import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;
  Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        if (int.parse(value) > 0)
          Positioned(
            right: 3,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color != null ? color : Theme.of(context).accentColor,
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minHeight: 16,
                minWidth: 16,
                maxHeight: 30,
                maxWidth: 30,
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Arial",
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
