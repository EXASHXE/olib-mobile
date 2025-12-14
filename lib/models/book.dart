import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    @JsonKey(fromJson: _toInt) required int id,
    @JsonKey(name: 'content_type') String? contentType,
    required String title,
    String? author,
    String? volume,
    @JsonKey(fromJson: _toInt) int? year,
    String? edition,
    String? publisher,
    String? identifier,
    String? language,
    @JsonKey(fromJson: _toInt) int? pages,
    String? series,
    String? cover,
    @JsonKey(name: 'terms_hash') String? termsHash,
    @JsonKey(fromJson: _toInt) int? active,
    @JsonKey(fromJson: _toInt) int? deleted,
    @JsonKey(fromJson: _toInt) int? filesize,
    @JsonKey(name: 'filesizeString') String? filesizeString,
    String? extension,
    String? md5,
    String? sha256,
    String? href,
    String? hash,
    @JsonKey(name: 'kindleAvailable') bool? kindleAvailable,
    @JsonKey(name: 'sendToEmailAvailable') bool? sendToEmailAvailable,
    @JsonKey(name: 'interestScore') String? interestScore,
    @JsonKey(name: 'qualityScore') String? qualityScore,
    String? dl,
    @JsonKey(name: 'readOnlineUrl') String? readOnlineUrl,
    String? description,
    @JsonKey(name: '_isUserSavedBook') bool? isUserSavedBook,
    @JsonKey(name: 'readOnlineAvailable') bool? readOnlineAvailable,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

// Helpers
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
int? _toIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
