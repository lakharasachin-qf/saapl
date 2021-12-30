class OEMModel {
  OEMModel({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  OEMModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.MACHCOMPID,
    required this.MACHCOMP,
  });
  late final int MACHCOMPID;
  late final String MACHCOMP;

  Data.fromJson(Map<String, dynamic> json){
    MACHCOMPID = json['MACHCOMPID'];
    MACHCOMP = json['MACHCOMP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['MACHCOMPID'] = MACHCOMPID;
    _data['MACHCOMP'] = MACHCOMP;
    return _data;
  }

  static List<Data> fromJsonList(List list) {
    return list.map((item) => Data.fromJson(item)).toList();
  }


}