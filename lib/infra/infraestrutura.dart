import 'package:flutter/material.dart';

/// Classe contendo atributos e métodos utilitários comuns entre todas a telas.
class Infraestrutura {

  //#region Métodos

  /// Exibe uma mensagem padrão de erro em forma de SnackBar.
  static void mostrarMensagemDeErro(BuildContext context, String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

  // /**
  //  * Uses refection (mirrors) to produce a Map (array) from an object's
  //  * variables. Making the variable name the key, and it's value the
  //  * value.
  //  */
  // Map objectToMap(Object object)
  // {
  //   // Mirror the particular instance (rather than the class itself)
  //   InstanceMirror instanceMirror = reflect(object);
  //   Map dataMapped = new Map();
  //
  //   // Mirror the instance's class (type) to get the declarations
  //   for (var declaration in instanceMirror.type.declarations.values)
  //   {
  //     // If declaration is a type of variable, map variable name and value
  //     if (declaration is VariableMirror)
  //     {
  //       String variableName = MirrorSystem.getName(declaration.simpleName);
  //       String variableValue = instanceMirror.getField(declaration.simpleName).reflectee;
  //
  //       dataMapped[variableName] = variableValue;
  //     }
  //   }
  //
  //   return dataMapped;
  // }
  //#endregion Métodos

}