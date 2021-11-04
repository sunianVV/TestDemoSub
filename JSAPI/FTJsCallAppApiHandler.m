//
//  FTJsCallAppApiHandler.m
//  FaceTalk
//
//  Created by scw on 2021/8/27.
//

#import "FTJsCallAppApiHandler.h"
#import "FaceTalk-Swift.h"

@implementation FTJsCallAppApiHandler
- (void)handler:(NSDictionary *)data context:(PSDContext *)context callback:(PSDJsApiResponseCallbackBlock)callback {
    [super handler:data context:context callback:callback];
    [FTRouter HandleJSApis:data context:context callBack:callback];
}

@end
