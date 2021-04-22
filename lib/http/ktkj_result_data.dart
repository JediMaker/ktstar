/**
 * 网络结果数据（废弃）
 */
class ResultData {
  var data;
  bool status;
  String errCode;
  String errMsg;
  var headers;

  ResultData(this.data, this.status, this.errCode, {this.errMsg, this.headers});
}
