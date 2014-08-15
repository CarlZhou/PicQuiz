//
//  iSpyGameViewController.m
//  PhotoSmart
//
//  Created by Carl Zhou on 2014-08-14.
//  Copyright (c) 2014 Majid Veyseh. All rights reserved.
//

#import "GameViewController.h"
//#import "UIImageView+WebCache.h"

@interface GameViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSString *answer;
}

@property (nonatomic, strong) NSMutableArray *lettersData;
@property (nonatomic, strong) NSMutableArray *answerLettersData;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, strong) NSMutableArray *answerArray;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (self.gameObject)
//    {
//        self.gameImageView.image = self.gameObject.gameImage;
//        [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:self.gameObject.gameImageLink]];
//        self.gameTitleLabel.text = self.gameObject.gameTitle;
//        answer = self.gameObject.gameAnswer;
//    }
    
    [self setupLettersCollectionView];
    [self initData];
}

- (void)initData
{
    self.lettersData = [NSMutableArray array];
    self.answerLettersData = [NSMutableArray array];
    self.selectedIndexPaths = [NSMutableArray array];
    
//    [self.lettersData addObjectsFromArray:@[@"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A", @"A"]];
    [self initLettersData];
    
    [self.collectionView reloadData];
}

- (void)initLettersData
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [answer length]; i++) {
        NSString *ch = [answer substringWithRange:NSMakeRange(i, 1)];
        [array addObject:[ch uppercaseString]];
        [self.answerLettersData addObject:@""];
        [self.selectedIndexPaths addObject:@""];
    }
    [self.lettersData addObjectsFromArray:array];
    
    NSUInteger len = 14 - array.count;
    for (int i=0; i<len; i++)
    {
        [self.lettersData addObject:[self randomStringWithLength:1]];
    }
    
    [self shuffle:self.lettersData];
}

#pragma mark - CollectionView

- (void)setupLettersCollectionView
{
    [self createCollectionView];
}

- (void)createCollectionView
{
    if (self.collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setItemSize:CGSizeMake(35, 35)];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(22, 15, 280, 75) collectionViewLayout:flowLayout];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.lettersViewContainer addSubview:self.collectionView];
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self.collectionView reloadData];
    }
    if (self.answerCollectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setItemSize:CGSizeMake(35, 35)];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        
        NSUInteger answerArrayCount = answer.length;
        
        float xPad = 320.0f/2 - (35.0f * answerArrayCount + 5.0f * (answerArrayCount - 1))/2;
        
        self.answerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(xPad, 0, 320, 40) collectionViewLayout:flowLayout];
        
        self.answerCollectionView.dataSource = self;
        self.answerCollectionView.delegate = self;
        self.answerCollectionView.backgroundColor = [UIColor clearColor];
        [self.answerViewContainer addSubview:self.answerCollectionView];
        
        [self.answerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AnswerCell"];
        [self.answerCollectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view == self.answerCollectionView)
    {
        return self.answerLettersData.count;
    }
    return self.lettersData.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (collectionView == self.collectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswerCell" forIndexPath:indexPath];
    }
    
    for (id subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    // Filling letters
    NSString *item;
    
    if (collectionView == self.collectionView)
    {
        item = self.lettersData[indexPath.row];
    }
    else
    {
        item = self.answerLettersData[indexPath.row];
    }
    
    UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    filterLabel.text = item;
    filterLabel.textColor = [UIColor blackColor];
    filterLabel.font = [UIFont fontWithName:@"Avenir" size:25.0f];
    filterLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:filterLabel];
    
    cell.backgroundColor = [UIColor redColor];
    
    cell.layer.cornerRadius = 5.0f;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        NSUInteger currentEmptyAnswerIndex = [self getCurrentEmptyAnswerIndex];
        if (currentEmptyAnswerIndex != -1)
        {
            NSString *item = self.lettersData[indexPath.row];
            [self.answerLettersData replaceObjectAtIndex:currentEmptyAnswerIndex withObject:item];
            [self.selectedIndexPaths replaceObjectAtIndex:currentEmptyAnswerIndex withObject:indexPath];
            [self.answerCollectionView reloadData];
            cell.hidden = YES;
            
            if ([self getCurrentEmptyAnswerIndex] == -1) {
                [self checkGame];
            }
        }
    }
    else
    {
        if ([self.selectedIndexPaths[indexPath.row] isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *backIndexPath = self.selectedIndexPaths[indexPath.row];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:backIndexPath];
            cell.hidden = NO;
            [self.answerLettersData replaceObjectAtIndex:indexPath.row withObject:@""];
            [self.selectedIndexPaths replaceObjectAtIndex:indexPath.row withObject:@""];
            [self.answerCollectionView reloadData];
        }
    }
}

#pragma mark - Answer
- (void)checkGame
{
    if ([[self.answerLettersData componentsJoinedByString:@""] isEqualToString:[answer uppercaseString]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString  stringWithFormat:@"Oh My God, you're correct!"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString  stringWithFormat:@"Oh shoot!"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (NSUInteger)getCurrentEmptyAnswerIndex
{
    __block NSUInteger result = -1;
    [self.answerLettersData enumerateObjectsUsingBlock:^(NSString *item, NSUInteger index, BOOL *stop){
        if ([item isEqualToString:@""])
        {
            result = index;
            *stop = YES;
        }
    }];
    return result;
}

NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (NSString *)randomStringWithLength:(int)len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length]) % [letters length]]];
    }
    
    return randomString;
}

- (void)shuffle:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
