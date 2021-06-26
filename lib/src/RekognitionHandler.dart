import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'Signature.dart';

class RekognitionHandler {
  final String _accessKey, _secretKey, _region;

  RekognitionHandler(this._accessKey, this._secretKey, this._region);

  Future<String> _rekognitionHttp(String amzTarget, String body) async {
    String endpoint = "https://rekognition.$_region.amazonaws.com/";
    String host = "rekognition.$_region.amazonaws.com";
    String httpMethod = "POST";
    String service = "rekognition";

    var now = new DateTime.now().toUtc();
    var amzFormatter = new DateFormat("yyyyMMdd'T'HHmmss'Z'");
    String amzDate =
        amzFormatter.format(now); // format should be '20170104T233405Z"

    var dateFormatter = new DateFormat('yyyyMMdd');
    String dateStamp = dateFormatter.format(
        now); // Date w/o time, used in credential scope. format should be "20170104"

    int bodyLength = body.length;

    String queryStringParamters = "";
    Map<String, String> headerParamters = {
      "content-length": bodyLength.toString(),
      "content-type": "application/x-amz-json-1.1",
      "host": host,
      "x-amz-date": amzDate,
      "x-amz-target": amzTarget
    };

    String signature = Signature.generateSignature(
        endpoint,
        service,
        _region,
        _secretKey,
        httpMethod,
        now,
        queryStringParamters,
        headerParamters,
        body);

    String authorization =
        "AWS4-HMAC-SHA256 Credential=$_accessKey/$dateStamp/$_region/$service/aws4_request, SignedHeaders=content-length;content-type;host;x-amz-date;x-amz-target, Signature=$signature";
    headerParamters.putIfAbsent('Authorization', () => authorization);

    //String labelsArray = "";
    StringBuffer builder = new StringBuffer();
    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(endpoint));

      request.headers.set('content-length', headerParamters['content-length']);
      request.headers.set('content-type', headerParamters['content-type']);
      request.headers.set('host', headerParamters['host']);
      request.headers.set('x-amz-date', headerParamters['x-amz-date']);
      request.headers.set('x-amz-target', headerParamters['x-amz-target']);
      request.headers.set('Authorization', headerParamters['Authorization']);

      request.write(body);

      HttpClientResponse response = await request.close();

      await for (String a in utf8.decoder.bind(response)) {
        builder.write(a);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(builder.toString());
  }

  Future<String> detectFaces(File imagefile) async {
    try {
      List<int> imageBytes = imagefile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String body =
          '{"Image":{"Bytes": "$base64Image"}, "Attributes": ["ALL"], "MaxLabels": 7}';
      // Edited by Mahmoud to add => "Attributes": ["ALL"] because EyesOpen
      // Label wasn't listed in the JSON file
      String amzTarget = "RekognitionService.DetectFaces";

      String response = await _rekognitionHttp(amzTarget, body);
      return response;
    } catch (e) {
      print(e);
      return "{}";
    }

    /*
    Output will be in this format
      {
         "FaceDetails": [
            {
               "AgeRange": {
                  "High": number,
                  "Low": number
               },
               "Beard": {
                  "Confidence": number,
                  "Value": boolean
               },
               "BoundingBox": {
                  "Height": number,
                  "Left": number,
                  "Top": number,
                  "Width": number
               },
               "Confidence": number,
               "Emotions": [
                  {
                     "Confidence": number,
                     "Type": "string"
                  }
               ],
               "Eyeglasses": {
                  "Confidence": number,
                  "Value": boolean
               },
               "EyesOpen": {
                  "Confidence": number,
                  "Value": boolean
               },
               "Gender": {
                  "Confidence": number,
                  "Value": "string"
               },
               "Landmarks": [
                  {
                     "Type": "string",
                     "X": number,
                     "Y": number
                  }
               ],
               "MouthOpen": {
                  "Confidence": number,
                  "Value": boolean
               },
               "Mustache": {
                  "Confidence": number,
                  "Value": boolean
               },
               "Pose": {
                  "Pitch": number,
                  "Roll": number,
                  "Yaw": number
               },
               "Quality": {
                  "Brightness": number,
                  "Sharpness": number
               },
               "Smile": {
                  "Confidence": number,
                  "Value": boolean
               },
               "Sunglasses": {
                  "Confidence": number,
                  "Value": boolean
               }
            }
         ],
         "OrientationCorrection": "string"
      }
    */
  }
}
