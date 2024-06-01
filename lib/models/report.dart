
import 'dart:io';
import 'dart:typed_data';
class MedicalRecord {
  final String filename;
  final String contentType;
  final DateTime uploadDate;
  final int length;
  Uint8List data;

  MedicalRecord({
    required this.filename,
    required this.contentType,
    required this.uploadDate,
    required this.length,
    required this.data,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      filename: json['filename'],
      contentType: json['contentType'],
      uploadDate: DateTime.parse(json['uploadDate']),
      length: json['length'],
      data: Uint8List.fromList((json['data']['data'] as List).map((dynamic item) => item as int).toList()));
  }
}

class UserReport {
  final String type;
   File image;


  UserReport({
    required this.type,
    required this.image,
 
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
        type: json['type'] ?? '',
        image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      
    };
  }
  
  // Method to extract MIME type from the image file
  String getMimeType() {
    // Get the file path from the image File object
    String filePath = image.path;

    // Get the file extension from the file path
    String fileExtension = filePath.split('.').last;

    // Map common file extensions to MIME types
    Map<String, String> mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      // Add more mappings as needed
    };

    // Lookup the MIME type based on the file extension
    String? mimeType = mimeTypes[fileExtension.toLowerCase()];

    // Return the inferred MIME type or a default value
    return mimeType ?? 'application/octet-stream';
  }
}


class UserReport2 {
  final String type;
  Uint8List image;


  UserReport2({
    required this.type,
    required this.image,
 
  });

  factory UserReport2.fromJson(Map<String, dynamic> json) {
    return UserReport2(
        type: json['type'] ?? '',
        image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
      
    };
  }
}
