//
//  SZBMExamItemSelectionView.m
//  alertExten
//
//  Created by xiaoquan jiang on 19/11/2016.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMExamItemSelectionView.h"

#import <CoreText/CoreText.h>
#import "objc/runtime.h"

@interface SZBMExamItemSelectionView()

@property (nonatomic, strong) SZBMQuestionInfo *selectionInfo;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) NSAttributedString *qattributeString;

@end


@implementation SZBMExamItemSelectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

/**
 初始化试题数据
 
 @param info info description
 */
- (void)initSelectionInfo:(SZBMQuestionInfo*)info
{
    if ( self.selectionInfo == info ) {
        return;
    }
    
    self.selectionInfo = info;
    
    // init ui
    [self _initUI];
}


/**
 初始化UI
 */
- (void)_initUI
{
    // init item selections label
    [self _setLabelAttribute];
  
    // prevent black background when over write - (void)drawRect:(CGRect)rect
    self.opaque = NO;
    
}

- (void)_setLabelAttribute
{
    self.qattributeString = [[self class] _getAttributeFromdata:self.selectionInfo];
    self.bodyLabel.attributedText = self.qattributeString;
}

/**
 计算view需要的size
 
 @param frameWidth 初始化本view 的 宽度
 @param info      数据
 
 @return 返回计算后的size
 */
+ (CGSize)getViewSize:(float)frameWidth withData:(SZBMQuestionInfo*)info
{
    NSAttributedString* attributeString = [[self class] _getAttributeFromdata:info];
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(frameWidth - SZBMExamItemSelectionView_init_x*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil];
    CGSize size = rect.size;
    size.height += SZBMExamItemSelectionView_init_y*2;
    size.height = ceil(size.height);
    return size;
}

/**
 配置 NSAttributedString

 */
