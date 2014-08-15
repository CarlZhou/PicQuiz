//
//  iSpyGameViewController.h
//  PhotoSmart
//
//  Created by Carl Zhou on 2014-08-14.
//  Copyright (c) 2014 Majid Veyseh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *gameTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameImageView;
@property (strong, nonatomic) IBOutlet UIView *lettersViewContainer;
@property (strong, nonatomic) IBOutlet UIView *answerViewContainer;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *answerCollectionView;

//@property (strong, nonatomic) ISpyGameObject *gameObject;

@end
