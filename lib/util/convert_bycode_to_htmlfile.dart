// import 'dart:async';
// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart';

// Future<html.File> applyChangesToImage(String imageFile) async {
//   // Read the image file as bytes
//   final reader = html.FileReader();
//   final completer = Completer<List<int>>();
//   reader.onLoadEnd.listen((_) {
//     completer.complete(reader.result as List<int>);
//   });
//   reader.readAsArrayBuffer(imageFile);
//   final List<int> fileBytes = await completer.future;

//   // Decode the image
//   Image? image = decodeImage(fileBytes);

//   if (image != null) {
//     // Convert the image to grayscale
//     Image grayscaleImage = grayscale(image);

//     // Encode the image back to bytes
//     List<int> modifiedBytes = encodeJpg(grayscaleImage);

//     // Create a Blob from the bytes
//     html.Blob blob = html.Blob([modifiedBytes]);

//     // Create an html.File from the Blob
//     html.File modifiedImageFile = html.File([blob], imageFile.name, {'type': 'image/jpeg'});

//     return modifiedImageFile;
//   } else {
//     throw Exception('Could not decode image');
//   }
// }
