import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wish_list/generated/locale_keys.g.dart';

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
          caption: tr(LocaleKeys.common_forms_delete),
          color: Colors.redAccent,
          icon: Icons.delete_forever,
          onTap: onDelete,
        ),
      ],
      child: child,
    );
  }
}
