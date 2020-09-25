import 'package:star/global_config.dart';

class APi {
//  6YHgt890Mgplu7054fg8k3g3dQ2CXmh4
  static String BASE_URL = GlobalConfig.isRelease
      ? "https://task.ktkj.shop/"
      : "http://test-api.ketaokeji.shop/";

//      : "http://api.ketaoxx.com/";

//  static const String BASE_URL = "https://task.ktkj.shop/";
  static const int CONNECT_TIMEOUT = 5000;
  static const int RECEIVE_TIMEOUT = 3000;

  static const String INTERFACE_KEY = "6YHgt890Mgplu7054fg8k3g3dQ2CXmh4";

  ///注册
  static const String REGISTER = "login/register";

  ///发送验证码
  static const String SMS_SEND = "login/send-msg";

  ///登录
  static const String LOGIN = "login/login";

  ///快速登录
  static const String FAST_LOGIN = "login/fast-login";

  ///第三方微信登录
  static const String WECHAT_LOGIN = "login/third-login";

  ///修改密码
  static const String RESET_PASSWORD = "/api/setpwd";

  ///获取用户信息
  static const String USER_INFO = "user/user-info";

  ///提现申请
  static const String USER_WITHDRAWAL_APPLICATION = "user/tx-apply";

  ///升级VIP用户
  static const String USER_UPGRADE_VIP = "pay/upgrade-pay";

  ///检测支付是否成功
  static const String PAY_CHECK_SUCCESS = "pay/check-success";

  ///修改昵称
  static const String USER_ENAME = "/api/index.php?route=api/user/euname";

  ///修改手机号
  static const String USER_EDIT_TEL = "/api/index.php?route=api/user/edit_tel";

  ///修改头像
  static const String USER_REFACE = "/api/index.php?route=api/user/eface";

  ///创建二维码
  static const String CREATE_QRCODE = "/api/create-qrcode";

  ///任务详情
  static const String TASK_DETAIL = "task/detail";

  ///任务领取
  static const String TASK_RECEIVE = "task/receive";

  ///任务提交
  static const String TASK_SUBMIT_SAVE = "task/submit-save";

  ///获取任务提交信息
  static const String TASK_SUBMIT_INFO = "task/submit-info";

  ///上传图片
  static const String SITE_UPLOAD_IMG = "site/upload";

  ///绑定第三方
  static const String SITE_BIND_THIRD = "site/bind-third";

  ///绑定手机号码
  static const String SITE_BIND_PHONE = "site/bind-phone";

  ///获取首页数据
  static const String SITE_HOME = "site/home";

  ///获取vip价格
  static const String SITE_VIP_PRICE = "site/vip-price";

  ///话费充值列表
  static const String SITE_RECHARGE = "site/recharge";

  ///话费充值
  static const String PAY_RECHARGE = "pay/recharge-pay";

/*------------------地址相关START-------------------*/

  ///收货地址
  static const String USER_ADDRESS = "/api/index.php?route=api/address";
  static const String USER_ADDRESS_ADD = "/api/index.php?route=api/address/add";
  static const String USER_ADDRESS_EDIT =
      "/api/index.php?route=api/address/edit";
  static const String USER_ADDRESS_DELETE =
      "/api/index.php?route=api/address/delete";

  ///  获取省市区三级级区域地址列表
  static const String REGIONAL_ADDRESS_LIST =
      "/api/index.php?route=api/checkout/get_regions";

/*------------------地址相关END-------------------*/

  ///token
  static const String GET_TOKEN = "/api/index.php?route=api/token";

  static const String AUTHORIZE = "/api/index.php?route=oauth/oauth2/authorize";

  ///获取授权码
  static const String AUTHORIZE2 = "api/index.php?route=oauth/oauth2/authorize";

  ///获取授权码
  static const String ACCESS_TOKEN = "/api/index.php?route=oauth/oauth2/token";

  ///获取令牌access_token
  static const String ACCESS_TOKEN2 = "api/index.php?route=oauth/oauth2/token";

  ///刷新token
  static const String REFRESH_TOKEN = "login/refer-token";

  ///刷新令牌
  static const String REFRESH_TOKEN2 =
      "api/index.php?route=oauth/oauth2/refresh_token";

  ///刷新令牌

  static const String HOME = "/api/index.php?route=api/home";

  ///首页
  static const String HOME_PRODUCTS_LIST =
      "/api/index.php?route=api/home/getProductList";

  ///首页最新商品列表
  static const String HOME_HotProducts_LIST =
      "/api/index.php?route=api/home/getProductHotList";

  ///首页热门商品列表
  static const String HOME_SEARCH_PRODUCTS_LIST =
      "/api/index.php?route=api/search";

  ///首页搜索商品列表
  static const String CATEGORY_GOODS_LIST =
      "/api/index.php?route=api/category/goods";

  ///首页分类商品列表
  static const String CATEGORY = "/api/index.php?route=api/category";

  ///分类

  ///购物车
  static const String CART = "/api/index.php?route=api/cart";

  ///添加商品
  static const String CART_ADD = "/api/index.php?route=api/cart/add";

  ///删除商品
  static const String CART_DEL = "/api/index.php?route=api/cart/remove";

  ///修改商品
  static const String CART_EDIT = "/api/index.php?route=api/cart/edit";

  ///协议信息地址
  ///
  ///
  ///注册协议
  static const String AGREEMENT_REGISTRATION_URL =
      "https://task.ktkj.shop/zhuce.html";

  ///用户服务协议
  static const String AGREEMENT_SERVICES_URL =
      "https://task.ktkj.shop/tiaokuan.html";

  ///用户隐私协议
  static const String AGREEMENT_PRIVACY_URL =
      "https://task.ktkj.shop/yinsi.html";

  ///商品详情
  static const String PRODUCT = "/api/index.php?route=api/product";

  ///订单相关
  static const String ORDER_CHECKOUT = "/api/index.php?route=api/checkout";

  ///提交订单
  static const String ORDER_CHECKOUT_CONFIRM =
      "/api/index.php?route=api/checkout/confirm";

  ///确定提交
  static const String ORDER_DETAIL = "/api/index.php?route=api/order";

  ///订单详情
  static const String ORDER_HISTORY = "/api/index.php?route=api/order/history";

  ///历史订单
  static const String ORDER_STATUS = "/api/index.php?route=api/order/status";

  ///各个状态订单
  static const String ORDER_DEL = "/api/index.php?route=api/order/del";

  ///订单删除
  static const String ORDER_CHECKOUTXX =
      "/api/index.php?route=api/checkout/checkout";

  ///订单列表页面去支付调用

}
