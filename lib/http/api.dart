import 'package:star/global_config.dart';

class APi {
//  6YHgt890Mgplu7054fg8k3g3dQ2CXmh4
  static String BASE_URL = GlobalConfig.isRelease
//      ? "https://task.ktkj.shop/"
      ? "https://api.ktkj.shop/"
      : "http://test-api.ketaokeji.shop/";

//      : "http://api.ketaoxx.com/";

//  static const String BASE_URL = "https://task.ktkj.shop/";
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000;

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
  static const String RESET_PASSWORD = "user/set-pwd";

  ///获取用户信息
  static const String USER_INFO = "user/user-info";

  ///获取收益列表
  static const String USER_PROFIT_LIST = "user/profit-list";

  ///获取消息列表
  static const String USER_MSG_LIST = "user/msg-list";

  ///获取话费充值列表
  static const String USER_HF_LIST = "user/hf-list";

  ///提现申请
  static const String USER_WITHDRAWAL_APPLICATION = "user/tx-apply";

  ///获取提现列表
  static const String USER_WITHDRAWAL_LIST = "user/tx-list";

  ///获取粉丝列表
  static const String USER_FANS_LIST = "user/fans-list";

  ///获取粉丝列表
  static const String USER_TOTAL_FANS = "user/total-fans";

  /// 我的海报
  static const String USER_SHARE = "user/share";

  ///获取粉丝列表
  static const String USER_TASK_LIST = "user/task-list";

  ///获取提现用户账户信息
  static const String USER_TX_USER = "user/tx-user";

  ///获取提现用户提现信息
  static const String USER_TX_SUCCESS = "user/tx-success";

  ///设置用户支付密码
  static const String USER_SET_PAY_PASSWORD = "user/set-password";

  ///修改支付密码发送短信验证码
  static const String USER_SEND_SMS = "user/send-sms";

  ///修改支付密码
  static const String USER_RESET_PAY_PASSWORD = "user/reset-password";

  ///校验支付密码
  static const String USER_CHECK_PASSWORD = "user/check-password";

  ///申请成为微股东
  static const String USER_PARTNER = "user/partner";

  ///获取当前版本信息
  static const String SITE_VERSION = "site/version";

  ///升级VIP用户
  static const String USER_UPGRADE_VIP = "pay/upgrade-pay";

  ///检测支付是否成功
  static const String PAY_CHECK_SUCCESS = "pay/check-success";

  ///检测支付是否成功
  static const String PAY_GOODS_PAY = "/pay/goods-pay";

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

  ///获取任务重新提交信息
  static const String TASK_RESUBMIT_INFO = "task/re-submit-info";

  ///上传图片
  static const String SITE_UPLOAD_IMG = "site/upload";

  ///绑定第三方,微信授权
  static const String SITE_BIND_THIRD = "site/bind-third";

  ///绑定手机号码
  static const String SITE_BIND_PHONE = "site/bind-phone";

  ///修改手机号码
  static const String SITE_MODIFY_PHONE = "site/modify-phone";

  ///添加体验会员手机号码
  static const String SITE_EXPERIENCE_MEMBER_PHONE_ADD = "user/set-experience";

  ///绑定微信号
  static const String SITE_BIND_WECHAT_NO = "user/bind-wx";

  ///修改微信号
  static const String SITE_MODIFY_WECHAT_NO = "user/bind-wx";

  ///获取首页数据
  static const String SITE_HOME = "site/home";

  ///获取vip价格
  static const String SITE_VIP_PRICE = "site/vip-price";

  ///话费充值列表
  static const String SITE_RECHARGE = "site/recharge";

  ///话费充值
  static const String PAY_RECHARGE = "pay/recharge-pay";

  ///商品支付
  static const String PAY_GOODS = "pay/goods-pay";

  ///会员升级获取到的优惠券信息
  static const String PAY_COUPON = "pay/pay-coupon";

/*------------------地址相关START-------------------*/

  ///收货地址-列表
  static const String USER_ADDRESS = "/addr/list";

  ///收货地址-详情
  static const String USER_ADDRESS_INFO = "/addr/info";

  ///收货地址-添加
  static const String USER_ADDRESS_ADD = "/addr/add";
  static const String USER_ADDRESS_EDIT = "/addr/edit";
  static const String USER_ADDRESS_DELETE = "/addr/del";

  ///  获取省市区三级级区域地址列表
  static const String REGIONAL_ADDRESS_LIST = "/addr/region";

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

  ///首页最新商品列表
  static const String GOODS_LIST = "goods/lists";

  ///首页热门商品列表
  static const String HOME_SEARCH_PRODUCTS_LIST =
      "/api/index.php?route=api/search";

  ///首页搜索商品列表
  static const String CATEGORY_GOODS_LIST =
      "/api/index.php?route=api/category/goods";

  ///首页分类商品列表
  static const String CATEGORY = "/category/tree";

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

  /* ///用户隐私协议
  static String AGREEMENT_PRIVACY_URL = "https://task.ktkj.shop/yinsi.html";
*/

  ///用户隐私协议
  static String AGREEMENT_PRIVACY_URL = GlobalConfig.isHuaweiUnderReview
      ? 'https://task.ktkj.shop/html/hw_ysxy.html'
      : "https://task.ktkj.shop/yinsi.html";

  ///商品详情
  static const String PRODUCT = "/api/index.php?route=api/product";

  ///订单相关
  static const String ORDER_CHECKOUT = "/api/index.php?route=api/checkout";

  ///添加订单
  static const String ORDER_CREATE = "/order/create";

  ///订单修改收货地址
  static const String ORDER_CHANGE_ADDR = "order/change-addr";

  ///提交订单
  static const String ORDER_SUBMIT = "order/submit";

  ///订单物流
  static const String ORDER_LOGISTICS = "order/express";

  ///确定提交
  static const String ORDER_DETAIL = "order/info";

  ///订单详情
  static const String ORDER_HISTORY = "/api/index.php?route=api/order/history";

  ///商品详情
  static const String GOODS_INFO = "/goods/info";

  ///订单列表
  static const String ORDER_LIST = "/order/list";

  ///订单排队
  static const String ORDER_QUEUE = "/order/queue";

  ///订单确认收货
  static const String ORDER_ENSURE_RECEIVE = "order/confirm";

  ///各个状态订单
  static const String ORDER_DEL = "/api/index.php?route=api/order/del";

  ///订单删除
  static const String ORDER_CHECKOUTXX =
      "/api/index.php?route=api/checkout/checkout";

  ///订单删除
  static const String E_BASE_URL = "/api/index.php?route=api/checkout/checkout";

  ///  获取商品排队详情
  static const String QUEUE_GOODS = "/queue/goods";

  ///  获取本人排队信息
  static const String QUEUE_MY = "/queue/my";
}
