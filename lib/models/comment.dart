import "package:flutter/material.dart";

class Comment{
  String? text;
  String? date;
  String? writer;

  // toJson
  Map<String,dynamic> toJson(Comment data){
    return {
      'text': data.text,
      'date': data.date,
      'writer': data.writer,
    };
  }
  // fromJson
  Comment.fromJson(Map<String,dynamic> json){
    text = json['text'];
    date = json['date'];
    writer = json['writer'];
  }
}
