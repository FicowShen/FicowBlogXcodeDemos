//
//  CNViewController.m
//  CN-APP
//
//  Created by Ficow on 2023/3/25.
//

#import "CNViewController.h"

@interface CNViewController ()

@end

@implementation CNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef FICOW_ON
    NSLog(@"FICOW_ON is enabled in CN-APP ObjC file");
#endif
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
