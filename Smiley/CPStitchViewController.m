//
//  CPStitchViewController.m
//  Smiley
//
//  Created by wangyw on 3/7/14.
//  Copyright (c) 2014 codingpotato. All rights reserved.
//

#import "CPStitchViewController.h"

#import "CPEditViewController.h"
#import "CPFace.h"
#import "CPFacesController.h"
#import "CPStitchCell.h"

@interface CPStitchViewController ()

@property (nonatomic) NSInteger selectedIndex;

@end

@implementation CPStitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (CPFace *face in [CPFacesController defaultController].selectedFaces) {
        face.userBounds = CGRectZero;
    }
    self.selectedIndex = -1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.selectedIndex != -1) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]]];
        self.selectedIndex = -1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CPEditViewControllerSegue"]) {
        CPEditViewController *editViewController = (CPEditViewController *)segue.destinationViewController;
        editViewController.face = [[CPFacesController defaultController].selectedFaces objectAtIndex:self.selectedIndex];
    }
}

- (IBAction)actionBarButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save Photo", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (CGRect)frameOfSelectedCell {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    return [self.view convertRect:cell.frame fromView:self.collectionView];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate implement

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [CPFacesController defaultController].selectedFaces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CPStitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPStitchCell" forIndexPath:indexPath];
    CPFace *face = [[CPFacesController defaultController].selectedFaces objectAtIndex:indexPath.row];
    CGRect bounds = CGRectEqualToRect(face.userBounds, CGRectZero) ? face.bounds : face.userBounds;
    CGImageRef faceImage = CGImageCreateWithImageInRect(face.asset.defaultRepresentation.fullScreenImage, bounds);
    cell.imageView.image = [UIImage imageWithCGImage:faceImage scale:bounds.size.width / self.widthOfStitchCell orientation:UIImageOrientationUp];
    CGImageRelease(faceImage);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.widthOfStitchCell;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"CPEditViewControllerSegue" sender:nil];
}

- (CGFloat)widthOfStitchCell {
    return self.collectionView.bounds.size.width / self.rowsOfStitchCell;
}

- (NSUInteger)rowsOfStitchCell {
    float rows = sqrtf([CPFacesController defaultController].selectedFaces.count);
    return (NSUInteger)rows == rows ? rows : rows + 1;
}

#pragma mark - UIActionSheetDelegate implement

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [[CPFacesController defaultController] saveStitchedImage];
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout implement

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

@end
