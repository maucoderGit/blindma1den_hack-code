import 'package:flutter/material.dart';
import 'package:flutter_apps/screens/areac.dart';

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
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      leading: Text("TTTEESSTTT"),
                      subtitle: Text("HEYYY"),
                    );
                  }
              ))
    );
}