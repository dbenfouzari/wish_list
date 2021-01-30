import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableActions extends StatelessWidget {
  final Widget child;
  final void Function() onDelete;

  SlidableActions({ Key key, this.child, this.onDelete });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.5,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Supprimer',
          color: Colors.redAccent,
          icon: Icons.delete_forever,
          onTap: onDelete,
        ),
      ],
      child: child,
    );
  }
}