+ (NSAttributedString*)_getAttributeFromdata:(SZBMQuestionInfo*)info
{
    
    if ( !info ) {
        return nil;
    }
    
    // NSTextTab *listTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentCenter
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    CGSize tipSpacesize = CGSizeZero;
    // 添加 单，多 选tips // 添加 试题 题目
    {
        NSString *selectString = [info.type integerValue] == 0?@"单选":@"多选";
        NSString *fullyquestionString = [NSString stringWithFormat:@"%@ %@\n",selectString,info.examQuestion];
        
        tipSpacesize = [[self class] _getSizeFromAttribute:@{NSFontAttributeName:SZBMExamItemSelectionView_font} body:selectString recomondSize:CGSizeZero];
        
        NSMutableAttributedString *addindAttributedString = [[NSMutableAttributedString alloc] initWithString:fullyquestionString  ];
        
        [addindAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                NSFontAttributeName:SZBMExamItemSelectionView_tipsfont,
                                                @"roundColor":[UIColor lightGrayColor]}
                                        range:NSMakeRange(0, [selectString length])];
        
        [addindAttributedString addAttribute:NSParagraphStyleAttributeName value:[[self class] _getCommonParagraphStyleWithHeadIndent:tipSpacesize.width] range:NSMakeRange(0, [addindAttributedString length])];
        
        [addindAttributedString addAttribute:NSFontAttributeName value:SZBMExamItemSelectionView_font range:NSMakeRange(selectString.length, addindAttributedString.length - selectString.length)];
        
        [attributedString appendAttributedString:addindAttributedString];
    }
  
    NSInteger nindex = 0;
    for ( SZBMQuestionOptionInfo *opInfo in info.selects )
    {
        NSRange range = {attributedString.length,0};
        NSMutableAttributedString *addindAttributedString = [NSMutableAttributedString new];
        
        SelectionNSTextAttachment *textAttachment = [[SelectionNSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:opInfo.selected?@"btn_exam_sel":@"btn_exam_nor"];
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [addindAttributedString appendAttributedString:attrStringWithImage];
        
        NSString *spaceStr = @" ";
        [addindAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:spaceStr]];
        CGSize spacesize = [spaceStr sizeWithAttributes:@{NSFontAttributeName:SZBMExamItemSelectionView_font}];
        
        // add text string sligent
        [addindAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:opInfo.option]];
        
        NSMutableParagraphStyle *paragaphy = [[self class] _getCommonParagraphStyleWithHeadIndent:textAttachment.image.size.width + spacesize.width + tipSpacesize.width];
        paragaphy.firstLineHeadIndent = tipSpacesize.width;
        
        [addindAttributedString addAttributes:@{NSFontAttributeName:SZBMExamItemSelectionView_font,
                                                NSParagraphStyleAttributeName:paragaphy,
                                                @"optionItem":opInfo}
                                        range:NSMakeRange(0, [addindAttributedString length])];
        
        
        // add to total attribute
        [attributedString appendAttributedString:addindAttributedString];
        range.length = addindAttributedString.length;
        
        // add enter line
        if ( nindex < [info.selects count] )
        {
            NSMutableAttributedString *addindAttributedString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:SZBMExamItemSelectionView_font}];
            [attributedString appendAttributedString:addindAttributedString];
        }
  
        nindex++;
        
    }
 
    return attributedString;
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // TODO
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    //CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f,self.bounds.size.height),1.0f,-1.0f));
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.qattributeString);
    CGPathRef path = CGPathCreateWithRect(UIEdgeInsetsInsetRect(self.bounds,UIEdgeInsetsMake(SZBMExamItemSelectionView_init_y, SZBMExamItemSelectionView_init_x, SZBMExamItemSelectionView_init_y, SZBMExamItemSelectionView_init_x)),NULL);
    CFTypeRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray* lines=(__bridge NSArray*)CTFrameGetLines(frame);
    CGPoint* origins=(CGPoint*)alloca(sizeof(CGPoint)*lines.count);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    __block SZBMQuestionOptionInfo *opInfo = nil;
    __block CGRect reconigzerRt = CGRectZero;
    
    [lines enumerateObjectsUsingBlock:^(id line, NSUInteger lineIndex, BOOL* stop)
     {
         NSArray *lineArr = (__bridge NSArray*)CTLineGetGlyphRuns((__bridge CTLineRef)(line));
         [lineArr enumerateObjectsUsingBlock:^(id run, NSUInteger index, BOOL* stop)
          {
              NSDictionary* attributes=(__bridge NSDictionary*)CTRunGetAttributes((__bridge CTRunRef)run);
              
              if ( attributes[@"roundColor"] )
              {
                  CGRect bounds;
                  CGFloat ascent,descent;
                  bounds.size.width = CTRunGetTypographicBounds((__bridge CTRunRef)run, CFRangeMake(0,0), &ascent, &descent, NULL);
                  
                  float f_font_height = ascent+descent + SZBMExamItemSelectionView_init_y *2;
                  float f_zhuanzhi_y = rect.size.height - origins[lineIndex].y - (ascent+descent) - SZBMExamItemSelectionView_init_y ;
                  bounds = CGRectMake( origins[lineIndex].x+CTLineGetOffsetForStringIndex((__bridge CTLineRef)(line), CTRunGetStringRange((__bridge CTRunRef)run).location, NULL) + SZBMExamItemSelectionView_init_x,
                                      f_zhuanzhi_y,
                                      bounds.size.width,
                                      f_font_height);
                  
                  float f_pading_x = 2.0f;
                  bounds.origin.x -= f_pading_x;
                  bounds.size.width += f_pading_x*2;
                  
                  UIColor *color = attributes[@"roundColor"];
                  UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:3.0f];
                  CGContextSetFillColorWithColor(context, color.CGColor);
                  [roundedPath fill];
                  
              }
              else if ( attributes[@"optionItem"] )
              {
                 // NSLog(@"_index:%lu__counting:%lu == %ld",lineIndex,index,[lineArr count]);
                  BOOL b_exist = NO;
                  if ( opInfo != attributes[@"optionItem"] || (lineIndex == [lines count] -1 && index == [lineArr count] - 2))
                  {
                      if ( opInfo != nil )
                      {
                          // already has previor data
                          SZBMQuestionOptionInfoTouchEx *exInfo = [[self class] _reconigzerInfo:opInfo];
                          float f_padding = 3.0f;
                          reconigzerRt.origin.y -= f_padding;
                          reconigzerRt.size.height += f_padding*2;
                          exInfo.reconigzerArea = reconigzerRt;
                          exInfo.bAlreadySet = YES;
                          b_exist = exInfo.bAlreadySet;
                      }
                      reconigzerRt = CGRectZero;
                      opInfo = attributes[@"optionItem"];
                  }
                  
                  if ( !b_exist )
                  {
                      CGRect bounds;
                      CGFloat ascent,descent;
                      bounds.size.width = CTRunGetTypographicBounds((__bridge CTRunRef)run, CFRangeMake(0,0), &ascent, &descent, NULL);
                      
                      float f_font_height = ascent+descent;
                      float f_zhuanzhi_y = rect.size.height - origins[lineIndex].y - f_font_height - descent - SZBMExamItemSelectionView_init_y ;
                      
                      if ( reconigzerRt.origin.x == 0.0f ) {
                          reconigzerRt.origin.x = origins[lineIndex].x;
                      }
                      reconigzerRt.origin.x = MIN(reconigzerRt.origin.x, origins[lineIndex].x);
                      
                      if ( reconigzerRt.origin.y == 0.0f ) {
                          reconigzerRt.origin.y = f_zhuanzhi_y;
                      }
                      reconigzerRt.origin.y = MIN(reconigzerRt.origin.y, f_zhuanzhi_y);
                      reconigzerRt.size.width = rect.size.width - SZBMExamItemSelectionView_init_x*2;
                      reconigzerRt.size.height = MAX(reconigzerRt.size.height, f_zhuanzhi_y) - reconigzerRt.origin.y + f_font_height;
                  }
              }
          }];
     }];
    
    
    CFBridgingRelease(frame);
    CFBridgingRelease(frameSetter);
    
    // 画按下效果
    for ( SZBMQuestionOptionInfo *opInfo in self.selectionInfo.selects )
    {
        SZBMQuestionOptionInfoTouchEx *exInfo = [[self class] _reconigzerInfo:opInfo];
        CGRect rt = exInfo.reconigzerArea;
        
        UIColor *color = exInfo.state == enSZBMQOInfoTState_Nomal?SZBMExamItemSelectionView_normalColor:SZBMExamItemSelectionView_selectedColor;
        UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(rt, 0.0f, 0.0f) cornerRadius:1.0f];
        CGContextSetFillColorWithColor(context, color.CGColor);
        [roundedPath fill];
        
    }
}


