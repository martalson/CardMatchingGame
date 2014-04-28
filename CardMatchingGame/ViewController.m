//
//  ViewController.m
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *Slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) int flipCount;
@property (nonatomic) NSMutableArray *pastFlips;
@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation ViewController

-(CardMatchingGame *)game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc]init] matchingCards:0];
        self.modeSegment.selectedSegmentIndex = -1;
    }
    return _game;
}

-(void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(NSMutableArray*) pastFlips{
    if(!_pastFlips){
        _pastFlips = [[NSMutableArray alloc] init];
    }
    return _pastFlips;
}

-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    if(self.game.matchingNum){
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
        self.flipCount++;
        [self updateUI];
        if(self.flipCount ==1){
            if(self.modeSegment.selectedSegmentIndex ==0){
                [self.modeSegment setEnabled:NO forSegmentAtIndex:1];
            }
            else{
                [self.modeSegment setEnabled:NO forSegmentAtIndex:0];
            }
        }
    }
    else{
        self.historyLabel.text = @"select a game mode";
    }
}

- (IBAction)mode:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex ==0 && [sender isEnabledForSegmentAtIndex:0]){
        self.game.matchingNum = 2;
    }
    else{
        self.game.matchingNum = 3;
    }
    self.historyLabel.text = @" ";
    self.Slider.maximumValue = 10;
    self.Slider.minimumValue = 0;
    self.Slider.value = 0;
}

-(void) updateUI{
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.selected = card.isFaceUp;
        if(!cardButton.isSelected){
            UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.jpg"];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
        }else{
           [cardButton setBackgroundImage:[UIImage imageNamed:@"cardfront.png"] forState:UIControlStateNormal];
        
        }
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];

        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.historyLabel.text = self.game.lastEvent;
    if(self.historyLabel.text){
        if([self.pastFlips count] < 10){
            for(int h = [self.pastFlips count]; h>0; h--){
                self.pastFlips[h]= self.pastFlips[h-1];
        }
        }
        else{
            for(int i = 9; i > 0; i--){
                self.pastFlips[i] = self.pastFlips[i-1];
            }
        }
        if(self.pastFlips.count){
            [self.pastFlips removeObjectAtIndex:0];
        }
        
    [self.pastFlips insertObject:self.historyLabel.text atIndex:0];
    }
self.Slider.value = self.Slider.minimumValue;
}
- (IBAction)newGame:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    for(int h = 0; h < [self.modeSegment numberOfSegments]; h++){
        [self.modeSegment setEnabled: YES forSegmentAtIndex:h];
    }
    self.modeSegment.selectedSegmentIndex = -1;
    [self updateUI];
}

- (IBAction)historySlider:(UISlider *)sender {
    if(((int)sender.value) < [self.pastFlips count]){
        self.historyLabel.text = self.pastFlips[((int)(sender.value -0.1))];
    }
}

@end
