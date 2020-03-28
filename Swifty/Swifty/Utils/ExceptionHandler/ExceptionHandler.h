//
//  ExceptionHandler.h
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionHandler : NSObject

+ (BOOL)catchExceptionWithTryBlock:(__attribute__((noescape)) void(^ _Nonnull)(void))tryBlock
                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;
@end

NS_ASSUME_NONNULL_END

