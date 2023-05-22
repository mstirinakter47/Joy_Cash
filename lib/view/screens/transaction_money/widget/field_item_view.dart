import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_cash/data/model/withdraw_model.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/view/base/custom_text_field.dart';

class FieldItemView extends StatelessWidget {
  final MethodField methodField;
  final Map<String, TextEditingController> textControllers;
  const FieldItemView({Key key, this.methodField, this.textControllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Text(
                '${methodField.inputName.replaceAll('_', ' ').formattedUpperCase()}',
                style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

              if(methodField.inputType == 'phone') Text(
                '*${'must_use_country_code'.tr}',
                style: rubikRegular.copyWith(color: Theme.of(context).errorColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),

        CustomTextField(
          controller: textControllers[methodField.inputName],
          hintText:  methodField.placeHolder,
          inputType:  _getType(methodField.inputType),
          fillColor: Theme.of(context).cardColor,
          isPassword: methodField.inputType == 'password',
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  TextInputType _getType(String type) {
    switch(type) {
      case 'number': {
        return TextInputType.number;
      }
      break;

      case 'date': {
        return TextInputType.datetime;
      }
      break;

      case 'password': {
        return TextInputType.visiblePassword;
      }
      break;

      case 'email': {
        return TextInputType.emailAddress;
      }
      break;

      case 'phone': {
        return TextInputType.phone;
      }
      break;

      default: {
        return TextInputType.text;
      }
      break;
    }
  }
}

extension StringExtension on String {
  String formattedUpperCase() => replaceAllMapped(
      RegExp(r'(?<= |-|^).'), (match) => match[0].toUpperCase());
}

const INDEX_NOT_FOUND = -1;


class DateInputFormatter extends TextInputFormatter {
  String _placeholder = '--/----';
  TextEditingValue _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.isEmpty) {
      oldValue = oldValue.copyWith(
        text: _placeholder,
      );
      newValue = newValue.copyWith(
        text: _fillInputToPlaceholder(newValue.text),
      );
      return newValue;
    }

    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    if (offset > 7) {
      return oldValue;
    }

    if (oldValue.text == newValue.text && oldValue.text.length > 0) {
      return newValue;
    }

    final String oldText = oldValue.text;
    final String newText = newValue.text;
    String resultText;

    int index = _indexOfDifference(newText, oldText);
    if (oldText.length < newText.length) {

      String newChar = newText[index];
      if (index == 2 ) {
        index++;
        offset++;
      }
      resultText = oldText.replaceRange(index, index + 1, newChar);
      if (offset == 2) {
        offset++;
      }
    } else if (oldText.length > newText.length) {
      if (oldText[index] != '/') {
        resultText = oldText.replaceRange(index, index + 1, '-');
        if (offset == 2) {
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    return oldValue.copyWith(
      text: resultText,
      selection: TextSelection.collapsed(offset: offset),
      composing: defaultTargetPlatform == TargetPlatform.iOS
          ? TextRange(start: 0, end: 0)
          : TextRange.empty,
    );
  }

  int _indexOfDifference(String cs1, String cs2) {
    if (cs1 == cs2) {
      return INDEX_NOT_FOUND;
    }
    if (cs1 == null || cs2 == null) {
      return 0;
    }
    int i;
    for (i = 0; i < cs1.length && i < cs2.length; ++i) {
      if (cs1[i] != cs2[i]) {
        break;
      }
    }
    if (i < cs2.length || i < cs1.length) {
      return i;
    }
    return INDEX_NOT_FOUND;
  }

  String _fillInputToPlaceholder(String input) {
    if (input == null || input.isEmpty) {
      return _placeholder;
    }
    String result = _placeholder;
    final index = [0, 1, 3, 4, 6, 7, 8, 9];
    final length = min(index.length, input.length);
    for (int i = 0; i < length; i++) {
      result = result.replaceRange(index[i], index[i] + 1, input[i]);
    }
    return result;
  }
}
