//
//  ViewController.m
//  alertExten
//
//  Created by xiaoquan jiang on 17/11/2016.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "ViewController.h"

#import "SZBMExamItemSelectionView.h"


#import "SZBMQuestionInfo.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) SZBMQuestionInfo *dataInfo;
@property (strong, nonatomic) SZBMExamItemSelectionView *seview;


@property (weak, nonatomic) IBOutlet SZBMExamItemSelectionView *xibView;
@property (strong, nonatomic) SZBMQuestionInfo *xibdataInfo;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self _test];
    
}

- (void)_test
{
//    Conference *pconnteion = [[Conference alloc] init];
//    
//    NSLog(@"___:%@",pconnteion);
    
    NSLog(@"self.selectBtn:%@ \n %@",self.selectBtn.titleLabel,self.selectBtn.imageView);
    
    
    _dataInfo = [[SZBMQuestionInfo alloc] init];
    _dataInfo.examId = @"1";
    _dataInfo.answer = @"";
    _dataInfo.examQuestion = @"国家主席习近平抵达利马，出席亚太经合组织第二十四次领导人非正式会议并对秘鲁共和国进行国事访问?????";
    
    NSMutableArray *selects = [NSMutableArray new];
    NSString* qtring = @"A:新华社利马11月18日电 当地时间18日，国家主席习近平抵达利马，出席亚太经合组织第二十四次领导人非正式会议并对秘鲁共和国进行国事访问";
    for ( int i = 0; i < 3; i++ ) {
        
       SZBMQuestionOptionInfo *dataInfo = [[SZBMQuestionOptionInfo alloc] init];
        dataInfo.opId = @"A";
        dataInfo.option =  [qtring substringToIndex:random()%qtring.length];
        [selects addObject:dataInfo];
    }
    
    _dataInfo.selects = selects;
    _dataInfo.selfOptinos = @"";
    _dataInfo.type = @"0";
    
    
    
    float f_viewwidth = 300.0f;
    CGSize size = [SZBMExamItemSelectionView getViewSize:f_viewwidth withData:_dataInfo];
    
    
    _seview = [[SZBMExamItemSelectionView alloc] initWithFrame:CGRectMake( (CGRectGetWidth(self.view.bounds) - f_viewwidth)/2.0f, 50, f_viewwidth, size.height)];
    
    [_seview initSelectionInfo:_dataInfo];
    
    [_seview addTarget:self action:@selector(onSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //seview.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_seview];
    
    
//    
//    _xibdataInfo = [[SZBMQuestionOptionInfo alloc] init];
//    _xibdataInfo.opId = @"B";
//    _xibdataInfo.option = @"B:新华社利马11月18日电 当地时间18日，国家主席习近平抵达利马，出席亚太经合组织第二十四次领导人非正式会议并对秘鲁共和国进行国事访问";
    
   // [self.xibView initSelectionInfo:_xibdataInfo];
   // [self.xibView addTarget:self action:@selector(onXibSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onSectionClick:(id)sender
{
    NSLog(@"I clicked!");
    

}

- (void)onXibSectionClick:(id)sender
{
    NSLog(@"I clicked!");
    
  
}




@end
