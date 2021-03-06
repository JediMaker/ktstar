// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:star/models/vip_price_entity.dart';
import 'package:star/generated/json/vip_price_entity_helper.dart';
import 'package:star/models/alipay_payinfo_entity.dart';
import 'package:star/generated/json/alipay_payinfo_entity_helper.dart';
import 'package:star/models/wechat_payinfo_entity.dart';
import 'package:star/generated/json/wechat_payinfo_entity_helper.dart';
import 'package:star/models/result_bean_entity.dart';
import 'package:star/generated/json/result_bean_entity_helper.dart';
import 'package:star/models/home_entity.dart';
import 'package:star/generated/json/home_entity_helper.dart';
import 'package:star/models/task_submit_info_entity.dart';
import 'package:star/generated/json/task_submit_info_entity_helper.dart';
import 'package:star/models/task_detail_entity.dart';
import 'package:star/generated/json/task_detail_entity_helper.dart';
import 'package:star/models/user_info_entity.dart';
import 'package:star/generated/json/user_info_entity_helper.dart';
import 'package:star/models/login_entity.dart';
import 'package:star/generated/json/login_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case VipPriceEntity:
			return vipPriceEntityFromJson(data as VipPriceEntity, json) as T;			case VipPriceData:
			return vipPriceDataFromJson(data as VipPriceData, json) as T;			case AlipayPayinfoEntity:
			return alipayPayinfoEntityFromJson(data as AlipayPayinfoEntity, json) as T;			case AlipayPayinfoData:
			return alipayPayinfoDataFromJson(data as AlipayPayinfoData, json) as T;			case WechatPayinfoEntity:
			return wechatPayinfoEntityFromJson(data as WechatPayinfoEntity, json) as T;			case WechatPayinfoData:
			return wechatPayinfoDataFromJson(data as WechatPayinfoData, json) as T;			case WechatPayinfoDataPayInfo:
			return wechatPayinfoDataPayInfoFromJson(data as WechatPayinfoDataPayInfo, json) as T;			case ResultBeanEntity:
			return resultBeanEntityFromJson(data as ResultBeanEntity, json) as T;			case HomeEntity:
			return homeEntityFromJson(data as HomeEntity, json) as T;			case HomeData:
			return homeDataFromJson(data as HomeData, json) as T;			case HomeDataBanner:
			return homeDataBannerFromJson(data as HomeDataBanner, json) as T;			case HomeDataTaskList:
			return homeDataTaskListFromJson(data as HomeDataTaskList, json) as T;			case HomeDataTaskListList:
			return homeDataTaskListListFromJson(data as HomeDataTaskListList, json) as T;			case TaskSubmitInfoEntity:
			return taskSubmitInfoEntityFromJson(data as TaskSubmitInfoEntity, json) as T;			case TaskSubmitInfoData:
			return taskSubmitInfoDataFromJson(data as TaskSubmitInfoData, json) as T;			case TaskDetailEntity:
			return taskDetailEntityFromJson(data as TaskDetailEntity, json) as T;			case TaskDetailData:
			return taskDetailDataFromJson(data as TaskDetailData, json) as T;			case UserInfoEntity:
			return userInfoEntityFromJson(data as UserInfoEntity, json) as T;			case UserInfoData:
			return userInfoDataFromJson(data as UserInfoData, json) as T;			case LoginEntity:
			return loginEntityFromJson(data as LoginEntity, json) as T;			case LoginData:
			return loginDataFromJson(data as LoginData, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case VipPriceEntity:
			return vipPriceEntityToJson(data as VipPriceEntity);			case VipPriceData:
			return vipPriceDataToJson(data as VipPriceData);			case AlipayPayinfoEntity:
			return alipayPayinfoEntityToJson(data as AlipayPayinfoEntity);			case AlipayPayinfoData:
			return alipayPayinfoDataToJson(data as AlipayPayinfoData);			case WechatPayinfoEntity:
			return wechatPayinfoEntityToJson(data as WechatPayinfoEntity);			case WechatPayinfoData:
			return wechatPayinfoDataToJson(data as WechatPayinfoData);			case WechatPayinfoDataPayInfo:
			return wechatPayinfoDataPayInfoToJson(data as WechatPayinfoDataPayInfo);			case ResultBeanEntity:
			return resultBeanEntityToJson(data as ResultBeanEntity);			case HomeEntity:
			return homeEntityToJson(data as HomeEntity);			case HomeData:
			return homeDataToJson(data as HomeData);			case HomeDataBanner:
			return homeDataBannerToJson(data as HomeDataBanner);			case HomeDataTaskList:
			return homeDataTaskListToJson(data as HomeDataTaskList);			case HomeDataTaskListList:
			return homeDataTaskListListToJson(data as HomeDataTaskListList);			case TaskSubmitInfoEntity:
			return taskSubmitInfoEntityToJson(data as TaskSubmitInfoEntity);			case TaskSubmitInfoData:
			return taskSubmitInfoDataToJson(data as TaskSubmitInfoData);			case TaskDetailEntity:
			return taskDetailEntityToJson(data as TaskDetailEntity);			case TaskDetailData:
			return taskDetailDataToJson(data as TaskDetailData);			case UserInfoEntity:
			return userInfoEntityToJson(data as UserInfoEntity);			case UserInfoData:
			return userInfoDataToJson(data as UserInfoData);			case LoginEntity:
			return loginEntityToJson(data as LoginEntity);			case LoginData:
			return loginDataToJson(data as LoginData);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'VipPriceEntity':
			return VipPriceEntity().fromJson(json);			case 'VipPriceData':
			return VipPriceData().fromJson(json);			case 'AlipayPayinfoEntity':
			return AlipayPayinfoEntity().fromJson(json);			case 'AlipayPayinfoData':
			return AlipayPayinfoData().fromJson(json);			case 'WechatPayinfoEntity':
			return WechatPayinfoEntity().fromJson(json);			case 'WechatPayinfoData':
			return WechatPayinfoData().fromJson(json);			case 'WechatPayinfoDataPayInfo':
			return WechatPayinfoDataPayInfo().fromJson(json);			case 'ResultBeanEntity':
			return ResultBeanEntity().fromJson(json);			case 'HomeEntity':
			return HomeEntity().fromJson(json);			case 'HomeData':
			return HomeData().fromJson(json);			case 'HomeDataBanner':
			return HomeDataBanner().fromJson(json);			case 'HomeDataTaskList':
			return HomeDataTaskList().fromJson(json);			case 'HomeDataTaskListList':
			return HomeDataTaskListList().fromJson(json);			case 'TaskSubmitInfoEntity':
			return TaskSubmitInfoEntity().fromJson(json);			case 'TaskSubmitInfoData':
			return TaskSubmitInfoData().fromJson(json);			case 'TaskDetailEntity':
			return TaskDetailEntity().fromJson(json);			case 'TaskDetailData':
			return TaskDetailData().fromJson(json);			case 'UserInfoEntity':
			return UserInfoEntity().fromJson(json);			case 'UserInfoData':
			return UserInfoData().fromJson(json);			case 'LoginEntity':
			return LoginEntity().fromJson(json);			case 'LoginData':
			return LoginData().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'VipPriceEntity':
			return List<VipPriceEntity>();			case 'VipPriceData':
			return List<VipPriceData>();			case 'AlipayPayinfoEntity':
			return List<AlipayPayinfoEntity>();			case 'AlipayPayinfoData':
			return List<AlipayPayinfoData>();			case 'WechatPayinfoEntity':
			return List<WechatPayinfoEntity>();			case 'WechatPayinfoData':
			return List<WechatPayinfoData>();			case 'WechatPayinfoDataPayInfo':
			return List<WechatPayinfoDataPayInfo>();			case 'ResultBeanEntity':
			return List<ResultBeanEntity>();			case 'HomeEntity':
			return List<HomeEntity>();			case 'HomeData':
			return List<HomeData>();			case 'HomeDataBanner':
			return List<HomeDataBanner>();			case 'HomeDataTaskList':
			return List<HomeDataTaskList>();			case 'HomeDataTaskListList':
			return List<HomeDataTaskListList>();			case 'TaskSubmitInfoEntity':
			return List<TaskSubmitInfoEntity>();			case 'TaskSubmitInfoData':
			return List<TaskSubmitInfoData>();			case 'TaskDetailEntity':
			return List<TaskDetailEntity>();			case 'TaskDetailData':
			return List<TaskDetailData>();			case 'UserInfoEntity':
			return List<UserInfoEntity>();			case 'UserInfoData':
			return List<UserInfoData>();			case 'LoginEntity':
			return List<LoginEntity>();			case 'LoginData':
			return List<LoginData>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}