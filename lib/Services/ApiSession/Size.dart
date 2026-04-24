

import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';


final SecureStorageService _storageService = SecureStorageService();


Future<double?> get screenHeight async => await _storageService.getScreenHeight();

// Fixed the name to screenWidth
Future<double?> get screenWidth async => await _storageService.getScreenWidth();

