//
//  SZBMExamItemSelectionView.h
//  alertExten
//
//  Created by xiaoquan jiang on 19/11/2016.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SZBMQuestionInfo.h"


#define SZBMExamItemSelectionView_init_x 3.0f
#define SZBMExamItemSelectionView_init_y 3.0f
#define SZBMExamItemSelectionView_font [UIFont systemFontOfSize:18.0f]
#define SZBMExamItemSelectionView_tipsfont [UIFont systemFontOfSize:15.0f]

#define SZBMExamItemSelectionView_normalColor [UIColor clearColor]
#define SZBMExamItemSelectionView_selectedColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]

@class SelectionNSTextAttachment;
@interface SZBMExamItemSelectionView : UIControl


/**
 初始化试题数据

 @param info info description
 */
- (void)initSelectionInfo:(SZBMQuestionInfo*)info;

 


/**
 计算view需要的size
 
 @param frameWidth 初始化本view 的 宽度
 @param info      数据
 
 @return 返回计算后的size
 */
+ (CGSize)getViewSize:(float)frameWidth withData:(SZBMQuestionInfo*)info;


@end



@interface SelectionNSTextAttachment : NSTextAttachment
@end


typedef NS_ENUM(NSInteger,enSZBMQuestionOptionInfoTouchState)
{
    enSZBMQOInfoTState_Nomal = 0,
    enSZBMQOInfoTState_TouchDown,
    enSZBMQOInfoTState_ALL
};

@interface SZBMQuestionOptionInfoTouchEx : NSObject

@property (nonatomic, assign) CGRect reconigzerArea;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) enSZBMQuestionOptionInfoTouchState state;
@property (nonatomic, assign) BOOL bAlreadySet;



@end

