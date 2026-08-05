class LoginResponse {
  final String? serverMessage;
  final bool? status;
  final Data? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final dynamic error;

  LoginResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        serverMessage: json["server_message"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        dataResult: json["data_result"] == null
            ? []
            : List<dynamic>.from(json["data_result"]!.map((x) => x)),
        errorData: json["error_data"] == null
            ? []
            : List<dynamic>.from(json["error_data"]!.map((x) => x)),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "server_message": serverMessage,
        "status": status,
        "data": data?.toJson(),
        "data_result": dataResult == null
            ? []
            : List<dynamic>.from(dataResult!.map((x) => x)),
        "error_data": errorData == null
            ? []
            : List<dynamic>.from(errorData!.map((x) => x)),
        "error": error,
      };
}

class Data {
  final int? status;
  final DateTime? timeTag;
  final String? userType;
  final String? apiKey;
  final String? serverMessage;
  final String? checkPhoneActivation;
  final String? confirmPhoneNumber;
  final String? supportPhoneNumber;
  final String? whatsappPhoneNumber;
  final String? confirmUserId;
  final List<UserAutoWalletAccount>? userAutoWalletAccount;
  final List<UserManualAccount>? userManualAccount;
  final String? referralCode;
  final String? username;
  final String? email;
  final String? loginNotification;
  final List<Faq>? faq;
  final Promo? promo;
  final String? termsCondition;
  final String? liveChat;
  final String? privacy;
  final List<Bank>? banks;
  final Kyc? kyc;
  final UserSettings? userSettings;
  final int? hasSetupTransactionPin;
  final WebsiteData? websiteData;
  final SettingsData? settingsData;
  final List<AirtimeTopup>? airtimeTopup;
  final List<AirtimeToCash>? airtimeToCash;
  final List<Betting>? betting;
  final DataBundle? dataBundle;
  final Tv? tv;
  final ElectricityBill? electricityBill;
  final EducationalBill? educationalBill;
  final DataCard? dataCard;
  final RechargeCard? rechargeCard;
  final BroadbandInternet? broadbandInternet;

