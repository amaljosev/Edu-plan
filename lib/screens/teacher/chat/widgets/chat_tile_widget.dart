import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

UnconstrainedBox chatTile(bool sender, 
    {
    required int index,
    required Size size,
    required DocumentSnapshot<Object?> chat,
    required DateTime dateTime,
    required bool isTeacher,
    required Function isSelected}) {
  return UnconstrainedBox(
    alignment: isTeacher
        ? sender
            ? Alignment.bottomRight
            : Alignment.bottomLeft
        : sender
            ? Alignment.bottomLeft
            : Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Stack(
            children: [
              isSelected(index)
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    )
                  : Row(),
              Container(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: titleColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['message'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: isTeacher
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Text(
                            "${DateFormat('H:mm').format(dateTime)}",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
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
