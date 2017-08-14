////
////  LJJSPatchManager.m
////  news
////
////  Created by chunhui on 16/5/11.
////  Copyright © 2016年 lanjing. All rights reserved.
////
//
//#import "LJJSPatchManager.h"
//#import "TKRequestHandler+JSPatch.h"
//#import "JPEngine.h"
//#import "TKAppInfo.h"
//#import "TKFileUtil.h"
//#import "SSZipArchive.h"
//
//#define kJSPatchVersion @"_JSPatchVersion"
//#define kJSPassword @"__lanjing_js_patch__"
//
//#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//
//@interface LJJSPatchManager ()
//
//@property(nonatomic , strong) NSString *version;
//@property(nonatomic , strong) NSString *url;
//@property(nonatomic , strong) NSString *sign;//base64(rsa(md5(file)))
//
//@end
//
//@implementation LJJSPatchManager
//
//+ (instancetype)sharedInstance
//{
//    static dispatch_once_t once;
//    static id __singleton__;
//    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
//    return __singleton__;
//}
//
//#if 0
//
//-(instancetype)init
//{
//    self = [super init];
//    if (self) {
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        NSString *jversion = [userdefault objectForKey:kJSPatchVersion];
//        self.version = jversion ?: @"0.0.0";
//        
//        NSString *patchDir = [self scriptDirectory];
//        NSFileManager *fm = [NSFileManager defaultManager];
//        NSArray *files = [fm contentsOfDirectoryAtPath:patchDir error:nil];
//        if ([files count] > 0) {
//            
//            NSString *jsPath = nil;
//            for (NSString *name in files) {
//                if ([[name pathExtension] isEqualToString:@"js"]) {
//                    jsPath = [patchDir stringByAppendingPathComponent:name];
//                    break;
//                }
//            }
//            if (jsPath) {
//                [JPEngine startEngine];
//                NSString *script = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
//                [JPEngine evaluateScript:script];
//            }
//        }
//    }
//    return self;
//}
//
//
//-(void)handleJsPatchZip:(NSString *)zipPath
//{
//    NSString *appVersion = [TKAppInfo appVersion];
//    NSString *scriptDirectory = [self scriptDirectory];
//    NSString *version = self.version;
//    
//    // temporary files and directories
//    NSString *downloadTmpPath = [NSString stringWithFormat:@"%@patch_%@_%@", NSTemporaryDirectory(), appVersion, version];
//    NSString *unzipTmpDirectory = [NSString stringWithFormat:@"%@patch_%@_%@_unzip/", NSTemporaryDirectory(), appVersion, version];
//    
//    NSString *dataSign  = [TKFileUtil fileMD5:zipPath];
//    
//    if (![[dataSign lowercaseString] isEqualToString:[self.sign lowercaseString]]) {
//        //download file corrupt
//        [TKFileUtil removeFilesAtPath:downloadTmpPath];
//        return;
//    }
//    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
//    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipTmpDirectory overwrite:true password:kJSPassword error:nil]){
//        
//        NSArray *files = [fm contentsOfDirectoryAtPath:unzipTmpDirectory error:nil];
//        if (files) {
//            
//            [fm removeItemAtPath:scriptDirectory error:nil];
//            [fm createDirectoryAtPath:scriptDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//            
//            
//            for (NSString *filename in files) {
//                if ([[filename pathExtension] isEqualToString:@"js"]) {
//                    NSString *filePath = [unzipTmpDirectory stringByAppendingPathComponent:filename];
//                    NSString *newFilePath = [scriptDirectory stringByAppendingPathComponent:filename];
//                    [[NSData dataWithContentsOfFile:filePath] writeToFile:newFilePath atomically:YES];
//                }
//            }
//            
//            //保存版本号
//            [USER_DEFAULT setObject:version forKey:kJSPatchVersion];
//        }
//    }
//    
//    [fm removeItemAtPath:downloadTmpPath error:nil];
//    [fm removeItemAtPath:unzipTmpDirectory error:nil];
//    
//}
//
//-(void)loadConfig
//{
//    __weak typeof(self) weakSelf = self;
//    [[TKRequestHandler sharedInstance] getJSPatchConfig:self.version completion:^(NSURLSessionDataTask *task, NSString *version, NSString *url, NSString *sign) {
//        if (version.length > 0) {
//            weakSelf.version = version;
//            weakSelf.url = url;
//            weakSelf.sign = sign;
//            
//            [weakSelf downloadPatch];
//        }
//    }];
//}
//
//-(void)downloadPatch
//{
//    __weak typeof(self) weakSelf = self;
//    [[TKRequestHandler sharedInstance] downloadFile:self.url finish:^(NSURLSessionDataTask *sessionDataTask, NSString *downloadPath, NSError *error) {
//        if (error == nil) {
//            [weakSelf handleJsPatchZip:downloadPath];
//        }
//    }];
//}
//
//- (NSString *)scriptDirectory
//{
//    NSString *appVersion = [TKAppInfo appVersion];
//    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *scriptDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JSPatch/%@/", appVersion]];
//    return scriptDirectory;
//}
//
//#endif
//
//@end
