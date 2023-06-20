import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/enums.dart';

class UiMethods {
  // static Future showSuccessDialog(
  //     { BuildContext? context,  VoidCallback? onTap, required String text , String? doneText })async{
  // return await  showDialog(context: context??navKey.currentState!.overlay!.context, builder: (context) => SuccessDialog(onTap: onTap, text: text, doneText:doneText,),);
  // }
  //
  // static showErrorDialog(
  //     {BuildContext? context, required String text ,String? doneText }){
  // if( navKey.currentState?.overlay?.context!=null)  showDialog(context: navKey.currentState!.overlay!.context, builder: (context) => ErrorDialog( text: text.toString(), doneText:doneText,),);
  // }
  //
  // static showLanguageDialog(
  //     {required BuildContext context,}){
  //   showDialog(context: context, builder: (context) => const LanguagePicker(),useRootNavigator:true );
  // }
  //
  // static showLoadingDialog(
  //     {required BuildContext context,}){
  //   showDialog(context: context, builder: (context) => const LoadingWidget(),barrierDismissible: false,useRootNavigator:true );
  // }
  static Future<bool?> alertWithTitleDialog({
    required BuildContext context,
    required String title,
    required String description,
    String doneLabel = "Done",
    String cancelLabel = "Cancel",
  }) {
    return showCupertinoDialog<bool?>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        content: Text(
          description,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(
              context,
            ).pop(
              true,
            ),
            child: Text(
              doneLabel,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(
              context,
            ).pop(
              false,
            ),
            child: Text(
              cancelLabel,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static showSnackBar({required String text, required SnakeBarStatus status}) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: status.color(),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future imageTypePick(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Material(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Navigator.pop(context, 0),
                  leading: const Icon(Icons.camera),
                  title: Text(
                    "Use The Camera",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context, 1),
                  leading: const Icon(Icons.image_outlined),
                  title: Text(
                    "Pick From Gallery",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
