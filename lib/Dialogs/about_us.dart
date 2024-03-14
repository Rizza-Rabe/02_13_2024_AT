

import 'package:flutter/material.dart';

import '../Utility/default_values.dart';

class AboutUs{

  void showAboutUsDialog(BuildContext mainContext) async {
    showDialog(
        barrierDismissible: true,
        useSafeArea: true,
        context: mainContext,
        builder: (dialogContext){
          return PopScope(
            canPop: true,
            child: AlertDialog(
              insetPadding: DefaultValues().dialogContentPadding(),
              content: SizedBox(
                width: DefaultValues().getDefaultWidth(),
                child: const SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "About Us",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Department of the Interior and Local Government",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}