  Data({
    this.status,
    this.timeTag,
    this.userType,
    this.apiKey,
    this.serverMessage,
    this.checkPhoneActivation,
    this.confirmPhoneNumber,
    this.supportPhoneNumber,
    this.whatsappPhoneNumber,
    this.confirmUserId,
    this.userAutoWalletAccount,
    this.userManualAccount,
    this.referralCode,
    this.username,
    this.email,
    this.loginNotification,
    this.faq,
    this.promo,
    this.termsCondition,
    this.liveChat,
    this.privacy,
    this.banks,
    this.kyc,
    this.userSettings,
    this.hasSetupTransactionPin,
    this.websiteData,
    this.settingsData,
    this.airtimeTopup,
    this.airtimeToCash,
    this.betting,
    this.dataBundle,
    this.tv,
    this.electricityBill,
    this.educationalBill,
    this.dataCard,
    this.rechargeCard,
    this.broadbandInternet,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        timeTag:
            json["time_tag"] == null ? null : DateTime.parse(json["time_tag"]),
        userType: json["user_type"],
        apiKey: json["api_key"],
        serverMessage: json["server_message"],
        checkPhoneActivation: json["check_phone_activation"],
        confirmPhoneNumber: json["confirm_phone_number"],
        supportPhoneNumber: json["support_phone_number"],
        whatsappPhoneNumber: json["whatsapp_phone_number"],
        confirmUserId: json["confirm_user_id"],
        userAutoWalletAccount: json["user_auto_wallet_account"] == null
            ? []
            : List<UserAutoWalletAccount>.from(json["user_auto_wallet_account"]!
                .map((x) => UserAutoWalletAccount.fromJson(x))),
        userManualAccount: json["user_manual_account"] == null
            ? []
            : List<UserManualAccount>.from(json["user_manual_account"]!
                .map((x) => UserManualAccount.fromJson(x))),
        referralCode: json["referral_code"],
        username: json["username"],
        email: json["email"],
        loginNotification: json["login_notification"],
        faq: json["faq"] == null
            ? []
            : List<Faq>.from(json["faq"]!.map((x) => Faq.fromJson(x))),
        promo: json["promo"] == null ? null : Promo.fromJson(json["promo"]),
        termsCondition: json["terms_condition"],
        liveChat: json["live_chat"],
        privacy: json["privacy"],
        banks: json["banks"] == null
            ? []
            : List<Bank>.from(json["banks"]!.map((x) => Bank.fromJson(x))),
        kyc: json["kyc"] == null ? null : Kyc.fromJson(json["kyc"]),
        userSettings: json["user_settings"] == null
            ? null
            : UserSettings.fromJson(json["user_settings"]),
        hasSetupTransactionPin: json["has_setup_transaction_pin"],
        websiteData: json["website_data"] == null
            ? null
            : WebsiteData.fromJson(json["website_data"]),
        settingsData: json["settings_data"] == null
            ? null
            : SettingsData.fromJson(json["settings_data"]),
        airtimeTopup: json["airtime_topup"] == null
            ? []
            : List<AirtimeTopup>.from(
                json["airtime_topup"]!.map((x) => AirtimeTopup.fromJson(x))),
        airtimeToCash: json["airtime_to_cash"] == null
            ? []
            : List<AirtimeToCash>.from(
                json["airtime_to_cash"]!.map((x) => AirtimeToCash.fromJson(x))),
        betting: json["betting"] == null
            ? []
            : List<Betting>.from(
                json["betting"]!.map((x) => Betting.fromJson(x))),
        dataBundle: json["data_bundle"] == null
            ? null
            : DataBundle.fromJson(json["data_bundle"]),
        tv: json["tv"] == null ? null : Tv.fromJson(json["tv"]),
        electricityBill: json["electricity_bill"] == null
            ? null
            : ElectricityBill.fromJson(json["electricity_bill"]),
        educationalBill: json["educational_bill"] == null
            ? null
            : EducationalBill.fromJson(json["educational_bill"]),
        dataCard: json["data_card"] == null
            ? null
            : DataCard.fromJson(json["data_card"]),
        rechargeCard: json["recharge_card"] == null
            ? null
            : RechargeCard.fromJson(json["recharge_card"]),
        broadbandInternet: json["broadband_internet"] == null
            ? null
            : BroadbandInternet.fromJson(json["broadband_internet"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "time_tag": timeTag?.toIso8601String(),
        "user_type": userType,
        "api_key": apiKey,
        "server_message": serverMessage,
        "check_phone_activation": checkPhoneActivation,
        "confirm_phone_number": confirmPhoneNumber,
        "support_phone_number": supportPhoneNumber,
        "whatsapp_phone_number": whatsappPhoneNumber,
        "confirm_user_id": confirmUserId,
        "user_auto_wallet_account": userAutoWalletAccount == null
            ? []
            : List<dynamic>.from(userAutoWalletAccount!.map((x) => x.toJson())),
        "user_manual_account": userManualAccount == null
            ? []
            : List<dynamic>.from(userManualAccount!.map((x) => x.toJson())),
        "referral_code": referralCode,
        "username": username,
        "email": email,
        "login_notification": loginNotification,
        "faq":
            faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
        "promo": promo?.toJson(),
        "terms_condition": termsCondition,
        "live_chat": liveChat,
        "privacy": privacy,
        "banks": banks == null
            ? []
            : List<dynamic>.from(banks!.map((x) => x.toJson())),
        "kyc": kyc?.toJson(),
        "user_settings": userSettings?.toJson(),
        "has_setup_transaction_pin": hasSetupTransactionPin,
        "website_data": websiteData?.toJson(),
        "settings_data": settingsData?.toJson(),
        "airtime_topup": airtimeTopup == null
            ? []
            : List<dynamic>.from(airtimeTopup!.map((x) => x.toJson())),
        "airtime_to_cash": airtimeToCash == null
            ? []
            : List<dynamic>.from(airtimeToCash!.map((x) => x.toJson())),
        "betting": betting == null
            ? []
            : List<dynamic>.from(betting!.map((x) => x.toJson())),
        "data_bundle": dataBundle?.toJson(),
        "tv": tv?.toJson(),
        "electricity_bill": electricityBill?.toJson(),
        "educational_bill": educationalBill?.toJson(),
        "data_card": dataCard?.toJson(),
        "recharge_card": rechargeCard?.toJson(),
        "broadband_internet": broadbandInternet?.toJson(),
      };
}

class AirtimeToCash {
  final String? name;
  final String? logo;

  AirtimeToCash({
    this.name,
    this.logo,
  });

  factory AirtimeToCash.fromJson(Map<String, dynamic> json) => AirtimeToCash(
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
      };
}

class AirtimeTopup {
  final String? name;
  final String? productCode;
  final String? logo;

  AirtimeTopup({
    this.name,
    this.productCode,
    this.logo,
  });

  factory AirtimeTopup.fromJson(Map<String, dynamic> json) => AirtimeTopup(
        name: json["name"],
        productCode: json["product_code"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "product_code": productCode,
        "logo": logo,
      };
}

class Betting {
  final String? name;
  final String? productCode;
  final String? logo;

  Betting({
    this.name,
    this.productCode,
    this.logo,
  });

  factory Betting.fromJson(Map<String, dynamic> json) {
    return Betting(
      name: json['name'] as String?,
      productCode: json['product_code'] as String?,
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product_code': productCode,
      'logo': logo,
    };
  }
}

class BettingData {
  final List<Betting>? betting;

  BettingData({this.betting});

  factory BettingData.fromJson(Map<String, dynamic> json) {
    return BettingData(
      betting: (json['betting'] as List<dynamic>?)
          ?.map((e) => Betting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'betting': betting?.map((e) => e.toJson()).toList(),
    };
  }
}

class Bank {
  final String? bankName;
  final String? bankCode;
  final String? logo;

  Bank({
    this.bankName,
    this.bankCode,
    this.logo,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankName: json["bank_name"],
        bankCode: json["bank_code"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "bank_code": bankCode,
        "logo": logo,
      };
}

class BroadbandInternet {
  final Map<String, List<BroadbandService>>? broadbandServices;
  final List<BroadbandProvider>? providers;

  BroadbandInternet({
    this.broadbandServices,
    this.providers,
  });

  factory BroadbandInternet.fromJson(Map<String, dynamic> json) {
    // Remove the 'provider' key from the services before processing
    Map<String, dynamic> servicesJson = Map.from(json);
    List<BroadbandProvider> providersList =
        (servicesJson.remove('provider') as List)
            .map((providerJson) => BroadbandProvider.fromJson(providerJson))
            .toList();

    // Process broadband services
    Map<String, List<BroadbandService>> services = {};
    servicesJson.forEach((key, value) {
      services[key] = (value as List)
          .map((serviceJson) => BroadbandService.fromJson(serviceJson))
          .toList();
    });

    return BroadbandInternet(
      broadbandServices: services,
      providers: providersList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    // Add broadband services
    broadbandServices?.forEach((key, services) {
      json[key] = services.map((service) => service.toJson()).toList();
    });

    // Add providers
    json['provider'] = providers?.map((provider) => provider.toJson()).toList();

    return json;
  }
}

class BroadbandService {
  final int? availableServiceId;
  final int? availableServiceParentId;
  final String? availableServiceName;
  final String? availableServiceSystemName;
  final String? availableServiceDefaultPrice;
  final String? availableServiceLogo;
  final String? availableServiceConvinienceFee;
  final String? availableServicePriceEditable;
  final String? isVerifyDevice;
  final num? discountedPrice; // 👈 Change to num? or double?
  final num? availableServiceActualPrice; // 👈 Change to num? or double?

  BroadbandService({
    this.availableServiceId,
    this.availableServiceParentId,
    this.availableServiceName,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.availableServiceLogo,
    this.availableServiceConvinienceFee,
    this.availableServicePriceEditable,
    this.isVerifyDevice,
    this.discountedPrice,
    this.availableServiceActualPrice,
  });

  factory BroadbandService.fromJson(Map<String, dynamic> json) {
    return BroadbandService(
      availableServiceId: json['available_service_id'],
      availableServiceParentId: json['available_service_parent_id'],
      availableServiceName: json['available_service_name'],
      availableServiceSystemName: json['available_service_system_name'],
      availableServiceDefaultPrice: json['available_service_default_price'],
      availableServiceLogo: json['available_service_logo'],
      availableServiceConvinienceFee: json['available_service_convinience_fee'],
      availableServicePriceEditable: json['available_service_price_editable'],
      isVerifyDevice: json['is_verify_device'],
      discountedPrice: json['discounted_price'], // Safe if using num?
      availableServiceActualPrice:
          json['available_service_actual_price'], // Safe if using num?
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'available_service_id': availableServiceId,
      'available_service_parent_id': availableServiceParentId,
      'available_service_name': availableServiceName,
      'available_service_system_name': availableServiceSystemName,
      'available_service_default_price': availableServiceDefaultPrice,
      'available_service_logo': availableServiceLogo,
      'available_service_convinience_fee': availableServiceConvinienceFee,
      'available_service_price_editable': availableServicePriceEditable,
      'is_verify_device': isVerifyDevice,
      'discounted_price': discountedPrice,
      'available_service_actual_price': availableServiceActualPrice,
    };
  }
}

class BroadbandProvider {
  final int? subServiceId;
  final int? subServiceParentId;
  final String? subServiceName;
  final String? subServiceCode;
  final String? subServiceLogo;
  final String? subServiceDescription;

  BroadbandProvider({
    this.subServiceId,
    this.subServiceParentId,
    this.subServiceName,
    this.subServiceCode,
    this.subServiceLogo,
    this.subServiceDescription,
  });

  factory BroadbandProvider.fromJson(Map<String, dynamic> json) {
    return BroadbandProvider(
      subServiceId: json['sub_service_id'],
      subServiceParentId: json['sub_service_parent_id'],
      subServiceName: json['sub_service_name'],
      subServiceCode: json['sub_service_code'],
      subServiceLogo: json['sub_service_logo'],
      subServiceDescription: json['sub_service_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_service_id': subServiceId,
      'sub_service_parent_id': subServiceParentId,
      'sub_service_name': subServiceName,
      'sub_service_code': subServiceCode,
      'sub_service_logo': subServiceLogo,
      'sub_service_description': subServiceDescription,
    };
  }
}

// class BroadbandInternet {
//   final List<SmileDatum>? smileData;
//   final List<SmileDatum>? smileRecharge;
//   final List<SmileDatum>? spectranet;
//   final List<TypeElement>? provider;

//   BroadbandInternet({
//     this.smileData,
//     this.smileRecharge,
//     this.spectranet,
//     this.provider,
//   });

//   factory BroadbandInternet.fromJson(Map<String, dynamic> json) =>
//       BroadbandInternet(
//         smileData: json["smile_data"] == null
//             ? []
//             : List<SmileDatum>.from(
//                 json["smile_data"]!.map((x) => SmileDatum.fromJson(x))),
//         smileRecharge: json["smile_recharge"] == null
//             ? []
//             : List<SmileDatum>.from(
//                 json["smile_recharge"]!.map((x) => SmileDatum.fromJson(x))),
//         spectranet: json["spectranet"] == null
//             ? []
//             : List<SmileDatum>.from(
//                 json["spectranet"]!.map((x) => SmileDatum.fromJson(x))),
//         provider: json["provider"] == null
//             ? []
//             : List<TypeElement>.from(
//                 json["provider"]!.map((x) => TypeElement.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "smile_data": smileData == null
//             ? []
//             : List<dynamic>.from(smileData!.map((x) => x.toJson())),
//         "smile_recharge": smileRecharge == null
//             ? []
//             : List<dynamic>.from(smileRecharge!.map((x) => x.toJson())),
//         "spectranet": spectranet == null
//             ? []
//             : List<dynamic>.from(spectranet!.map((x) => x.toJson())),
//         "provider": provider == null
//             ? []
//             : List<dynamic>.from(provider!.map((x) => x.toJson())),
//       };
// }

class TypeElement {
  final int? subServiceId;
  final int? subServiceParentId;
  final String? subServiceName;
  final String? subServiceCode;
  final String? subServiceLogo;
  final String? subServiceDescription;

  TypeElement({
    this.subServiceId,
    this.subServiceParentId,
    this.subServiceName,
    this.subServiceCode,
    this.subServiceLogo,
    this.subServiceDescription,
  });

  factory TypeElement.fromJson(Map<String, dynamic> json) => TypeElement(
        subServiceId: json["sub_service_id"],
        subServiceParentId: json["sub_service_parent_id"],
        subServiceName: json["sub_service_name"],
        subServiceCode: json["sub_service_code"],
        subServiceLogo: json["sub_service_logo"],
        subServiceDescription: json["sub_service_description"],
      );

  Map<String, dynamic> toJson() => {
        "sub_service_id": subServiceId,
        "sub_service_parent_id": subServiceParentId,
        "sub_service_name": subServiceName,
        "sub_service_code": subServiceCode,
        "sub_service_logo": subServiceLogo,
        "sub_service_description": subServiceDescription,
      };
}

class SmileDatum {
  final int? availableServiceId;
  final int? availableServiceParentId;
  final String? availableServiceName;
  final String? availableServiceSystemName;
  final String? availableServiceDefaultPrice;
  final String? availableServiceLogo;
  final String? availableServiceConvinienceFee;
  final String? availableServicePriceEditable;
  final String? isVerifyDevice;
  final num? discountedPrice; // 👈 Change to num? or double?
  final num? availableServiceActualPrice; // 👈 Change to num? or double?

  SmileDatum({
    this.availableServiceId,
    this.availableServiceParentId,
    this.availableServiceName,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.availableServiceLogo,
    this.availableServiceConvinienceFee,
    this.availableServicePriceEditable,
    this.isVerifyDevice,
    this.discountedPrice,
    this.availableServiceActualPrice,
  });

  factory SmileDatum.fromJson(Map<String, dynamic> json) => SmileDatum(
        availableServiceId: json["available_service_id"],
        availableServiceParentId: json["available_service_parent_id"],
        availableServiceName: json["available_service_name"],
        availableServiceSystemName: json["available_service_system_name"],
        availableServiceDefaultPrice: json["available_service_default_price"],
        availableServiceLogo: json["available_service_logo"],
        availableServiceConvinienceFee:
            json["available_service_convinience_fee"],
        availableServicePriceEditable: json["available_service_price_editable"],
        isVerifyDevice: json["is_verify_device"],
        discountedPrice: json["discounted_price"], // Safe if using num?
        availableServiceActualPrice:
            json["available_service_actual_price"], // Safe if using num?
      );

  Map<String, dynamic> toJson() => {
        "available_service_id": availableServiceId,
        "available_service_parent_id": availableServiceParentId,
        "available_service_name": availableServiceName,
        "available_service_system_name": availableServiceSystemName,
        "available_service_default_price": availableServiceDefaultPrice,
        "available_service_logo": availableServiceLogo,
        "available_service_convinience_fee": availableServiceConvinienceFee,
        "available_service_price_editable": availableServicePriceEditable,
        "is_verify_device": isVerifyDevice,
        "discounted_price": discountedPrice,
        "available_service_actual_price": availableServiceActualPrice,
      };
}

class DataBundle {
  final List<Airtel>? mtn;
  final List<Airtel>? glo;
  final List<Airtel>? airtel;
  final List<Airtel>? the9Mobile;
  final List<AirtimeToCash>? networkOperators;

  DataBundle({
    this.mtn,
    this.glo,
    this.airtel,
    this.the9Mobile,
    this.networkOperators,
  });

  factory DataBundle.fromJson(Map<String, dynamic> json) => DataBundle(
        mtn: json["mtn"] == null
            ? []
            : List<Airtel>.from(json["mtn"]!.map((x) => Airtel.fromJson(x))),
        glo: json["glo"] == null
            ? []
            : List<Airtel>.from(json["glo"]!.map((x) => Airtel.fromJson(x))),
        airtel: json["airtel"] == null
            ? []
            : List<Airtel>.from(json["airtel"]!.map((x) => Airtel.fromJson(x))),
        the9Mobile: json["9mobile"] == null
            ? []
            : List<Airtel>.from(
                json["9mobile"]!.map((x) => Airtel.fromJson(x))),
        networkOperators: json["network_operators"] == null
            ? []
            : List<AirtimeToCash>.from(json["network_operators"]!
                .map((x) => AirtimeToCash.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mtn":
            mtn == null ? [] : List<dynamic>.from(mtn!.map((x) => x.toJson())),
        "glo":
            glo == null ? [] : List<dynamic>.from(glo!.map((x) => x.toJson())),
        "airtel": airtel == null
            ? []
            : List<dynamic>.from(airtel!.map((x) => x.toJson())),
        "9mobile": the9Mobile == null
            ? []
            : List<dynamic>.from(the9Mobile!.map((x) => x.toJson())),
        "network_operators": networkOperators == null
            ? []
            : List<dynamic>.from(networkOperators!.map((x) => x.toJson())),
      };
}

class Airtel {
  final String? subServiceGroupName;
  final List<AirtelAvailableService>? availableServices;

  Airtel({
    this.subServiceGroupName,
    this.availableServices,
  });

  factory Airtel.fromJson(Map<String, dynamic> json) => Airtel(
        subServiceGroupName: json["sub_service_group_name"],
        availableServices: json["available_services"] == null
            ? []
            : List<AirtelAvailableService>.from(json["available_services"]!
                .map((x) => AirtelAvailableService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sub_service_group_name": subServiceGroupName,
        "available_services": availableServices == null
            ? []
            : List<dynamic>.from(availableServices!.map((x) => x.toJson())),
      };
}

class AirtelAvailableService {
  final int? availableServiceId;
  final String? availableServiceName;
  final int? availableServiceParentId;
  final String? availableServiceDescription;
  final String? availableServiceSystemName;
  final int? availableServiceDefaultPrice;
  final String? productCode;
  final double? availableServiceActualPrice;
  final String? commission;
  final String? percentCommission;
  final double? discountedPrice;
  final String? serviceCode;

  AirtelAvailableService({
    this.availableServiceId,
    this.availableServiceName,
    this.availableServiceParentId,
    this.availableServiceDescription,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.productCode,
    this.availableServiceActualPrice,
    this.commission,
    this.percentCommission,
    this.discountedPrice,
    this.serviceCode,
  });

  factory AirtelAvailableService.fromJson(Map<String, dynamic> json) =>
      AirtelAvailableService(
        availableServiceId: json["available_service_id"],
        availableServiceName: json["available_service_name"],
        availableServiceParentId: json["available_service_parent_id"],
        availableServiceDescription: json["available_service_description"],
        availableServiceSystemName: json["available_service_system_name"],
        availableServiceDefaultPrice: json["available_service_default_price"],
        productCode: json["product_code"],
        availableServiceActualPrice:
            json["available_service_actual_price"]?.toDouble(),
        commission: json["commission"],
        percentCommission: json["percent_commission"],
        discountedPrice: json["discounted_price"]?.toDouble(),
        serviceCode: json["service_code"],
      );

  Map<String, dynamic> toJson() => {
        "available_service_id": availableServiceId,
        "available_service_name": availableServiceName,
        "available_service_parent_id": availableServiceParentId,
        "available_service_description": availableServiceDescription,
        "available_service_system_name": availableServiceSystemName,
        "available_service_default_price": availableServiceDefaultPrice,
        "product_code": productCode,
        "available_service_actual_price": availableServiceActualPrice,
        "commission": commission,
        "percent_commission": percentCommission,
        "discounted_price": discountedPrice,
        "service_code": serviceCode,
      };
}

class The9Mobile {
  final String? subServiceGroupName;
  final List<The9MobileAvailableService>? availableServices;

  The9Mobile({
    this.subServiceGroupName,
    this.availableServices,
  });

  factory The9Mobile.fromJson(Map<String, dynamic> json) => The9Mobile(
        subServiceGroupName: json["sub_service_group_name"],
        availableServices: json["available_services"] == null
            ? []
            : List<The9MobileAvailableService>.from(json["available_services"]!
                .map((x) => The9MobileAvailableService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sub_service_group_name": subServiceGroupName,
        "available_services": availableServices == null
            ? []
            : List<dynamic>.from(availableServices!.map((x) => x.toJson())),
      };
}

class The9MobileAvailableService {
  final int? availableServiceId;
  final String? availableServiceName;
  final int? availableServiceParentId;
  final String? availableServiceDescription;
  final String? availableServiceSystemName;
  final int? availableServiceDefaultPrice;
  final String? productCode;
  final num? availableServiceActualPrice;
  final String? commission;
  final String? percentCommission;
  final num? discountedPrice;
  final String? serviceCode;

  The9MobileAvailableService({
    this.availableServiceId,
    this.availableServiceName,
    this.availableServiceParentId,
    this.availableServiceDescription,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.productCode,
    this.availableServiceActualPrice,
    this.commission,
    this.percentCommission,
    this.discountedPrice,
    this.serviceCode,
  });

  factory The9MobileAvailableService.fromJson(Map<String, dynamic> json) =>
      The9MobileAvailableService(
        availableServiceId: json["available_service_id"],
        availableServiceName: json["available_service_name"],
        availableServiceParentId: json["available_service_parent_id"],
        availableServiceDescription: json["available_service_description"],
        availableServiceSystemName: json["available_service_system_name"],
        availableServiceDefaultPrice: json["available_service_default_price"],
        productCode: json["product_code"],
        availableServiceActualPrice: json["available_service_actual_price"],
        commission: json["commission"],
        percentCommission: json["percent_commission"],
        discountedPrice: json["discounted_price"],
        serviceCode: json["service_code"],
      );

  Map<String, dynamic> toJson() => {
        "available_service_id": availableServiceId,
        "available_service_name": availableServiceName,
        "available_service_parent_id": availableServiceParentId,
        "available_service_description": availableServiceDescription,
        "available_service_system_name": availableServiceSystemName,
        "available_service_default_price": availableServiceDefaultPrice,
        "product_code": productCode,
        "available_service_actual_price": availableServiceActualPrice,
        "commission": commission,
        "percent_commission": percentCommission,
        "discounted_price": discountedPrice,
        "service_code": serviceCode,
      };
}

class DataCard {
  final List<SmileDatum>? the9MobileCgDataPin;
  final List<SmileDatum>? airtelCgDataPin;
  final List<dynamic>? gloCgDataPin;
  final List<SmileDatum>? mtnCgDataPin;
  final List<SmileDatum>? mtnSmeDataPin;
  final List<TypeElement>? provider;

  DataCard({
    this.the9MobileCgDataPin,
    this.airtelCgDataPin,
    this.gloCgDataPin,
    this.mtnCgDataPin,
    this.mtnSmeDataPin,
    this.provider,
  });

  factory DataCard.fromJson(Map<String, dynamic> json) => DataCard(
        the9MobileCgDataPin: json["9mobile_cg_data_pin"] == null
            ? []
            : List<SmileDatum>.from(json["9mobile_cg_data_pin"]!
                .map((x) => SmileDatum.fromJson(x))),
        airtelCgDataPin: json["airtel_cg_data_pin"] == null
            ? []
            : List<SmileDatum>.from(
                json["airtel_cg_data_pin"]!.map((x) => SmileDatum.fromJson(x))),
        gloCgDataPin: json["glo_cg_data_pin"] == null
            ? []
            : List<dynamic>.from(json["glo_cg_data_pin"]!.map((x) => x)),
        mtnCgDataPin: json["mtn_cg_data_pin"] == null
            ? []
            : List<SmileDatum>.from(
                json["mtn_cg_data_pin"]!.map((x) => SmileDatum.fromJson(x))),
        mtnSmeDataPin: json["mtn_sme_data_pin"] == null
            ? []
            : List<SmileDatum>.from(
                json["mtn_sme_data_pin"]!.map((x) => SmileDatum.fromJson(x))),
        provider: json["provider"] == null
            ? []
            : List<TypeElement>.from(
                json["provider"]!.map((x) => TypeElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "9mobile_cg_data_pin": the9MobileCgDataPin == null
            ? []
            : List<dynamic>.from(the9MobileCgDataPin!.map((x) => x.toJson())),
        "airtel_cg_data_pin": airtelCgDataPin == null
            ? []
            : List<dynamic>.from(airtelCgDataPin!.map((x) => x.toJson())),
        "glo_cg_data_pin": gloCgDataPin == null
            ? []
            : List<dynamic>.from(gloCgDataPin!.map((x) => x)),
        "mtn_cg_data_pin": mtnCgDataPin == null
            ? []
            : List<dynamic>.from(mtnCgDataPin!.map((x) => x.toJson())),
        "mtn_sme_data_pin": mtnSmeDataPin == null
            ? []
            : List<dynamic>.from(mtnSmeDataPin!.map((x) => x.toJson())),
        "provider": provider == null
            ? []
            : List<dynamic>.from(provider!.map((x) => x.toJson())),
      };
}

class EducationalBill {
  final Map<String, List<EducationalService>>? educationalServices;
  final List<Types>? types;

  EducationalBill({
    this.educationalServices,
    this.types,
  });

  factory EducationalBill.fromJson(Map<String, dynamic> json) {
    // Remove the 'types' key from the services before processing
    Map<String, dynamic> servicesJson = Map.from(json);
    List<Types>? typesList = json['types'] != null
        ? (servicesJson.remove('types') as List)
            .map((typeJson) => Types.fromJson(typeJson))
            .toList()
        : null;

    // Process educational services
    Map<String, List<EducationalService>> services = {};
    servicesJson.forEach((key, value) {
      if (value is List) {
        services[key] = value
            .map((serviceJson) => EducationalService.fromJson(serviceJson))
            .toList();
      }
    });

    return EducationalBill(
      educationalServices: services,
      types: typesList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    // Add educational services
    educationalServices?.forEach((key, services) {
      json[key] = services.map((service) => service.toJson()).toList();
    });

    // Add types
    if (types != null) {
      json['types'] = types!.map((type) => type.toJson()).toList();
    }

    return json;
  }
}

class EducationalService {
  final int? availableServiceId;
  final int? availableServiceParentId;
  final String? availableServiceName;
  final String? availableServiceSystemName;
  final String? availableServiceDefaultPrice;
  final String? availableServiceLogo;
  final String? availableServiceConvinienceFee;
  final String? availableServicePriceEditable;
  final String? isVerifyDevice;
  final num? discountedPrice;
  final num? availableServiceActualPrice;

  EducationalService({
    this.availableServiceId,
    this.availableServiceParentId,
    this.availableServiceName,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.availableServiceLogo,
    this.availableServiceConvinienceFee,
    this.availableServicePriceEditable,
    this.isVerifyDevice,
    this.discountedPrice,
    this.availableServiceActualPrice,
  });

  factory EducationalService.fromJson(Map<String, dynamic> json) {
    return EducationalService(
      availableServiceId: json['available_service_id'],
      availableServiceParentId: json['available_service_parent_id'],
      availableServiceName: json['available_service_name'],
      availableServiceSystemName: json['available_service_system_name'],
      availableServiceDefaultPrice: json['available_service_default_price'],
      availableServiceLogo: json['available_service_logo'],
      availableServiceConvinienceFee: json['available_service_convinience_fee'],
      availableServicePriceEditable: json['available_service_price_editable'],
      isVerifyDevice: json['is_verify_device'],
      discountedPrice: json['discounted_price'],
      availableServiceActualPrice: json['available_service_actual_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_service_id': availableServiceId,
      'available_service_parent_id': availableServiceParentId,
      'available_service_name': availableServiceName,
      'available_service_system_name': availableServiceSystemName,
      'available_service_default_price': availableServiceDefaultPrice,
      'available_service_logo': availableServiceLogo,
      'available_service_convinience_fee': availableServiceConvinienceFee,
      'available_service_price_editable': availableServicePriceEditable,
      'is_verify_device': isVerifyDevice,
      'discounted_price': discountedPrice,
      'available_service_actual_price': availableServiceActualPrice,
    };
  }
}

class Types {
  final int? subServiceId;
  final int? subServiceParentId;
  final String? subServiceName;
  final String? subServiceCode;
  final String? subServiceLogo;
  final String? subServiceDescription;

  Types({
    this.subServiceId,
    this.subServiceParentId,
    this.subServiceName,
    this.subServiceCode,
    this.subServiceLogo,
    this.subServiceDescription,
  });

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      subServiceId: json['sub_service_id'],
      subServiceParentId: json['sub_service_parent_id'],
      subServiceName: json['sub_service_name'],
      subServiceCode: json['sub_service_code'],
      subServiceLogo: json['sub_service_logo'],
      subServiceDescription: json['sub_service_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_service_id': subServiceId,
      'sub_service_parent_id': subServiceParentId,
      'sub_service_name': subServiceName,
      'sub_service_code': subServiceCode,
      'sub_service_logo': subServiceLogo,
      'sub_service_description': subServiceDescription,
    };
  }
}
// class EducationalBill {
//   final List<SmileDatum>? jambPin;
//   final List<NecoPin>? necoPin;
//   final List<SmileDatum>? waecPin;
//   final List<TypeElement>? types;

//   EducationalBill({
//     this.jambPin,
//     this.necoPin,
//     this.waecPin,
//     this.types,
//   });

//   factory EducationalBill.fromJson(Map<String, dynamic> json) =>
//       EducationalBill(
//         jambPin: json["jamb_pin"] == null
//             ? []
//             : List<SmileDatum>.from(
//                 json["jamb_pin"]!.map((x) => SmileDatum.fromJson(x))),
//         necoPin: json["neco_pin"] == null
//             ? []
//             : List<NecoPin>.from(
//                 json["neco_pin"]!.map((x) => NecoPin.fromJson(x))),
//         waecPin: json["waec_pin"] == null
//             ? []
//             : List<SmileDatum>.from(
//                 json["waec_pin"]!.map((x) => SmileDatum.fromJson(x))),
//         types: json["types"] == null
//             ? []
//             : List<TypeElement>.from(
//                 json["types"]!.map((x) => TypeElement.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "jamb_pin": jambPin == null
//             ? []
//             : List<dynamic>.from(jambPin!.map((x) => x.toJson())),
//         "neco_pin": necoPin == null
//             ? []
//             : List<dynamic>.from(necoPin!.map((x) => x.toJson())),
//         "waec_pin": waecPin == null
//             ? []
//             : List<dynamic>.from(waecPin!.map((x) => x.toJson())),
//         "types": types == null
//             ? []
//             : List<dynamic>.from(types!.map((x) => x.toJson())),
//       };
// }

// class NecoPin {
//   final int? availableServiceId;
//   final int? availableServiceParentId;
//   final String? availableServiceName;
//   final String? availableServiceSystemName;
//   final String? availableServiceDefaultPrice;
//   final String? availableServiceLogo;
//   final String? availableServiceConvinienceFee;
//   final String? availableServicePriceEditable;
//   final String? isVerifyDevice;
//   final double? discountedPrice;
//   final double? availableServiceActualPrice;

//   NecoPin({
//     this.availableServiceId,
//     this.availableServiceParentId,
//     this.availableServiceName,
//     this.availableServiceSystemName,
//     this.availableServiceDefaultPrice,
//     this.availableServiceLogo,
//     this.availableServiceConvinienceFee,
//     this.availableServicePriceEditable,
//     this.isVerifyDevice,
//     this.discountedPrice,
//     this.availableServiceActualPrice,
//   });

//   factory NecoPin.fromJson(Map<String, dynamic> json) => NecoPin(
//         availableServiceId: json["available_service_id"],
//         availableServiceParentId: json["available_service_parent_id"],
//         availableServiceName: json["available_service_name"],
//         availableServiceSystemName: json["available_service_system_name"],
//         availableServiceDefaultPrice: json["available_service_default_price"],
//         availableServiceLogo: json["available_service_logo"],
//         availableServiceConvinienceFee:
//             json["available_service_convinience_fee"],
//         availableServicePriceEditable: json["available_service_price_editable"],
//         isVerifyDevice: json["is_verify_device"],
//         discountedPrice: json["discounted_price"]?.toDouble(),
//         availableServiceActualPrice:
//             json["available_service_actual_price"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "available_service_id": availableServiceId,
//         "available_service_parent_id": availableServiceParentId,
//         "available_service_name": availableServiceName,
//         "available_service_system_name": availableServiceSystemName,
//         "available_service_default_price": availableServiceDefaultPrice,
//         "available_service_logo": availableServiceLogo,
//         "available_service_convinience_fee": availableServiceConvinienceFee,
//         "available_service_price_editable": availableServicePriceEditable,
//         "is_verify_device": isVerifyDevice,
//         "discounted_price": discountedPrice,
//         "available_service_actual_price": availableServiceActualPrice,
//       };
// }

// class AvailableService {
//   final int? availableServiceId;
//   final int? availableServiceParentId;
//   final String? availableServiceName;
//   final String? availableServiceSystemName;
//   final String? availableServiceDefaultPrice;
//   final String? availableServiceLogo;
//   final String? availableServiceConvinienceFee;
//   final String? availableServicePriceEditable;
//   final String? isVerifyDevice;
//   final double? discountedPrice;
//   final double? availableServiceActualPrice;

//   AvailableService({
//     this.availableServiceId,
//     this.availableServiceParentId,
//     this.availableServiceName,
//     this.availableServiceSystemName,
//     this.availableServiceDefaultPrice,
//     this.availableServiceLogo,
//     this.availableServiceConvinienceFee,
//     this.availableServicePriceEditable,
//     this.isVerifyDevice,
//     this.discountedPrice,
//     this.availableServiceActualPrice,
//   });

//   factory AvailableService.fromJson(Map<String, dynamic> json) {
//     return AvailableService(
//       availableServiceId: json['available_service_id'] as int?,
//       availableServiceParentId: json['available_service_parent_id'] as int?,
//       availableServiceName: json['available_service_name'] as String?,
//       availableServiceSystemName:
//           json['available_service_system_name'] as String?,
//       availableServiceDefaultPrice:
//           json['available_service_default_price'] as String?,
//       availableServiceLogo: json['available_service_logo'] as String?,
//       availableServiceConvinienceFee:
//           json['available_service_convinience_fee'] as String?,
//       availableServicePriceEditable:
//           json['available_service_price_editable'] as String?,
//       isVerifyDevice: json['is_verify_device'] as String?,
//       discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
//       availableServiceActualPrice:
//           (json['available_service_actual_price'] as num?)?.toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'available_service_id': availableServiceId,
//       'available_service_parent_id': availableServiceParentId,
//       'available_service_name': availableServiceName,
//       'available_service_system_name': availableServiceSystemName,
//       'available_service_default_price': availableServiceDefaultPrice,
//       'available_service_logo': availableServiceLogo,
//       'available_service_convinience_fee': availableServiceConvinienceFee,
//       'available_service_price_editable': availableServicePriceEditable,
//       'is_verify_device': isVerifyDevice,
//       'discounted_price': discountedPrice,
//       'available_service_actual_price': availableServiceActualPrice,
//     };
//   }
// }

// Electricity Distribution Service Model
class ElectricityService {
  final int? availableServiceId;
  final int? availableServiceParentId;
  final String? availableServiceName;
  final String? availableServiceSystemName;
  final String? availableServiceDefaultPrice;
  final String? availableServiceLogo;
  final String? availableServiceConvenienceFee;
  final bool? availableServicePriceEditable;
  final bool? isVerifyDevice;
  final int? discountedPrice;
  final int? availableServiceActualPrice;

  ElectricityService({
    this.availableServiceId,
    this.availableServiceParentId,
    this.availableServiceName,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.availableServiceLogo,
    this.availableServiceConvenienceFee,
    this.availableServicePriceEditable,
    this.isVerifyDevice,
    this.discountedPrice,
    this.availableServiceActualPrice,
  });

  factory ElectricityService.fromJson(Map<String, dynamic> json) {
    return ElectricityService(
      availableServiceId: json['available_service_id'] as int?,
      availableServiceParentId: json['available_service_parent_id'] as int?,
      availableServiceName: json['available_service_name'] as String?,
      availableServiceSystemName:
          json['available_service_system_name'] as String?,
      availableServiceDefaultPrice:
          json['available_service_default_price'] as String?,
      availableServiceLogo: json['available_service_logo'] as String?,
      availableServiceConvenienceFee:
          json['available_service_convinience_fee'] as String?,
      availableServicePriceEditable:
          json['available_service_price_editable'] == 'true',
      isVerifyDevice: json['is_verify_device'] == 'yes',
      discountedPrice: json['discounted_price'] as int?,
      availableServiceActualPrice:
          json['available_service_actual_price'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_service_id': availableServiceId,
      'available_service_parent_id': availableServiceParentId,
      'available_service_name': availableServiceName,
      'available_service_system_name': availableServiceSystemName,
      'available_service_default_price': availableServiceDefaultPrice,
      'available_service_logo': availableServiceLogo,
      'available_service_convinience_fee': availableServiceConvenienceFee,
      'available_service_price_editable':
          availableServicePriceEditable?.toString(),
      'is_verify_device': isVerifyDevice == true ? 'yes' : 'no',
      'discounted_price': discountedPrice,
      'available_service_actual_price': availableServiceActualPrice,
    };
  }
}

// Electricity Provider Model
class ElectricityProvider {
  final String? serviceName;
  final String? slug;

  ElectricityProvider({
    this.serviceName,
    this.slug,
  });

  factory ElectricityProvider.fromJson(Map<String, dynamic> json) {
    return ElectricityProvider(
      serviceName: json['service_name'] as String?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'slug': slug,
    };
  }
}

// Electricity Bill Model to encompass the entire structure
class ElectricityBill {
  final Map<String, List<ElectricityService>>? electricityServices;
  final List<ElectricityProvider>? providers;

  ElectricityBill({
    this.electricityServices,
    this.providers,
  });

  factory ElectricityBill.fromJson(Map<String, dynamic> json) {
    // Remove the 'provider' key from the services before processing
    Map<String, dynamic> servicesJson = Map.from(json);
    List<ElectricityProvider> providersList =
        (servicesJson.remove('provider') as List)
            .map((providerJson) => ElectricityProvider.fromJson(providerJson))
            .toList();

    // Process electricity services
    Map<String, List<ElectricityService>> services = {};
    servicesJson.forEach((key, value) {
      services[key] = (value as List)
          .map((serviceJson) => ElectricityService.fromJson(serviceJson))
          .toList();
    });

    return ElectricityBill(
      electricityServices: services,
      providers: providersList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    // Add electricity services
    electricityServices?.forEach((key, services) {
      json[key] = services.map((service) => service.toJson()).toList();
    });

    // Add providers
    json['provider'] = providers?.map((provider) => provider.toJson()).toList();

    return json;
  }
}

class Faq {
  final int? id;
  final int? categoryId;
  final String? type;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic faqVideo;

  Faq({
    this.id,
    this.categoryId,
    this.type,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.faqVideo,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        categoryId: json["category_id"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        faqVideo: json["faq_video"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "type": type,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "faq_video": faqVideo,
      };
}

class Kyc {
  final String? availability;
  final String? verifier;
  final String? isNinVerified;
  final String? isBvnVerified;

  Kyc({
    this.availability,
    this.verifier,
    this.isNinVerified,
    this.isBvnVerified,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
        availability: json["availability"],
        verifier: json["verifier"],
        isNinVerified: json["is_nin_verified"],
        isBvnVerified: json["is_bvn_verified"],
      );

  Map<String, dynamic> toJson() => {
        "availability": availability,
        "verifier": verifier,
        "is_nin_verified": isNinVerified,
        "is_bvn_verified": isBvnVerified,
      };
}

class Promo {
  final List<Dynamic>? promoDynamic;
  final dynamic promoStatic;

  Promo({
    this.promoDynamic,
    this.promoStatic,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        promoDynamic: json["dynamic"] == null
            ? []
            : List<Dynamic>.from(
                json["dynamic"]!.map((x) => Dynamic.fromJson(x))),
        promoStatic: json["static"],
      );

  Map<String, dynamic> toJson() => {
        "dynamic": promoDynamic == null
            ? []
            : List<dynamic>.from(promoDynamic!.map((x) => x.toJson())),
        "static": promoStatic,
      };
}

class Dynamic {
  final int? id;
  final String? promoTitle;
  final dynamic promoDiscount;
  final String? promoLogo;
  final String? promoDescription;
  final String? promoSubDescription;
  final String? promoContent;
  final int? isStatic;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Dynamic({
    this.id,
    this.promoTitle,
    this.promoDiscount,
    this.promoLogo,
    this.promoDescription,
    this.promoSubDescription,
    this.promoContent,
    this.isStatic,
    this.createdAt,
    this.updatedAt,
  });

  factory Dynamic.fromJson(Map<String, dynamic> json) => Dynamic(
        id: json["id"],
        promoTitle: json["promo_title"],
        promoDiscount: json["promo_discount"],
        promoLogo: json["promo_logo"],
        promoDescription: json["promo_description"],
        promoSubDescription: json["promo_sub_description"],
        promoContent: json["promo_content"],
        isStatic: json["is_static"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "promo_title": promoTitle,
        "promo_discount": promoDiscount,
        "promo_logo": promoLogo,
        "promo_description": promoDescription,
        "promo_sub_description": promoSubDescription,
        "promo_content": promoContent,
        "is_static": isStatic,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class RechargeCard {
  final List<dynamic>? the9MobileRechargeCardPin;
  final List<dynamic>? airtelRechargeCardPin;
  final List<SmileDatum>? gloRechargeCardPin;
  final List<SmileDatum>? mtnRechargeCardPin;
  final List<TypeElement>? provider;

  RechargeCard({
    this.the9MobileRechargeCardPin,
    this.airtelRechargeCardPin,
    this.gloRechargeCardPin,
    this.mtnRechargeCardPin,
    this.provider,
  });

  factory RechargeCard.fromJson(Map<String, dynamic> json) => RechargeCard(
        the9MobileRechargeCardPin: json["9mobile_recharge_card_pin"] == null
            ? []
            : List<dynamic>.from(
                json["9mobile_recharge_card_pin"]!.map((x) => x)),
        airtelRechargeCardPin: json["airtel_recharge_card_pin"] == null
            ? []
            : List<dynamic>.from(
                json["airtel_recharge_card_pin"]!.map((x) => x)),
        gloRechargeCardPin: json["glo_recharge_card_pin"] == null
            ? []
            : List<SmileDatum>.from(json["glo_recharge_card_pin"]!
                .map((x) => SmileDatum.fromJson(x))),
        mtnRechargeCardPin: json["mtn_recharge_card_pin"] == null
            ? []
            : List<SmileDatum>.from(json["mtn_recharge_card_pin"]!
                .map((x) => SmileDatum.fromJson(x))),
        provider: json["provider"] == null
            ? []
            : List<TypeElement>.from(
                json["provider"]!.map((x) => TypeElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "9mobile_recharge_card_pin": the9MobileRechargeCardPin == null
            ? []
            : List<dynamic>.from(the9MobileRechargeCardPin!.map((x) => x)),
        "airtel_recharge_card_pin": airtelRechargeCardPin == null
            ? []
            : List<dynamic>.from(airtelRechargeCardPin!.map((x) => x)),
        "glo_recharge_card_pin": gloRechargeCardPin == null
            ? []
            : List<dynamic>.from(gloRechargeCardPin!.map((x) => x.toJson())),
        "mtn_recharge_card_pin": mtnRechargeCardPin == null
            ? []
            : List<dynamic>.from(mtnRechargeCardPin!.map((x) => x.toJson())),
        "provider": provider == null
            ? []
            : List<dynamic>.from(provider!.map((x) => x.toJson())),
      };
}

class SettingsData {
  final String? securityQuestions;

  SettingsData({
    this.securityQuestions,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) => SettingsData(
        securityQuestions: json["security_questions"],
      );

  Map<String, dynamic> toJson() => {
        "security_questions": securityQuestions,
      };
}

class Tv {
  final List<TvProvider>? providers;
  final List<TvAvailableService>? dstv;
  final List<TvAvailableService>? gotv;
  final List<TvAvailableService>? startimes;

  Tv({
    this.providers,
    this.dstv,
    this.gotv,
    this.startimes,
  });

  factory Tv.fromJson(Map<String, dynamic> json) {
    return Tv(
      providers: json['provider'] != null
          ? (json['provider'] as List)
              .map((e) => TvProvider.fromJson(e))
              .toList()
          : null,
      dstv: json['dstv'] != null
          ? (json['dstv'] as List)
              .map((e) => TvAvailableService.fromJson(e))
              .toList()
          : null,
      gotv: json['gotv'] != null
          ? (json['gotv'] as List)
              .map((e) => TvAvailableService.fromJson(e))
              .toList()
          : null,
      startimes: json['startimes'] != null
          ? (json['startimes'] as List)
              .map((e) => TvAvailableService.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': providers?.map((e) => e.toJson()).toList(),
      'dstv': dstv?.map((e) => e.toJson()).toList(),
      'gotv': gotv?.map((e) => e.toJson()).toList(),
      'startimes': startimes?.map((e) => e.toJson()).toList(),
    };
  }
}

class TvProvider {
  final int? subServiceId;
  final int? subServiceParentId;
  final String? subServiceName;
  final String? subServiceCode;
  final String? subServiceLogo;
  final String? subServiceDescription;

  TvProvider({
    this.subServiceId,
    this.subServiceParentId,
    this.subServiceName,
    this.subServiceCode,
    this.subServiceLogo,
    this.subServiceDescription,
  });

  factory TvProvider.fromJson(Map<String, dynamic> json) {
    return TvProvider(
      subServiceId: json['sub_service_id'],
      subServiceParentId: json['sub_service_parent_id'],
      subServiceName: json['sub_service_name'],
      subServiceCode: json['sub_service_code'],
      subServiceLogo: json['sub_service_logo'],
      subServiceDescription: json['sub_service_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_service_id': subServiceId,
      'sub_service_parent_id': subServiceParentId,
      'sub_service_name': subServiceName,
      'sub_service_code': subServiceCode,
      'sub_service_logo': subServiceLogo,
      'sub_service_description': subServiceDescription,
    };
  }
}

class TvAvailableService {
  final int? availableServiceId;
  final int? availableServiceParentId;
  final String? availableServiceName;
  final String? availableServiceSystemName;
  final String? availableServiceDefaultPrice;
  final String? availableServiceLogo;
  final String? availableServiceConvinienceFee;
  final String? availableServicePriceEditable;
  final String? isVerifyDevice;
  final double? discountedPrice;
  final double? availableServiceActualPrice;

  TvAvailableService({
    this.availableServiceId,
    this.availableServiceParentId,
    this.availableServiceName,
    this.availableServiceSystemName,
    this.availableServiceDefaultPrice,
    this.availableServiceLogo,
    this.availableServiceConvinienceFee,
    this.availableServicePriceEditable,
    this.isVerifyDevice,
    this.discountedPrice,
    this.availableServiceActualPrice,
  });

  factory TvAvailableService.fromJson(Map<String, dynamic> json) {
    return TvAvailableService(
      availableServiceId: json['available_service_id'],
      availableServiceParentId: json['available_service_parent_id'],
      availableServiceName: json['available_service_name'],
      availableServiceSystemName: json['available_service_system_name'],
      availableServiceDefaultPrice: json['available_service_default_price'],
      availableServiceLogo: json['available_service_logo'],
      availableServiceConvinienceFee: json['available_service_convinience_fee'],
      availableServicePriceEditable: json['available_service_price_editable'],
      isVerifyDevice: json['is_verify_device'],
      discountedPrice: json['discounted_price'] is num
          ? (json['discounted_price'] as num).toDouble()
          : null,
      availableServiceActualPrice: json['available_service_actual_price'] is num
          ? (json['available_service_actual_price'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_service_id': availableServiceId,
      'available_service_parent_id': availableServiceParentId,
      'available_service_name': availableServiceName,
      'available_service_system_name': availableServiceSystemName,
      'available_service_default_price': availableServiceDefaultPrice,
      'available_service_logo': availableServiceLogo,
      'available_service_convinience_fee': availableServiceConvinienceFee,
      'available_service_price_editable': availableServicePriceEditable,
      'is_verify_device': isVerifyDevice,
      'discounted_price': discountedPrice,
      'available_service_actual_price': availableServiceActualPrice,
    };
  }
}

class UserAutoWalletAccount {
  final String? bankName;
  final String? accountNumber;
  final String? customerName;
  final String? paymentGateway;

  UserAutoWalletAccount({
    this.bankName,
    this.accountNumber,
    this.customerName,
    this.paymentGateway,
  });

  factory UserAutoWalletAccount.fromJson(Map<String, dynamic> json) =>
      UserAutoWalletAccount(
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        customerName: json["customer_name"],
        paymentGateway: json["payment_gateway"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "account_number": accountNumber,
        "customer_name": customerName,
        "payment_gateway": paymentGateway,
      };
}

class UserManualAccount {
  final String? bankName;
  final String? accountName;
  final String? accountNumber;

  UserManualAccount({
    this.bankName,
    this.accountName,
    this.accountNumber,
  });

  factory UserManualAccount.fromJson(Map<String, dynamic> json) =>
      UserManualAccount(
        bankName: json["bank_name"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "account_name": accountName,
        "account_number": accountNumber,
      };
}

class UserSettings {
  final int? settingsId;
  final int? notifyMe;
  final dynamic address;
  final dynamic signature;
  final dynamic deliveryUrl;
  final int? sendDelivery;
  final int? sendReports;
  final String? countryCode;
  final String? commRegime;
  final String? lowBalanceTrigger;
  final dynamic pushNotification;
  final dynamic serviceRouting;
  final dynamic userConfig;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? email;
  final String? username;
  final int? hasSetUpTransactionPin;
  final String? fullname;
  final String? dob;

  UserSettings({
    this.settingsId,
    this.notifyMe,
    this.address,
    this.signature,
    this.deliveryUrl,
    this.sendDelivery,
    this.sendReports,
    this.countryCode,
    this.commRegime,
    this.lowBalanceTrigger,
    this.pushNotification,
    this.serviceRouting,
    this.userConfig,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.username,
    this.hasSetUpTransactionPin,
    this.fullname,
    this.dob,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        settingsId: json["settings_id"],
        notifyMe: json["notifyMe"],
        address: json["address"],
        signature: json["signature"],
        deliveryUrl: json["DeliveryURL"],
        sendDelivery: json["sendDelivery"],
        sendReports: json["sendReports"],
        countryCode: json["country_code"],
        commRegime: json["comm_regime"],
        lowBalanceTrigger: json["low_balance_trigger"],
        pushNotification: json["push_notification"],
        serviceRouting: json["service_routing"],
        userConfig: json["user_config"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        email: json["email"],
        username: json["username"],
        hasSetUpTransactionPin: json["has_set_up_transaction_pin"],
        fullname: json["fullname"],
        dob: json["dob"],
      );

  Map<String, dynamic> toJson() => {
        "settings_id": settingsId,
        "notifyMe": notifyMe,
        "address": address,
        "signature": signature,
        "DeliveryURL": deliveryUrl,
        "sendDelivery": sendDelivery,
        "sendReports": sendReports,
        "country_code": countryCode,
        "comm_regime": commRegime,
        "low_balance_trigger": lowBalanceTrigger,
        "push_notification": pushNotification,
        "service_routing": serviceRouting,
        "user_config": userConfig,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "email": email,
        "username": username,
        "has_set_up_transaction_pin": hasSetUpTransactionPin,
        "fullname": fullname,
        "dob": dob,
      };
}

class WebsiteData {
  final String? siteTitle;
  final String? theme;
  final String? address;
  final String? websiteUrl;
  final String? websiteEmail;
  final String? phone;
  final String? whatsappLink;
  final String? whatsappLinkGroup;
  final String? websiteWhatsappPhone;
  final String? whatsappPhone;
  final List<AtmProvider>? atmProviders;
  final FilterParameter? filterParameter;
  final List<FilterSearch>? filterSearch;

  WebsiteData({
    this.siteTitle,
    this.theme,
    this.address,
    this.websiteUrl,
    this.websiteEmail,
    this.phone,
    this.whatsappLink,
    this.whatsappLinkGroup,
    this.websiteWhatsappPhone,
    this.whatsappPhone,
    this.atmProviders,
    this.filterParameter,
    this.filterSearch,
  });

  factory WebsiteData.fromJson(Map<String, dynamic> json) => WebsiteData(
        siteTitle: json["site_title"],
        theme: json["theme"],
        address: json["address"],
        websiteUrl: json["website_url"],
        websiteEmail: json["website_email"],
        phone: json["phone"],
        whatsappLink: json["whatsapp_link"],
        whatsappLinkGroup: json["whatsapp_link_group"],
        websiteWhatsappPhone: json["website_whatsapp_phone"],
        whatsappPhone: json["whatsapp_phone"],
        atmProviders: json["atm_providers"] == null
            ? []
            : List<AtmProvider>.from(
                json["atm_providers"]!.map((x) => AtmProvider.fromJson(x))),
        filterParameter: json["filter_parameter"] == null
            ? null
            : FilterParameter.fromJson(json["filter_parameter"]),
        filterSearch: json["filter_search"] == null
            ? []
            : List<FilterSearch>.from(
                json["filter_search"]!.map((x) => FilterSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "site_title": siteTitle,
        "theme": theme,
        "address": address,
        "website_url": websiteUrl,
        "website_email": websiteEmail,
        "phone": phone,
        "whatsapp_link": whatsappLink,
        "whatsapp_link_group": whatsappLinkGroup,
        "website_whatsapp_phone": websiteWhatsappPhone,
        "whatsapp_phone": whatsappPhone,
        "atm_providers": atmProviders == null
            ? []
            : List<dynamic>.from(atmProviders!.map((x) => x.toJson())),
        "filter_parameter": filterParameter?.toJson(),
        "filter_search": filterSearch == null
            ? []
            : List<dynamic>.from(filterSearch!.map((x) => x.toJson())),
      };
}

class AtmProvider {
  final String? name;
  final String? slug;
  final String? fixedChargeAtm;
  final String? fixedChargeBank;
  final String? percentChargeAtm;
  final String? chargeAbove2500Bank;
  final String? stampChargeBank;
  final String? chargeAbove2500Atm;
  final String? stampChargeAtm;
  final String? percentChargeBank;
  final String? logo;

  AtmProvider({
    this.name,
    this.slug,
    this.fixedChargeAtm,
    this.fixedChargeBank,
    this.percentChargeAtm,
    this.chargeAbove2500Bank,
    this.stampChargeBank,
    this.chargeAbove2500Atm,
    this.stampChargeAtm,
    this.percentChargeBank,
    this.logo,
  });

  factory AtmProvider.fromJson(Map<String, dynamic> json) => AtmProvider(
        name: json["name"],
        slug: json["slug"],
        fixedChargeAtm: json["fixed_charge_atm"],
        fixedChargeBank: json["fixed_charge_bank"],
        percentChargeAtm: json["percent_charge_atm"],
        chargeAbove2500Bank: json["charge_above_2500_bank"],
        stampChargeBank: json["stamp_charge_bank"],
        chargeAbove2500Atm: json["charge_above_2500_atm"],
        stampChargeAtm: json["stamp_charge_atm"],
        percentChargeBank: json["percent_charge_bank"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "fixed_charge_atm": fixedChargeAtm,
        "fixed_charge_bank": fixedChargeBank,
        "percent_charge_atm": percentChargeAtm,
        "charge_above_2500_bank": chargeAbove2500Bank,
        "stamp_charge_bank": stampChargeBank,
        "charge_above_2500_atm": chargeAbove2500Atm,
        "stamp_charge_atm": stampChargeAtm,
        "percent_charge_bank": percentChargeBank,
        "logo": logo,
      };
}

class FilterParameter {
  final Txn? walletTxn;
  final Txn? rechargeTxn;

  FilterParameter({
    this.walletTxn,
    this.rechargeTxn,
  });

  factory FilterParameter.fromJson(Map<String, dynamic> json) =>
      FilterParameter(
        walletTxn: json["wallet_txn"] == null
            ? null
            : Txn.fromJson(json["wallet_txn"]),
        rechargeTxn: json["recharge_txn"] == null
            ? null
            : Txn.fromJson(json["recharge_txn"]),
      );

  Map<String, dynamic> toJson() => {
        "wallet_txn": walletTxn?.toJson(),
        "recharge_txn": rechargeTxn?.toJson(),
      };
}

class Txn {
  final List<Category>? flow;
  final List<Category>? category;

  Txn({
    this.flow,
    this.category,
  });

  factory Txn.fromJson(Map<String, dynamic> json) => Txn(
        flow: json["flow"] == null
            ? []
            : List<Category>.from(
                json["flow"]!.map((x) => Category.fromJson(x))),
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flow": flow == null
            ? []
            : List<dynamic>.from(flow!.map((x) => x.toJson())),
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class Category {
  final String? name;
  final String? slug;

  Category({
    this.name,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
      };
}

class FilterSearch {
  final String? label;
  final String? type;
  final String? name;
  final String? placeholder;
  final List<Option>? options;

  FilterSearch({
    this.label,
    this.type,
    this.name,
    this.placeholder,
    this.options,
  });

  factory FilterSearch.fromJson(Map<String, dynamic> json) => FilterSearch(
        label: json["label"],
        type: json["type"],
        name: json["name"],
        placeholder: json["placeholder"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "type": type,
        "name": name,
        "placeholder": placeholder,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  final String? name;
  final String? value;

  Option({
    this.name,
    this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
