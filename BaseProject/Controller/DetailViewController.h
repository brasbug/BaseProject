//
//  DetailViewController.h
//  BaseProject
//
//  Created by Jack on 16/2/1.
//  Copyright © 2016年 宇之楓鷙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

