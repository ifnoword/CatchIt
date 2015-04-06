//
//  GameViewController.m
//  HW5
//
//  Created by MEI C on 3/13/14.
//  Copyright (c) 2014 MEI C. All rights reserved.
//

#import "GameViewController.h"
#import "Arrow.h"

@interface GameViewController () <UICollisionBehaviorDelegate>
//@property (weak, nonatomic) IBOutlet UITextView *guidView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartBtn;
@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *boardView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
//@property (strong, nonatomic) UISwipeGestureRecognizer *swiper;
@property (strong, nonatomic) NSMutableArray *playingArrows;


@property (weak, nonatomic) NSTimer *addTimer;
@property (weak, nonatomic) NSTimer *speedTimer;

@property (nonatomic) NSInteger score;

@end

@implementation GameViewController
static const NSArray *ARROW;


/*-(UIGestureRecognizer *) swiper{
    if (!_swiper) {
        _swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
        _swiper.
        
    }
}*/
-(NSMutableArray *) playingArrows{
    if (!_playingArrows) {
        _playingArrows = [[NSMutableArray alloc] init];
    }
    return _playingArrows;
}
-(UIDynamicAnimator *) animator {
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.boardView];
    }
    return _animator;
}
-(UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.2;
        [self.animator addBehavior:_gravity];

    }
    return _gravity;
}
-(UICollisionBehavior *) collider{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
        _collider.collisionDelegate = self;
        [self.animator addBehavior:_collider];
    }
    return _collider;
}
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    if (p.y > self.boardView.bounds.size.height-5) {
        UIImageView *view = (UIImageView *)item;
        [self.gravity removeItem:item];
        [self.collider removeItem:item];
        [view removeFromSuperview];
        int i=0;
        while (i< self.playingArrows.count) {
            Arrow *arrow = [self.playingArrows objectAtIndex:i];
            if (arrow.view == view) {
                NSLog(@"Playing Array delete %@",arrow.direction);
                [self.playingArrows removeObjectAtIndex:i];
                break;
                
            }
            i++;
        }
        int len = self.lifeLabel.text.length;
        if (len == 2) {
            [self.addTimer invalidate];
            [self.speedTimer invalidate];
        }
        if(len>0){
            self.lifeLabel.text = [self.lifeLabel.text substringToIndex:len-2];
            if (self.lifeLabel.text.length == 0) {
                [self flashWithHint:@"Game Over"];
                self.restartBtn.enabled = YES;
            }
        }
        NSLog(@"%d", self.lifeLabel.text.length);
        
    }

}
-(void)flashWithHint:(NSString *) hint{
    [self.hintLabel setAlpha:0.f];
    [UIView animateWithDuration:2.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.hintLabel.text = hint;
        [self.hintLabel setAlpha:1.f];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2.f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{[self.hintLabel setAlpha:0.f];} completion:nil];
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hintLabel.text = @"Tap PLAY";
    ARROW = @[@"left", @"right", @"up", @"down"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restartPressed:(id)sender {
    [self flashWithHint:@"Swipe to Eliminate an Arrow"];
    [self.restartBtn setTitle:@"REPLAY" forState:UIControlStateNormal];
    self.restartBtn.enabled = NO;
    self.addTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(addRandomArrow) userInfo:nil repeats:YES];
    self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(speedUp) userInfo:nil repeats:YES];
    self.lifeLabel.text = @"🍀🍀🍀";
    self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    self.gravity.magnitude = 0.2;
    
}


    //[self deleteArrowWithDirection:@"right"];

-(void)deleteArrowWithDirection: (NSString *)dstr{
    int i = 0;
    while (i<self.playingArrows.count) {
        Arrow *arrow = [self.playingArrows objectAtIndex:i];
        if ([arrow.direction isEqualToString:dstr]) {
            [self.gravity removeItem:arrow.view];
            [self.collider removeItem:arrow.view];
            [arrow.view removeFromSuperview];
            [self.playingArrows removeObjectAtIndex:i];
            self.score+=10;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
            break;
        }
        i++;
    }

}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    NSString *dString;
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        dString = @"down";
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        dString = @"left";
    }
    else if (sender.direction ==UISwipeGestureRecognizerDirectionRight) {
        dString = @"right";
    }
    else{
        dString = @"up";
    }
    [self deleteArrowWithDirection:dString];
    
}


-(void) addRandomArrow{
    NSString *imagename = [ARROW objectAtIndex:arc4random()%ARROW.count];
    UIImage *bg = [UIImage imageNamed:imagename];
    CGRect frame;
    //frame.origin = CGPointZero;
    frame.size = bg.size;
    int x = (arc4random()%(int)self.boardView.bounds.size.width)/frame.size.width;
    frame.origin.x  = x*frame.size.width;
    frame.origin.y = 15.0;
    UIImageView *item = [[UIImageView alloc] initWithImage:bg];
    item.frame = frame;
    [self.boardView addSubview:item];
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.gravity addItem:item];
    Arrow *arrow = [[Arrow alloc] initWithView:item andDirection:imagename];
    
    [self.playingArrows addObject:arrow];
}
-(void) speedUp{
    [self flashWithHint:@"Prepare to Speed Up"];
    if (self.gravity.magnitude <1.0) {
        self.gravity.magnitude+=0.2;
    }
    else{
        [self.speedTimer invalidate];
    }
    
}
-(void) viewDidAppear:(BOOL)animated{
    //app had entered backgroud while playing
    //restore timer
    if ([self.restartBtn.titleLabel.text isEqualToString:@"REPLAY"] && !self.restartBtn.isEnabled) {
        self.addTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(addRandomArrow) userInfo:nil repeats:YES];
        self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(speedUp) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.addTimer invalidate];
    [self.speedTimer invalidate];

}
@end
