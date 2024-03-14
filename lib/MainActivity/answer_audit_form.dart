import 'dart:collection';
import 'dart:convert';
import 'package:audit_tracker/Dialogs/classic_dialog.dart';
import 'package:audit_tracker/Dialogs/loading_dialog.dart';
import 'package:audit_tracker/TimeAndDate/time_and_date.dart';
import 'package:audit_tracker/Utility/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Utility/default_values.dart';

class AnswerAuditForm extends StatefulWidget{
  const AnswerAuditForm({super.key, required this.formTitle, required this.fieldPushKey, required this.auditPushKey});
  final String formTitle;
  final String fieldPushKey;
  final String auditPushKey;

  @override
  State<StatefulWidget> createState() => AnswerAuditFormState();

}

class AnswerAuditFormState extends State<AnswerAuditForm>{
  final _classicDialog = ClassicDialog();
  final _loadingDialog = LoadingDialog();
  final _indicatorAnswers = List<dynamic>() = [];
  final _indicators = List<dynamic>() = [];

  String? _conditionals;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeLogic();
    });
    super.initState();
  }

  void _initializeLogic() async {
    Utility().printLog("Form pushKey: ${widget.fieldPushKey}");

    await Future.delayed(const Duration(milliseconds: 150));
    _getFormDetails();
  }

  void _getFormDetails() async {
    _loadingDialog.showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref("Audit");
    DataSnapshot dataSnapshot;
    try{
      dataSnapshot = await databaseReference.child(widget.auditPushKey).child("fields").child(widget.fieldPushKey).child("indicators").get();
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
      _classicDialog.setTitle("Audit form not exist");
      _classicDialog.setMessage("The audit form that you are trying to answer does not exist. This may be because the admin removed it from the list.");
      _classicDialog.setPositiveButtonTitle("Close");
      _classicDialog.setCancelable(false);
      if(mounted) _classicDialog.showOneButtonDialog(context, () {});
      return;
    }

    final Map<dynamic, dynamic> map = dataSnapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      _indicators.add(value);
    });
    
    if(mounted) _loadingDialog.dismissDialog(context);
    Utility().printLog("Indicators data: $_indicators");
    Utility().printLog("Indicator count: ${_indicators.length}");
    setState(() {});
  }

  void _submitForm() async {

  }

  void _saveAsDraft() async {

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
              widget.formTitle,
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

          body: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                width: 700,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                    side: const BorderSide(
                      color: Colors.black, // Set border color
                      width: 1.0,         // Set border width
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _indicators.length,
                        itemBuilder: (context, index2){

                          _indicatorAnswers.clear();
                          for(int a = 0; a < _indicators.length; a++){
                            HashMap<dynamic, dynamic> data = HashMap();
                            data["indicatorId"] = _indicators[a]["id"].toString();
                            data["indicatorTitle"] = _indicators[a]["title"].toString();
                            data["governanceArea"] = widget.formTitle;
                            data["governanceAreaId"] = widget.fieldPushKey;
                            data["indicatorAnswer"] = "N/A";
                            _indicatorAnswers.insert(a, data);
                          }

                          Utility().printLog("Indicators DATA: ${_indicators[index2]["dataInputMethod"]}");
                          Map<dynamic, dynamic> data = _indicators[index2]["dataInputMethod"] as Map<dynamic, dynamic>;
                          Utility().printLog("VALUE: ${data["value"]}");
                          _conditionals = data["type"];
                          List<dynamic> checkBoxTitles = [];
                          List<dynamic> radioButtonTitle = [];

                          if(_conditionals == "check_box" && data["value"] != null){
                            Utility().printLog("Value: ${data["value"].toString()}");
                            checkBoxTitles = jsonDecode(data["value"].toString());
                            Utility().printLog("Check box title: ${checkBoxTitles.length}");
                          }

                          if(_conditionals == "radio_button" && data["value"] != null){
                            Utility().printLog("Value: ${data["value"].toString()}");
                            radioButtonTitle = jsonDecode(data["value"].toString());
                            Utility().printLog("Radio button title: ${radioButtonTitle.length}");
                          }

                          String radioButtonValue = "none";
                          String? selectedDate = "Tap to select date";
                          var textFieldInputTextController = TextEditingController();
                          List<dynamic> checkBoxTicked = List<dynamic>() = [];

                          return Container(
                              margin: const EdgeInsets.only(left: 3, right: 3, top: 1, bottom: 1),
                              child: Container(
                                margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200]
                                ),
                                child: ListTile(
                                    title: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          _indicators[index2]["title"].toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),

                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _indicators[index2]["id"].toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 20,
                                          ),

                                          _conditionals == "numMin%" ?
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                textInputAction: TextInputAction.next,
                                                maxLines: 1,
                                                autofocus: false,
                                                controller: textFieldInputTextController,
                                                decoration: const InputDecoration(
                                                    labelStyle: TextStyle(color: Colors.black),
                                                    focusColor: Colors.black,
                                                    hintStyle: TextStyle(color: Colors.black),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black)
                                                    ),
                                                    labelText: 'Enter here',
                                                    border: OutlineInputBorder()
                                                ),

                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                onChanged: (text){
                                                  if(text.isNotEmpty){
                                                    _indicatorAnswers[index2]["indicatorAnswer"] = text;
                                                  }else {
                                                    _indicatorAnswers[index2]["indicatorAnswer"] = "N/A";
                                                  }

                                                  Utility().printLog("Answer: $_indicatorAnswers");
                                                },
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                    onTap: () async {

                                                    },

                                                    splashColor: Colors.blue,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/upload.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),

                                                          const SizedBox(
                                                            width: 10,
                                                          ),

                                                          const Text(
                                                            "Upload MOV file",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              )
                                            ],
                                          ): _conditionals == "radio_button" ?
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              StatefulBuilder(
                                                builder: (statefulContext, statefulSetState){
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: radioButtonTitle.length,
                                                    itemBuilder: (context, radioIndex){
                                                      return RadioListTile<String>(
                                                        title: Text(radioButtonTitle[radioIndex].toString()),
                                                        value: radioButtonTitle[radioIndex].toString(),
                                                        groupValue: radioButtonValue,
                                                        onChanged: (value) {
                                                          radioButtonValue = value!;
                                                          _indicatorAnswers[index2]["indicatorAnswer"] = value;
                                                          Utility().printLog("Answer: $_indicatorAnswers");
                                                          Utility().printLog("Radio button value: $radioButtonValue");
                                                          statefulSetState(() {});
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                    onTap: () async {

                                                    },

                                                    splashColor: Colors.blue,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/upload.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),

                                                          const SizedBox(
                                                            width: 10,
                                                          ),

                                                          const Text(
                                                            "Upload MOV file",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              )
                                            ],
                                          ): _conditionals == "check_box" ?
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: checkBoxTitles.length,
                                                itemBuilder: (context, checkBoxIndex){
                                                  bool checkBoxValue = false;

                                                  return Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: StatefulBuilder(
                                                      builder: (statefulContext, statefulSetState){
                                                        return InkWell(
                                                          onTap: (){
                                                            if(checkBoxValue == false){
                                                              checkBoxTicked.add(checkBoxTitles[checkBoxIndex]);
                                                              checkBoxValue = true;
                                                            }else {
                                                              checkBoxTicked.remove(checkBoxTitles[checkBoxIndex]);
                                                              checkBoxValue = false;
                                                            }
                                                            String decodedCheckBoxAnswer = jsonEncode(checkBoxTicked);
                                                            if(checkBoxTicked.isEmpty){
                                                              _indicatorAnswers[index2]["indicatorAnswer"] = "N/A";
                                                            }else {
                                                              _indicatorAnswers[index2]["indicatorAnswer"] = decodedCheckBoxAnswer;
                                                            }

                                                            Utility().printLog("Answer: $_indicatorAnswers");
                                                            statefulSetState(() {});
                                                          },

                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Checkbox(
                                                                  value: checkBoxValue,
                                                                  onChanged: (value){
                                                                    checkBoxValue = value!;
                                                                    if(value == false){
                                                                      checkBoxTicked.remove(checkBoxTitles[checkBoxIndex]);
                                                                    }else {
                                                                      checkBoxTicked.add(checkBoxTitles[checkBoxIndex]);
                                                                    }
                                                                    String decodedCheckBoxAnswer = jsonEncode(checkBoxTicked);
                                                                    if(checkBoxTicked.isEmpty){
                                                                      _indicatorAnswers[index2]["indicatorAnswer"] = "N/A";
                                                                    }else {
                                                                      _indicatorAnswers[index2]["indicatorAnswer"] = decodedCheckBoxAnswer;
                                                                    }

                                                                    Utility().printLog("Answer: $_indicatorAnswers");
                                                                    statefulSetState(() {});
                                                                  }
                                                              ),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),

                                                              Text(
                                                                  checkBoxTitles[checkBoxIndex]
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                    onTap: () async {

                                                    },

                                                    splashColor: Colors.blue,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/upload.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),

                                                          const SizedBox(
                                                            width: 10,
                                                          ),

                                                          const Text(
                                                            "Upload MOV file",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              )
                                            ],
                                          ): _conditionals == "date" ?
                                          StatefulBuilder(
                                            builder: (stateContext, statefulSetState){
                                              return InkWell(
                                                onTap: () async {
                                                  selectedDate = await TimeAndDate().showDatePickerDialog(context);
                                                  Utility().printLog("Selected date: $selectedDate");
                                                  if(selectedDate == null){
                                                    _indicatorAnswers[index2]["indicatorAnswer"] = "N/A";
                                                  }else {
                                                    _indicatorAnswers[index2]["indicatorAnswer"] = selectedDate;
                                                  }

                                                  statefulSetState((){
                                                    Utility().printLog("Trigger!");
                                                  });
                                                },

                                                splashColor: Colors.blue,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      "assets/calendar.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),

                                                    const SizedBox(
                                                      width: 10,
                                                    ),

                                                    Text(
                                                      selectedDate == null ? "Tap to select date" : selectedDate!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ): _conditionals == "upload_button" ?
                                          StatefulBuilder(
                                            builder: (stateContext, statefulSetState){
                                              return InkWell(
                                                onTap: () async {

                                                },

                                                splashColor: Colors.blue,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      "assets/upload.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),

                                                    const SizedBox(
                                                      width: 10,
                                                    ),

                                                    const Text(
                                                      "Upload Files",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ): const Text(
                                              "Rating Bar"
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              )
                          );
                        },
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: (){

                                  },

                                  style: ButtonStyle(
                                    textStyle: const MaterialStatePropertyAll(
                                        TextStyle(
                                            fontSize: 16
                                        )
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(100, 45)
                                    ),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        return Colors.white24;
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save as Draft",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              ),

                              const SizedBox(
                                width: 15,
                              ),

                              TextButton(
                                  onPressed: (){
                                    _classicDialog.setTitle("Submit Form?");
                                    _classicDialog.setMessage("Are you sure you want to submit the form? Please double check before submitting.");
                                    _classicDialog.setCancelable(false);
                                    _classicDialog.setPositiveButtonTitle("Submit");
                                    _classicDialog.setNegativeButtonTitle("Cancel");
                                    _classicDialog.showTwoButtonDialogWithFunc(context, (positiveClicked) {

                                    }, (negativeClicked) {

                                    });
                                  },
                                  style: ButtonStyle(
                                    textStyle: const MaterialStatePropertyAll(
                                        TextStyle(
                                            fontSize: 16
                                        )
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(100, 45)
                                    ),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        return Colors.white24;
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Submit Now",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

}