class SurveyMoreModel {
  SurveyMoreModel({
    required this.userid,
    required this.taxAmount,
    required this.lopExplain,
    required this.lockboxPlace,
    required this.rating,
    required this.paymethod,
    required this.timeFrame,
    required this.tab,
    required this.formid,
  });
  String userid;
  var taxAmount,
      lopExplain,
      lockboxPlace,
      timeFrame,
      rating,
      paymethod,
      tab,
      formid;

  // constructor that convert json to object instance
  factory SurveyMoreModel.fromJson(Map<String, dynamic> json) =>
      SurveyMoreModel(
        lockboxPlace: json['lockboxPlace'],
        lopExplain: json['lopExplain'],
        paymethod: json['paymethod'],
        rating: json['rating'],
        taxAmount: json['taxAmount'],
        timeFrame: json['timeFrame'],
        userid: json['user_id'],
        tab: json['survey'],
        formid: json['formid'],
      );

// a method that convert obj to json String
  Map<String, dynamic> toJson() => {
        // more data
        'lockboxPlace': lockboxPlace,
        'lopExplain': lopExplain,
        'paymethod': paymethod,
        'rating': rating,
        'taxAmount': taxAmount,
        'timeFrame': timeFrame,
        'user_id': userid,
        'formid': formid,
        'tab': tab,
      };
}
