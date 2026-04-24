
import 'package:get/get.dart';

class ServerConfig {
  //todo: change version and change server

  //versionDetails
  static String versionName = "1.0.0";
  static String androidVersionCode = "1";
  static String iosVersionCode = "1";

//prod




  static String baseUrl = "https://iaimasa.4techbugs.in/MasterCoding.asmx/";
  static String baseUrl_image = "";

  ///WebPageConfig

  ///---------------------------------------------------------
}

class ApiEndpoints {
  //bearerTokenApi or call it Guest mode token
  //static String bearerTokenApi = '${ServerConfig.baseUrl}o/oauth2/token';
  static String bearerTokenApi = '${ServerConfig.baseUrl}o/oauth2/token';
  static String refreshTokenApi = '${ServerConfig.baseUrl}o/oauth2/token';

  // Pkc method login Endpoints
  static String LoginUrl = '${ServerConfig.baseUrl}LoginRequest';
  static String VerifyOTP = '${ServerConfig.baseUrl}VerifyOTPForRequest';
  static String GetTripAPI = '${ServerConfig.baseUrl}GetTripRequestFullData';
  static String GetUserDetailAPI = '${ServerConfig.baseUrl}GetTravelerByID';
  static String GetCityAPI = '${ServerConfig.baseUrl}GetCity';
  static String PostAddTripRequestAPI = '${ServerConfig.baseUrl}AddTripRequestEmployeeNew';
  static String PostSaveTravellerRequestAPI = '${ServerConfig.baseUrl}SaveTravelerinRequestTrip';
  static String PostSaveTripDetails = '${ServerConfig.baseUrl}SaveTripDetails';
  static String PostRejectApprovedAPI = '${ServerConfig.baseUrl}TripRequestStatus';
  static String SecurityLoginUrl = '${ServerConfig.baseUrl}LoginWithoutPassword';
  static String SecurityVerifyOTP = '${ServerConfig.baseUrl}VerifyOTPWithoutPassword';
  static String GetHotelApi = '${ServerConfig.baseUrl}GetHotelsNew';
  static String GetMapHotelApi = '${ServerConfig.baseUrl}GetTripFullDataWithInclusive';
  static String GetMyTripAPI = '${ServerConfig.baseUrl}GetTripFullDataWithInclusiveWithUserID';
  static String GetMyTripDetailsAPI = '${ServerConfig.baseUrl}GetTripFullDataWithInclusiveWithUserIDData';
  static String postEmpTokenAPI = '${ServerConfig.baseUrl}UpdateTravlerToken';
  static String getHotelByCityAPI = '${ServerConfig.baseUrl}GetHotelsByCityID';
  static String postInsertTripExpenseAPI = '${ServerConfig.baseUrl}InsertTripExpense';
  static String GetExpenceMasterListAPI = '${ServerConfig.baseUrl}GetExpenceMasterList';
  static String GetExpenceAprovedListAPI = '${ServerConfig.baseUrl}GetTripExpenceByReportToFinal';
  static String GetMyExpenceListAPI = '${ServerConfig.baseUrl}GetTripExpensesUserId';
  static String uploadExpenceImageAPI = '${ServerConfig.baseUrl}UploadImage';
  static String aproveRejectExpenceAPI = '${ServerConfig.baseUrl}UpdateTripExpenseApproved';
  static String deleteExpenceAPI = '${ServerConfig.baseUrl}DeleteTripExpense';
  static String CalculateAmount = '${ServerConfig.baseUrl}CalculateAmount';
  static String GettExprnceChatAPI = '${ServerConfig.baseUrl}GetExpenseChat';
  static String PostExprnceChatAPI = '${ServerConfig.baseUrl}TripExpenceChat';
  static String DeleteTripRequest = '${ServerConfig.baseUrl}DeleteTripRequest';




}