/**
 get size from given string

 @param attributes attributes description
 @param body       body description
 @param reSize     reSize description

 @return return value description
 */
+ (CGSize)_getSizeFromAttribute:(NSDictionary*)attributes body:(NSString*)body recomondSize:(CGSize)reSize
{
    if ( CGSizeEqualToSize(CGSizeZero,reSize) ) {
        
        return [body sizeWithAttributes:attributes];
    }
    else
    {
        CGRect rect = [body boundingRectWithSize:reSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        return rect.size;
    }
 
}


/**
 配置 NSAttributedString 的段落区间

 @param fheadIndent 距左边的边距

 @return NSMutableParagraphStyle
 */
+ (NSMutableParagraphStyle*)_getCommonParagraphStyleWithHeadIndent:(float)fheadIndent
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    float flineLineHeight = SZBMExamItemSelectionView_font.lineHeight + 1.0f;
    
    //set the line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.minimumLineHeight = flineLineHeight;
    paragraphStyle.maximumLineHeight = flineLineHeight;
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.headIndent = fheadIndent;
    paragraphStyle.tailIndent = 0;
    
    // 段落间间距
    paragraphStyle.paragraphSpacing = 15.0f;
    
    return paragraphStyle;
}

- (UILabel*)bodyLabel
{
    if ( !_bodyLabel )
    {
        float f_init_x = SZBMExamItemSelectionView_init_x;
        float f_init_y = SZBMExamItemSelectionView_init_y;
        
        // init question Lablel
        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(f_init_x, f_init_y, CGRectGetWidth(self.bounds)-f_init_x*2, CGRectGetHeight(self.bounds)-f_init_y*2)];
        
        _bodyLabel.textAlignment = NSTextAlignmentLeft;
        _bodyLabel.textColor = [UIColor grayColor];
        _bodyLabel.backgroundColor = SZBMExamItemSelectionView_normalColor;
        _bodyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bodyLabel.numberOfLines = 0;
        
        [self addSubview:_bodyLabel];
    }
    
    return _bodyLabel;
}

