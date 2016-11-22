//
//  SZBMQuestionInfo.h
//  trainingsystem
//
//  Created by xiaoquan jiang on 17/11/2016.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SZBMQuestionOptionInfo;
@interface SZBMQuestionInfo : NSObject

@property (nonatomic, copy) NSString *examId;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *examQuestion;
@property (nonatomic, strong) NSArray  *selects;
@property (nonatomic, copy) NSString *selfOptinos;
@property (nonatomic, copy) NSString *type;

@end


@interface SZBMQuestionOptionInfo: NSObject

@property (nonatomic, copy) NSString *opId;
@property (nonatomic, copy) NSString *option;
@property (nonatomic, assign) BOOL selected;


@end
