import 'dart:convert';

import 'package:zooper_flutter_id3/exceptions/unsupported_type_exception.dart';
import 'package:zooper_flutter_id3/frames/headers/frame_header.dart';
import 'package:zooper_flutter_id3/headers/id3_header.dart';

import 'frame_content.dart';

class Id3v1FrameContent<T> extends FrameContent {
  late T _value;
  T get value => _value;

  Id3v1FrameContent.decode(
    Id3Header header,
    FrameHeader frameHeader,
    List<int> bytes,
    int startIndex,
  ) : super() {
    decode(bytes, startIndex, frameHeader.identifier.v11Length);
  }

  @override
  void decode(List<int> bytes, int startIndex, int size) {
    var subBytes = _clearZeros(bytes.sublist(startIndex, startIndex + size));

    switch (T) {
      case int:
        _value = subBytes.first as T;
        break;
      default:
        _value = latin1.decode(subBytes) as T;
        break;
    }
  }

  @override
  List<int> encode() {
    if (T is String) {
      return _filledArray(value as String);
    }

    if (T is int) {
      return [value as int];
    }

    throw UnsupportedTypeException(T);
  }

  /// Removes the NULL characters
  ///
  /// [list]Contains the bytes with potential zeros
  List<int> _clearZeros(List<int> list) {
    return list.where((i) => i != 0).toList();
  }

  /// Converts the input to a byte List of a specific size
  ///
  /// [inputString]The string to convert
  /// [size]The size of the outputted List
  List<int> _filledArray(String inputString, [int size = 30]) {
    final s = inputString.length > size ? inputString.substring(0, size) : inputString;
    return latin1.encode(s).toList()..addAll(List.filled(size - s.length, 0));
  }
}
