import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/screens/areac.dart';
import 'package:intl/intl.dart';

Widget messageList(
    double minExtent,
    double maxExtent,
    double initialExtent,
    UserSelection selection,
    DraggableScrollableController sheetController,
    List<dynamic> records,
  ) {
  return
    DraggableScrollableSheet(
        controller: sheetController,
        minChildSize: minExtent,
        maxChildSize: maxExtent,
        initialChildSize: initialExtent,
        builder:
            (BuildContext context, ScrollController scrollController) =>
            Container(
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
                    final user = FirebaseFirestore.instance
                        .collection("users")
                        .doc(review["email"]).get();

                    DateTime date = (review['write_date'] as Timestamp).toDate().toLocal();

                    return Card.outlined(
                      child:
                        ListTile(
                        title: Text(review["message"] ?? ""),
                        subtitle: Text("${review["email"] ?? ""} - ${DateFormat("yyyy/MM/dd").format(date)}"),
                      )
                    );
                  }
              ))
    );
}