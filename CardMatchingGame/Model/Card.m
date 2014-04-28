//
//  Card.m
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import "Card.h"

@implementation Card
//Added a match for superclass in case we want to create another matching cards game
-(int) match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    return score;
}

@end
