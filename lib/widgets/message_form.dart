import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/constants/border_radius.dart';
import 'package:flutter_apps/models/review.dart';
import 'package:flutter_apps/models/user.dart';
import 'package:flutter_apps/screens/areac.dart';
import 'package:flutter_apps/widgets/custom_text_input.dart';

Widget registerMessageWidget(
  double minExtent,
  double maxExtent,
  double initialExtent,
  UserSelection selection,
  double latitude,
  double longitude,
  DraggableScrollableController sheetController,
  BuildContext context,
  Function reloadPoint,
  UserDB user,
  String? identifier,
) {
  String message = "";

  return DraggableScrollableSheet(
      controller: sheetController,
      minChildSize: minExtent,
      maxChildSize: maxExtent,
      initialChildSize: initialExtent,
      builder: (BuildContext context, ScrollController scrollController) =>
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: NetworkImage(
                            user.photo!,
                          ),
                        )),
                          title: const Text("Comparte tu experiencia!"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(191, 191, 191, 1.0)),
                                    borderRadius: cardRadius(),
                                  ),
                                  child: CustomTextInput(
                                    hintText:
                                        'Describe tu experiencia con todos los usuarios. \n\nTu mensaje puede ahorrar muchos malos momentos.',
                                    userTyped: (value) {
                                      message = value;
                                    },
                                    obscure: false,
                                    defaultValue: "",
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.transparent,
                                  disabledForegroundColor: Colors.grey),
                              onPressed: () async {
                                try {
                                  Review coordinateReview = Review(
                                      email: user.email,
                                      message: "",
                                      longitude: longitude,
                                      latitude: latitude,
                                      writeDate: DateTime.now(),
                                      storedMessages: [
                                        {
                                          "message": message,
                                          "email": user.email,
                                          "write_date": DateTime.now(),
                                        }
                                      ]);

                                  if (identifier == null) {
                                    FirebaseFirestore.instance
                                        .collection('zoneReviews')
                                        .add(coordinateReview.toFirestore());
                                  } else {
                                    final record = await FirebaseFirestore.instance
                                        .collection('zoneReviews')
                                        .doc(identifier)
                                        .withConverter(
                                        fromFirestore: Review.fromFirestore,
                                        toFirestore: (Review review, _) => review.toFirestore())
                                        .get();

                                    List messages = record.data()!.storedMessages;

                                    messages.insert(0,
                                        {
                                          "message": message,
                                          "email": user.email,
                                          "write_date": DateTime.now(),
                                        });

                                    FirebaseFirestore.instance
                                        .collection('zoneReviews')
                                        .doc(identifier)
                                        .update({"messages": messages});
                                  }

                                  identifier = null;

                                  sheetController.animateTo(0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.bounceIn);

                                  reloadPoint();
                                } on FirebaseAuthException catch (e) {
                                  rethrow;
                                }
                              },
                              child: const Text("Enviar mensaje"),
                            ),
                          ],
                        ),
                      ],
                    )),
              )));
}