static char SZBMQuestionOptionInfoTouchEx_reconigzerInfoKey;
+ (SZBMQuestionOptionInfoTouchEx *)_reconigzerInfo:(SZBMQuestionOptionInfo*)optionInfo
{
    SZBMQuestionOptionInfoTouchEx *_rInfo = objc_getAssociatedObject(optionInfo, &SZBMQuestionOptionInfoTouchEx_reconigzerInfoKey);
    if (!_rInfo)
    {
        _rInfo = [[SZBMQuestionOptionInfoTouchEx alloc] init];
        objc_setAssociatedObject(optionInfo, &SZBMQuestionOptionInfoTouchEx_reconigzerInfoKey, _rInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _rInfo;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)_detectTouchIfInSeleectArea:(UITouch *)touch
{
    BOOL b_isIN = NO;
    CGPoint point = [touch locationInView:self];
    for ( SZBMQuestionOptionInfo *opInfo in self.selectionInfo.selects )
    {
        SZBMQuestionOptionInfoTouchEx *exInfo = [[self class] _reconigzerInfo:opInfo];
        if ( CGRectContainsPoint(exInfo.reconigzerArea,point) ) {
            b_isIN = YES;
            break;
        }
    }
    return b_isIN;
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if ( [self _detectTouchIfInSeleectArea:touch] ) {
        
        CGPoint point = [touch locationInView:self];
        for ( SZBMQuestionOptionInfo *opInfo in self.selectionInfo.selects )
        {
            SZBMQuestionOptionInfoTouchEx *exInfo = [[self class] _reconigzerInfo:opInfo];
            CGRect rt = exInfo.reconigzerArea;
            exInfo.state = CGRectContainsPoint(rt,point)?enSZBMQOInfoTState_TouchDown:enSZBMQOInfoTState_Nomal;
        }
        [self setNeedsDisplay];
        
        return YES;
    }
    return NO;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    return [self beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if ( [self _detectTouchIfInSeleectArea:touch] ) {
        
        CGPoint point = [touch locationInView:self];
        for ( SZBMQuestionOptionInfo *opInfo in self.selectionInfo.selects )
        {
            SZBMQuestionOptionInfoTouchEx *exInfo = [[self class] _reconigzerInfo:opInfo];
            CGRect rt = exInfo.reconigzerArea;
            
            // 试题类型：0 单选 1 多选
            if ( [self.selectionInfo.type integerValue] == 1) {
                exInfo.isSelected = CGRectContainsPoint(rt,point)?!exInfo.isSelected:exInfo.isSelected;
            }
            else
            {
                exInfo.isSelected = CGRectContainsPoint(rt,point)?!exInfo.isSelected:NO;
            }
            exInfo.state = enSZBMQOInfoTState_Nomal;
            opInfo.selected = exInfo.isSelected;
        }
        
        [self _setLabelAttribute];
        [self setNeedsDisplay];
    }
}

@end


@implementation SelectionNSTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    CGRect bounds;
    bounds.origin = CGPointMake(0, -3);
    bounds.size = self.image.size; 
    return bounds;
}

@end

@implementation SZBMQuestionOptionInfoTouchEx
@end


