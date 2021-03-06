import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wish_list/generated/locale_keys.g.dart';
import 'package:wish_list/services/database.dart';

class NewWishListForm extends StatefulWidget {
  @override
  _NewWishListFormState createState() => _NewWishListFormState();
}

class _NewWishListFormState extends State<NewWishListForm> {
  final _formKey = GlobalKey<FormState>();
  final _listTitleController = TextEditingController();

  final _db = DatabaseService();

  @override
  void dispose() {
    _listTitleController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState.validate()) {
      try {
        _db.createWishList(_listTitleController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Liste \"${_listTitleController.text}\" créée avec succès."),
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
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: TextFormField(
              autofocus: true,
              controller: _listTitleController,
              decoration: InputDecoration(
                hintText: tr(LocaleKeys.forms_wishList_name),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
              onEditingComplete: _handleSubmit,
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
          ),
        ],
      ),
    );
  }
}
