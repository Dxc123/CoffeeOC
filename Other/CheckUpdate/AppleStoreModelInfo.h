//
//  AppleStoreModelInfo.h
//  CheckNewVersion
//
//  Created by lalala on 2017/4/20.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleStoreModelInfo : NSObject
/*
 @param  版本号
 */
@property (nonatomic,copy) NSString * version;
/**
 *  更新日志
 */
@property(nonatomic,copy)NSString *releaseNotes;

/**
 *  更新时间
 */
@property(nonatomic,copy)NSString *currentVersionReleaseDate;

/**
 *  APPId
 */
@property(nonatomic,copy)NSString *trackId;

/**
 *  bundleId
 */
@property(nonatomic,copy)NSString *bundleId;

/**
 *  AppStore地址
 */
@property(nonatomic,copy)NSString *trackViewUrl;

/**
 *  开发商
 */
@property(nonatomic,copy)NSString *sellerName;

/**
 *  文件大小
 */
@property(nonatomic,copy)NSString *fileSizeBytes;

/**
 *  展示图
 */
@property(nonatomic,strong)NSArray *screenshotUrls;

//返回的所有字段
/*
 {
 resultCount = 1;
 results =     (
 {
 advisories =             (
 "\U5076\U5c14/\U8f7b\U5fae\U7684\U4eb5\U6e0e\U6216\U4f4e\U4fd7\U5e7d\U9ed8",
 "\U5076\U5c14/\U8f7b\U5fae\U7684\U5361\U901a\U6216\U5e7b\U60f3\U66b4\U529b",
 "\U5076\U5c14/\U8f7b\U5fae\U7684\U6210\U4eba/\U6027\U6697\U793a\U9898\U6750"
 );
 appletvScreenshotUrls =             (
 );
 artistId = ########5;
 artistName = "\U5317\U4eac\U6613\U805a\U521b\U610f\U79d1\U6280\U6709\U9650\U516c\U53f8";
 artistViewUrl = "";
 artworkUrl100 = "";
 artworkUrl512 = "";
 artworkUrl60 = "";
 averageUserRating = 5;
 bundleId = "#####";
 contentAdvisoryRating = "9+";
 currency = CNY;
 currentVersionReleaseDate = "2017-04-17T23:16:55Z";
 description = "\U56fd\U5185\U9996\U5bb6\U827a\U4eba\U517b\U6210\U4e92\U52a8\U5e73\U53f0\Uff0c\U4e92\U52a8\U66f4\U597d\U73a9\U3001\U8d5a\U94b1\U66f4\U5bb9\U6613\Uff0c\U7f8e\U5973\U9c9c\U8089\U4e91\U96c6\Uff0c\U6bd4\U5feb\U624b\U66f4\U6709\U610f\U601d\Uff0c\U6bd4\U79d2\U62cd\U66f4\U70ed\U95e8\U3002\n\n#\U4ea7\U54c1\U7279\U8272\n\U3010\U7ec3\U4e60\U751f\U8ba1\U5212\U3011\U8d75\U8587\U3001\U4f5f\U5927\U4e3a\U7b49\U4e00\U7ebf\U660e\U661f\U5750\U9547\U3001\U4e13\U4e1a\U827a\U4eba\U57f9\U517b\U56e2\U961f\U4fdd\U9a7e\U62a4\U822a\U3001\U591a\U6863\U660e\U661f\U7efc\U827a\U8282\U76ee\U4efb\U6027\U53c2\U52a0\Uff0c\U6253\U9020\U6700\U95ea\U8000\U7684\U65b0\U661f\Uff1b\n\U3010\U591a\U5143\U5316\U7cbe\U54c1\U5185\U5bb9\U3011\U97f3\U4e50\U8868\U6f14\U3001\U70ed\U821e\U3001\U6c7d\U8f66\U8bc4\U6d4b\U7b49\U591a\U79cd\U5782\U76f4\U5316\U591a\U5143\U5316\U7684\U5185\U5bb9\Uff0c\U8ba9\U60a8\U770b\U4e2a\U591f\Uff1b\n\U3010\U9177\U70ab\U793c\U7269\U3011\U53d8\U5f62\U6c7d\U8f66\U4eba\U3001\U751f\U65e5\U86cb\U7cd5\U7b49\U9177\U70ab\U793c\U7269\U7b49\U4f60\U6765\U4f53\U9a8c\Uff0c\U66f4\U6709\U591a\U79cd\U795e\U79d8\U793c\U7269\U7b49\U4f60\U6765\U5f00\U542f\Uff1b\n\U3010\U76f4\U64ad\U7efc\U827a\U3011\U300a\U9ebb\U8fa3\U661f\U8bbf\U300b\U3001\U300a\U65b9\U5411\U76d8\U5e7f\U573a\U300b\U7b49\U591a\U6863\U7535\U89c6\U53f0\U7ea7\U7684\U76f4\U64ad\U7efc\U827a\U8282\U76ee\Uff1b\n\U3010\U5267\U573a\U76f4\U64ad\U3011\U5343\U4e07\U73b0\U91d1\U8eba\U7740\U62a2\Uff0c\U5e05\U54e5\U7f8e\U5973\U4efb\U4f60\U7838\Uff0c\U770b\U8c01\U4e0d\U723d\U5c31\U7838\U9e21\U86cb\Uff0c\U559c\U6b22\U4f60\U5c31\U9001\U95e8\U7968\Uff1b\n\U3010\U8fb9\U770b\U8fb9\U4e70\U3011\U770b\U5230\U4ec0\U4e48\U4e70\U4ec0\U4e48\Uff0c\U65e0\U8df3\U8f6c\U8d2d\U4e70\U3002\U5373\U53ef\U62e5\U6709\U660e\U661f\U540c\U6b3e\Uff0c\U518d\U4e5f\U4e0d\U7528\U62c5\U5fc3\U9519\U8fc7\U7cbe\U5f69\U5185\U5bb9\U3002\n\n#\U610f\U89c1\U53cd\U9988\n\U5b98\U65b9\U5fae\U535a\Uff1a@\U5168\U805a\U661f\n\U5b98\U65b9\U5fae\U4fe1\Uff1a\U670d\U52a1\U53f7\U201c\U5168\U805a\U661f\U201d\Uff0c\U8ba2\U9605\U53f7\U201c\U5168\U805a\U661f\U76f4\U64ad\U201d\n\U5ba2\U670dQQ: 2168756114\nQQ\U7fa4\Uff1a 516238965\n\U65f6\U523b\U503e\U542c\U4f60\U7684\U58f0\U97f3";
 features =             (
 );
 fileSizeBytes = 107057152;
 formattedPrice = "\U514d\U8d39";
 genreIds =             (

 );
 genres =             (
 "\U5a31\U4e50",
 "\U793e\U4ea4"
 );
 ipadScreenshotUrls =             (
 );
 isGameCenterEnabled = 0;
 isVppDeviceBasedLicensingEnabled = 1;
 kind = software;
 languageCodesISO2A =             (
 EN,
 ZH
 );
 minimumOsVersion = "8.0";
 price = 0;
 primaryGenreId = 6016;
 primaryGenreName = Entertainment;
 releaseDate = "2016-09-09T19:28:09Z";
 releaseNotes = "1\Uff0c\U65b0\U589e\U5267\U573a\U7ea2\U5305\Uff0c\U5267\U573a\U6bcf\U65f6\U6bcf\U523b\U90fd\U5728\U53d1\U7ea2\U5305\Uff0c\U4e00\U5929\U996d\U94b1\U8f7b\U677e\U6709\n2\Uff0c\U65b0\U589e\U7ea2\U5305\U6392\U884c\U699c\Uff0c\U6bd4\U6bd4\U8c01\U624b\U6c14\U66f4\U4f73\n3\Uff0c\U4fee\U6b63\U4e86\U90e8\U5206bug";
 screenshotUrls =             (
 );
 sellerName = "";
 sellerUrl = "http://www.grtstar.cn/";
 supportedDevices =             (
 "iPad2Wifi-iPad2Wifi",
 "iPad23G-iPad23G",
 "iPhone4S-iPhone4S",
 "iPadThirdGen-iPadThirdGen",
 "iPadThirdGen4G-iPadThirdGen4G",
 "iPhone5-iPhone5",
 "iPodTouchFifthGen-iPodTouchFifthGen",
 "iPadFourthGen-iPadFourthGen",
 "iPadFourthGen4G-iPadFourthGen4G",
 "iPadMini-iPadMini",
 "iPadMini4G-iPadMini4G",
 "iPhone5c-iPhone5c",
 "iPhone5s-iPhone5s",
 "iPadAir-iPadAir",
 "iPadAirCellular-iPadAirCellular",
 "iPadMiniRetina-iPadMiniRetina",
 "iPadMiniRetinaCellular-iPadMiniRetinaCellular",
 "iPhone6-iPhone6",
 "iPhone6Plus-iPhone6Plus",
 "iPadAir2-iPadAir2",
 "iPadAir2Cellular-iPadAir2Cellular",
 "iPadMini3-iPadMini3",
 "iPadMini3Cellular-iPadMini3Cellular",
 "iPodTouchSixthGen-iPodTouchSixthGen",
 "iPhone6s-iPhone6s",
 "iPhone6sPlus-iPhone6sPlus",
 "iPadMini4-iPadMini4",
 "iPadMini4Cellular-iPadMini4Cellular",
 "iPadPro-iPadPro",
 "iPadProCellular-iPadProCellular",
 "iPadPro97-iPadPro97",
 
 "iPadPro97Cellular-iPadPro97Cellular",
 "iPhoneSE-iPhoneSE",
 "iPhone7-iPhone7",
 "iPhone7Plus-iPhone7Plus",
 "iPad611-iPad611",
 "iPad612-iPad612"
 );
 trackCensoredName = "\U5168\U805a\U661f - \U827a\U4eba\U517b\U6210\U7efc\U827a\U76f4\U64ad\U5e73\U53f0";
 trackContentRating = "9+";
 trackId = ####;
 trackName = "\U5168\U805a\U661f - \U827a\U4eba\U517b\U6210\U7efc\U827a\U76f4\U64ad\U5e73\U53f0";
 trackViewUrl = "";
 userRatingCount = ;
 version = "";
 wrapperType = software;
 }
 );
 */

@end
