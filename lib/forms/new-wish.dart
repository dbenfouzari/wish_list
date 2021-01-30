import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/generated/locale_keys.g.dart';
import 'package:wish_list/models/wish-list.dart';
import 'package:wish_list/services/database.dart';

class NewWishForm extends StatefulWidget {
  final WishList wishList;

  NewWishForm({Key key, @required this.wishList});

  @override
  _NewWishFormState createState() => _NewWishFormState();
}

class _NewWishFormState extends State<NewWishForm> {
  final _formKey = GlobalKey<FormState>();
  final _wishTitle = TextEditingController();
  final _wishDescription = TextEditingController();

  final _db = DatabaseService();

  @override
  void dispose() {
    _wishTitle.dispose();
    _wishDescription.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState.validate()) {
      try {
        _db.createWish(_wishTitle.text, _wishDescription.text, widget.wishList);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).backgroundColor,
            content: Text(
              "Vœu \"${_wishTitle.text}\" créée avec succès.",
            ),
          ),
        );
        Navigator.of(context).pop();
      } catch (error) {
        print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            controller: _wishTitle,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: tr(LocaleKeys.forms_wish_name),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Veuillez entrer le nom du vœu.";
              }
              return null;
            },
          ),
          TextFormField(
            autofocus: true,
            controller: _wishDescription,
            maxLines: 5,
            textInputAction: TextInputAction.done,
            onEditingComplete: _handleSubmit,
            decoration: InputDecoration(
              hintText: tr(LocaleKeys.forms_wish_description),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    tr(LocaleKeys.common_forms_submit),
                  ),
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
