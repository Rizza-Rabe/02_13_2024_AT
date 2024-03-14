

import 'dart:collection';

import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:audit_tracker/MainActivity/answer_audit_form.dart';
import 'package:audit_tracker/Utility/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Utility/default_values.dart';

class AreaList extends StatefulWidget {
  const AreaList({super.key, required this.auditPushKey});
  final String auditPushKey;

  @override
  State<StatefulWidget> createState() => AreaListState();
}

class AreaListState extends State<AreaList>{
  final _loadingDialog = LoadingDialog();
  final _classicDialog = ClassicDialog();
  final List<dynamic> _formsList = List<HashMap<dynamic, dynamic>>() = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeLogic();
    });
    super.initState();
  }

  void _initializeLogic() async {

    await Future.delayed(const Duration(milliseconds: 150));
    _loadAuditForms();
  }

  void _loadAuditForms() async {
    _loadingDialog.showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref("Audit");
    DataSnapshot dataSnapshot;
    try{
      dataSnapshot = await databaseReference.child(widget.auditPushKey).child("fields").get();
    }catch(a){
      if(mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("An error occurred!");
      _classicDialog.setMessage(a.toString());
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      if(mounted) _classicDialog.showOneButtonDialog(context, () {});
      return;
    }

    if(!dataSnapshot.exists){
      if(mounted) _loadingDialog.dismissDialog(context);
      _classicDialog.setTitle("No Fields Found");
      _classicDialog.setMessage("This form does not have any fields yet. Please wait for the admin to add area.");
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      if(mounted) _classicDialog.showOneButtonDialog(context, () {});
      return;
    }

    Map<dynamic, dynamic> map = dataSnapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      _formsList.add(value);
    });
    //_formsList = dataSnapshot.value as List<dynamic>;
    if(mounted) _loadingDialog.dismissDialog(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              "Audit Forms",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: DefaultValues().getAppbarDefaultFontSize()
              ),
            ),
            backgroundColor: Colors.blue,
            iconTheme: const IconThemeData(
                color: Colors.white
            ),
          ),

          body: _formsList.isEmpty ?
          const Center(
            child: Text(
              "No data yet."
            ),
          ): SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width.toInt() ~/ 290 < 2) ? 2 : MediaQuery.of(context).size.width.toInt() ~/ 290, // Number of items in each row
                crossAxisSpacing: 8, // Spacing between items horizontally
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
              itemCount: _formsList.length,
              itemBuilder: (gridContext, gridIndex){
                Map<dynamic, dynamic> indicatorsMap = {};
                Map<dynamic, dynamic> requirementsMap = {};
                List<dynamic> indicatorList = [];
                List<dynamic> requirementsList = [];

                try{
                  indicatorsMap = _formsList[gridIndex]["indicators"];
                }catch(a){
                  indicatorList.clear();
                }
                try{
                  requirementsMap= _formsList[gridIndex]["requirements"];
                }catch(a){
                  requirementsMap.clear();
                }
                indicatorsMap.forEach((key, value) {
                  indicatorList.add(value);
                });
                requirementsMap.forEach((key, value) {
                  requirementsList.add(value);
                });

                  return Container(
                    margin: const EdgeInsets.all(3),
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formsList[gridIndex]["title"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),

                              const Spacer(),

                              Image.asset(
                                "assets/forms.png",
                                width: 70,
                                height: 70,
                              ),

                              const Spacer(),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Indicator(s): ${indicatorList.length}",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context).size.width <= 500) ? 11 : 14
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 15,
                                  ),

                                  Flexible(
                                    child: Text(
                                      "Requirement(s): ${requirementsList.length}",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context).size.width <= 500) ? 11 : 14
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              IgnorePointer(
                                ignoring: indicatorList.isEmpty,
                                child: InkWell(
                                    onTap: (){
                                      if(indicatorList.isEmpty){
                                        return;
                                      }
                                      Utility().printLog("Template pushKey: ${_formsList[gridIndex]["id"].toString()}");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AnswerAuditForm(
                                          formTitle: _formsList[gridIndex]["title"].toString(),
                                          fieldPushKey: _formsList[gridIndex]["id"].toString(),
                                          auditPushKey: widget.auditPushKey)
                                      ));
                                    },

                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        indicatorList.isEmpty ? "Not available" : "Answer Template",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: indicatorList.isEmpty ? Colors.grey : Colors.blue
                                        ),
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  );
              },
            )
          )
        ),
      ),
    );
  }
}