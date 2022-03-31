import 'dart:convert';

List<Result> resultFromJson(String str) => List<Result>.from(json.decode(str).map((x) => Result.fromJson(x)));

String resultToJson(List<Result> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Result {
    Result({
        required this.title,
        required this.locationType,
        required this.woeid,
        required this.lattLong,
    });

    String title;
    String locationType;
    int woeid;
    String lattLong;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        title: json["title"],
        locationType: json["location_type"],
        woeid: json["woeid"],
        lattLong: json["latt_long"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "location_type": locationType,
        "woeid": woeid,
        "latt_long": lattLong,
    };
}
