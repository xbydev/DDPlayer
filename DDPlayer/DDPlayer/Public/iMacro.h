#ifndef _IMACRO_H_
#define _IMACRO_H_

#import <UIKit/UIKit.h>

//-ObjC -all_load

#define MINUTE 60 
#define TENMINUTES (10 * MINUTE)
#define HOUR (60 * MINUTE) 
#define DAY (24 * HOUR) 
#define WEEK (7 * DAY)
#define MONTH (31 * DAY)   //2013.10.31
#define YEAR (12 * MONTH)   //2013.10.31

#define LOCAL(a) NSLocalizedString(a, nil)

//#define LOCAL_LANGUAGE [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]

#define RANDOM_0_1 (arc4random() / (float)0x100000000)

#define STR_EMPTY(str) (str == nil || [str isEqualToString:@""])

#define OBJ_EQUAL(o,o2) (o == o2 || [o isEqual:o2])

#define LOGV(view)  NSLog(@"%@", view)
#define LOGZ(size)  NSLog(@"size:[%f, %f]", size.width, size.height)
#define LOGF(frame) NSLog(@"frame:[%f, %f, %f, %f]", frame.origin.x, frame.origin.y, \
frame.size.width, frame.size.height)

//#define ccp(x,y) CGPointMake(x,y)

#define DEVICE_IS_IPAD  ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

#define DEVICE_IS_IPHONE  ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)

#define DEVICE_IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height < 568)

#define DEVICE_IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height >= 568)

#define DEVICE_IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height >= 667)

#define DEVICE_IS_PORTRAIT device_is_portrait()

#define DEVICE_IS_LANDSCAPE device_is_landscape()

#define DEVICE_IS_RETINA ([[UIScreen mainScreen] scale] > 1)

#define DEVICE_IS_SIMULATOR (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#define IOS_VERSION [[UIDevice currentDevice] systemVersion] 

#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define iOS6 ((([[UIDevice currentDevice].systemVersion intValue] >= 6) && ([[UIDevice currentDevice].systemVersion intValue] < 7)) ? YES : NO )

#define iOS5 ((([[UIDevice currentDevice].systemVersion intValue] >= 5) && ([[UIDevice currentDevice].systemVersion intValue] < 6)) ? YES : NO )

#define IOS_VERSION_Int [IOS_VERSION intValue]

#define CURRENT_INTERFACE_ORIEN [UIApplication sharedApplication].keyWindow.rootViewController.interfaceOrientation

#define CALL_ON_MAIN(block) dispatch_async(dispatch_get_main_queue(), ^{block;})

#define CALL_ON_BACKGROUND(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), \
                                  ^{block;})

#define SET_PROPERTY(_p, p) _p = p; //[p retain];[_p release]; _p = p;

#define RNIL(obj) obj = nil;  //[obj release]; obj = nil; 

#define RRNIL(view) [view removeFromSuperview]; view = nil; 

#define DOCUMENTS_PATH(path) [NSFileManager pathInDocuments:path]

#define LIBRARY_PATH(path) [NSFileManager pathInLibrary:path]

#define REG_NOTIFY(s, n) [[NSNotificationCenter defaultCenter] addObserver:self selector:s name:n object:nil];

#define POST_NOTIFY(n, o, u) [[NSNotificationCenter defaultCenter] postNotificationName:n object:o userInfo:u]

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:\
                                            (NSString*)kCFBundleVersionKey]

#define APP_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:\
                                            (NSString*)kCFBundleIdentifierKey]

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:\
                                            (NSString*)kCFBundleNameKey]

#define ASSERT_RETURN(c) if(!(c)) return;

#define DYNAMIC_CAST(className, obj) ([obj isKindOfClass:[className class]] ? (className*)obj : nil)

#define PYDATA_URL           @"http://tmp13962690232589893.duapp.com"
#define PYDATA_RES_URL(s)    [PYDATA_URL stringByAppendingFormat:@"/static/%@", s]
#define PYDATA_QUERY_URL(s)  [PYDATA_URL stringByAppendingFormat:@"?q=%@", s]

//[PYDATASTOREURL stringByAppendingString:@"/static/dailynotes.upt"]

#pragma mark - UI

#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#//define WINDOW_FRAME window_frame()

#define DEFAULT_TABLE_CELL_HEIGHT 44

#define DEFAULT_TABLE_MIN_ROWS 9

#define NAVI_VIEW_HEIGHT 416
#define NAVI_VIEW_HEIGHT_LAND 268

#define STATUS_BAR_HEIGHT 20   //status_bar_height()

#define NAVI_BAR_HEIGHT 44 

#define TAB_BAR_HEIGHT 49 

#define TOOL_BAR_HEIGHT 44

#define SOFT_KEYBOARD_HEIGHT 216

#define UIViewAutoresizingFlexibleSize (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)

#define UIViewAutoresizingFlexibleMargin (UIViewAutoresizingFlexibleLeftMargin | \
                                         UIViewAutoresizingFlexibleRightMargin | \
                                         UIViewAutoresizingFlexibleTopMargin | \
                                         UIViewAutoresizingFlexibleBottomMargin )

#define TOOLBAR_ITEM(image, selector) [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStylePlain target:self action:selector]

#define TOOLBAR_SPACE [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

#define DEFAULT_BTNTEXT_COLOR [UIColor colorWithRed:50/255.0 green:79/255.0 blue:133/255.0 alpha:1]

#define NSGBKStringEncoding CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#define ROOT_CTRL [UIApplication sharedApplication].keyWindow.rootViewController 

#define INDEX_PATH(row, section) [NSIndexPath indexPathForRow:row inSection:section]

#define IOS7_BUTTON_COLOR [UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1]

#define VIEW_INSET_TOP_TRANSLUCENT (IOS_VERSION_Int >= 7 ? 64 : 44)

#define  RGBCOLOR(v,a)      [UIColor colorWithRed:(((v&0xff0000)>>16)/255.0) green:(((v&0x00ff00)>>8)/255.0) blue:((v&0x00ff)/255.0) alpha:(a)]

#define BG1 [UIColor colorWithHexString:@"#f0f0f0"]

#define BG2 [UIColor colorWithHexString:@"#ffffff"]

#define TX1 [UIColor colorWithHexString:@"#333333"]

#define TX2 [UIColor colorWithHexString:@"#777777"]

#define TX3 [UIColor colorWithHexString:@"#a6a6a6"]

#define LI1 [UIColor colorWithHexString:@"#e5e5e5"]

#endif

