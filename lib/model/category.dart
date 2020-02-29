class CategoryBigModel {
  String mallCategoryId;
  String mallCategoryName;
  List<dynamic> bxMallSunDto;
  Null comments;
  String image;

  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSunDto,
    this.comments,
    this.image});

  factory CategoryBigModel.fromJson(dynamic json){
    return CategoryBigModel(
        mallCategoryId: json['mallCategoryId'],
        mallCategoryName: json['mallCategoryName'],
        bxMallSunDto: json['bxMallSunDto'],
        comments: json['comments'],
        image: json['image']
    );
  }
}

class CategoryBigListModel {
  List<CategoryBigModel> data;

  CategoryBigListModel(this.data);

  factory CategoryBigListModel.fromJson(List json){
    return CategoryBigListModel(
        json.map((i) => CategoryBigModel.fromJson(i)).toList()
    );
  }

}

class BxMallSubDto{
  String mallSubId;
  String mallCategoryId;
  String mallCategoryName;
  String comments;

  BxMallSubDto(this.mallSubId, this.mallCategoryId, this.mallCategoryName,
      this.comments);

   BxMallSubDto.fromJson(Map<String,dynamic>json){
    mallSubId: json['mallSubId'];
    mallCategoryId: json['mallCategoryId'];
    mallCategoryName: json['mallCategoryName'];
    comments: json['comments'];
  }
}
