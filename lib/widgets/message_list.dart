import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/screens/areac.dart';
import 'package:intl/intl.dart';

Widget messageList(
  double minExtent,
  double maxExtent,
  double initialExtent,
  UserSelection selection,
  Function addReview,
  DraggableScrollableController sheetController,
  List<dynamic> records,
) {
  return DraggableScrollableSheet(
      controller: sheetController,
      minChildSize: minExtent,
      maxChildSize: maxExtent,
      initialChildSize: initialExtent,
      builder: (BuildContext context, ScrollController scrollController) =>
          Scaffold(
            backgroundColor: Colors.transparent,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () => addReview(),
                child: const Icon(Icons.rate_review_outlined),
              ),
              body: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(6),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    Map review = records[index];

                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(review["email"])
                            .get(),
                        builder: (context, snap) {
                          DateTime date = (review['write_date'] as Timestamp)
                              .toDate()
                              .toLocal();

                          Map? data = snap.data?.data();

                          if (snap.hasData) {
                            return Card.outlined(
                                child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(
                                      data!["photo"]!,
                                    ),
                                  )),
                              title: Text(data["name"] ?? ""),
                              subtitle: Text(
                                  review["message"]),
                              trailing: 
                                    Text(DateFormat("yyyy/MM/dd").format(date)),
                            ));
                          }

                          return Card.outlined(
                              child: ListTile(
                            title: Text(review["message"] ?? ""),
                            subtitle: Column(
                              children: [
                                Text(
                                    "${review["email"] ?? ""} - ${DateFormat("yyyy/MM/dd").format(date)}"),
                              ],
                            ),
                          ));
                        });
                  }))));
}
