import 'package:flutter/material.dart';

class ImageSourceSelectDialog{
  final int cameraSource = 0;
  final int gallerySource = 1;

  void showSourceSelection(BuildContext context, Function(int source) source){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Upload from',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ink(
                        width: 90,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.grey,
                          onTap: (){
                            Navigator.of(context).pop();
                            source(gallerySource);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),

                              Image.asset(
                                'assets/gallery_icon.png',
                                height: 50,
                                width: 50,
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              const Text(
                                  'Gallery',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Ink(
                        width: 90,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.grey,
                          onTap: (){
                            Navigator.of(context).pop();
                            source(cameraSource);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),

                              Image.asset(
                                'assets/camera_icon.png',
                                height: 50,
                                width: 50,
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              const Text(
                                  'Camera',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}