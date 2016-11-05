//
//  ViewController.m
//  KeyBoardDemo
//
//  Created by lwx on 2016/11/5.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import "ViewController.h"
#import "ChatKeyBoard.h"

#import "FaceSourceManager.h"

@interface ViewController ()<ChatKeyBoardDelegate,ChatKeyBoardDataSource> {
    UIButton *_openBtn;
}
/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property (nonatomic, strong) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width - 10, 200)];
    textView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"打开键盘" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.selected = NO;
    _openBtn = button;
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    
    self.chatKeyBoard.placeHolder = @"请输入消息。";
    [self.view addSubview:self.chatKeyBoard];


}

- (void)buttonClick:(UIButton *)sender {
    
    if (!sender.selected) {
        [self.chatKeyBoard keyboardUpforComment];
        [sender setTitle:@"关闭键盘" forState:UIControlStateNormal];
    }else{
        [self.chatKeyBoard keyboardDownForComment];
        [sender setTitle:@"打开键盘" forState:UIControlStateNormal];
    }
    
    sender.selected = !sender.selected;
    
    
}


#pragma mark - 自定义键盘的代理方法
#pragma mark - 功能按钮
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems {

    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];

    return @[item1, item2, item3];
    
}


#pragma mark - 面板
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems {
    
    

//        kBarItemVoice,
//        kBarItemFace,
//        kBarItemMore,
//        kBarItemSwitchBar

    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];

}

#pragma mark - 自定义表情
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

/**
 *  输入状态
 */
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView {
    [self textViewAddText:@"开始输入文本"];
}


- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView {
//    [self textViewAddText:@""];
    NSLog(@"正在输出文本%@",textView.text);
}

- (void)chatKeyBoardSendText:(NSString *)text {
    [self textViewAddText:text];
}


#pragma mark -- 语音状态
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard
{
     [self textViewAddText: @"正在录音"];
}
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard
{
    [self textViewAddText: @"已经取消录音"];

}
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard
{
    [self textViewAddText: @"已经完成录音"];
}

- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard
{
    [self textViewAddText: @"将要取消录音"];
}
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard
{
    [self textViewAddText: @"继续录音"];
}


- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index {
    NSLog(@"你点击了第%ld个功能",index);
}


- (void)textViewAddText:(NSString *)text {
    NSMutableString *oldText = [NSMutableString stringWithString:self.textView.text];
    [oldText appendString:@"\n"];
    [oldText appendString:text];
    
    
    self.textView.text = oldText;
    
    CGFloat offsetY = self.textView.contentSize.height - self.textView.bounds.size.height;
    
    if (offsetY > 0) {
        [self.textView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
