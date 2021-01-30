// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "screens": {
    "register": {
      "title": "Register"
    },
    "signIn": {
      "title": "Sign in"
    },
    "wishList": {
      "title": "Wish Lists"
    }
  },
  "forms": {
    "register": {
      "email": "Email",
      "password": "Password",
      "submit": "Register"
    },
    "signIn": {
      "email": "Email",
      "password": "Password",
      "submit": "Sign in",
      "googleSubmit": "Sign in with Google"
    },
    "wishList": {
      "title": "Add wish list",
      "name": "List name"
    },
    "wish": {
      "title": "New wish",
      "name": "Wish name",
      "description": "Wish description"
    }
  },
  "common": {
    "forms": {
      "delete": "Remove",
      "submit": "Submit"
    }
  }
};
static const Map<String,dynamic> fr = {
  "screens": {
    "register": {
      "title": "S'inscrire"
    },
    "signIn": {
      "title": "Se connecter"
    },
    "wishList": {
      "title": "Listes de vœux"
    }
  },
  "forms": {
    "register": {
      "email": "Adresse mail",
      "password": "Mot de passe",
      "submit": "S'inscrire"
    },
    "signIn": {
      "email": "Adresse mail",
      "password": "Mot de passe",
      "submit": "Se connecter",
      "googleSubmit": "Se connecter avec Google"
    },
    "wishList": {
      "title": "Ajouter une liste",
      "name": "Nom de la liste"
    },
    "wish": {
      "title": "Ajouter un vœu",
      "name": "Nom du vœu",
      "description": "Description du vœu"
    }
  },
  "common": {
    "forms": {
      "delete": "Supprimer",
      "submit": "Valider"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "fr": fr};
}
