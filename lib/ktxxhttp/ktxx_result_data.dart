/**
 * 网络结果数据
 */
class KeTaoFeaturedResultData {
  var data;
  bool status;
  String errCode;
  String errMsg;
  var headers;

  KeTaoFeaturedResultData(this.data, this.status, this.errCode, {this.errMsg, this.headers});
}
