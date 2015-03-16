//
//  ViewController.m
//  PBPopupExample
//
//  Created by Purple on 2015. 3. 16..
//  Copyright (c) 2015년 Purple. All rights reserved.
//

#import "ViewController.h"
#import "PBPopup.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }


    cell.textLabel.text = [NSString stringWithFormat:@"%d",arc4random_uniform(100)];




    return cell;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonClicked:(id)sender {

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    tableView.delegate = self;
    tableView.dataSource = self;

    PBPopup* popup = [[PBPopup alloc] initWithParentViewController:self contentView:tableView];

    [popup show];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
