//
//  DisplayViewController.m
//  ComicMe
//
//  Created by Stefan Verveniotis on 2016-11-28.
//  Copyright © 2016 Midterm Team. All rights reserved.
//

#import "DisplayViewController.h"
#import "CanvasViewController.h"
#import "StoryManager.h"

@interface DisplayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *displayViewImageView;
@property (weak, nonatomic) StoryManager * sm;
@property (weak, nonatomic) IBOutlet UIView *displayImageBackground;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger pageCounter;
@property (nonatomic) NSInteger pageCount;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCounter = 0;
    // Do any additional setup after loading the view.
    self.sm = [StoryManager sharedManager];
    if (self.hideEditButton) {
        self.navigationItem.rightBarButtonItems = nil;
        self.hideEditButton = NO;
    }
    //Setup the story view
    [self buildImage];
    self.displayViewImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.displayViewImageView.layer.borderWidth = 4;
    self.pageCount = self.sm.currentStory.images.count;
    self.pageControl.numberOfPages = self.pageCount;
}

- (void) buildImage {
    self.displayViewImageView.image = [self.sm getUIImageForStory:self.sm.currentStory page:self.pageCounter];
    
    NSOrderedSet * layers = self.sm.currentImage.layers;
    for (Layer * layer in layers) {
        UIImage * layerImage = [self.sm getUIImageForLayer:layer];
        UIImageView * layerImageView = [[UIImageView alloc] initWithImage:layerImage];
        layerImageView.frame = [self.sm createCGRectForLayer:layer];
        layerImageView.transform = [self.sm getTransformForLayer:layer];
        [self.displayViewImageView addSubview:layerImageView];
    }
}

- (IBAction)comicTapped:(UITapGestureRecognizer *)sender {
    self.pageCounter = (self.pageCounter + 1) % self.pageCount;
    self.sm.currentImage = self.sm.currentStory.images[self.pageCounter];
    [UIView animateWithDuration:0.3 animations:^{
        self.displayImageBackground.frame = CGRectOffset(self.displayImageBackground.frame, -500, 0);
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.33 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self clearCanvas];
        [self buildImage];
        self.displayImageBackground.frame = CGRectOffset(self.displayImageBackground.frame, +1000, 0);
        self.pageControl.currentPage = self.pageCounter;
        [UIView animateWithDuration:0.3 animations:^{
            self.displayImageBackground.frame = CGRectOffset(self.displayImageBackground.frame, -500, 0);
        }];
    });
}

- (void) clearCanvas {
    for (UIImageView * subView in self.displayViewImageView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        CanvasViewController * cVC = segue.destinationViewController;
        cVC.hidePreviewButton = YES;
    }
}


@end
