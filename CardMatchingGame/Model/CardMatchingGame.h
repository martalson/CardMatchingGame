//
//  CardMatchingGame.h
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
@interface CardMatchingGame : NSObject
-(id)initWithCardCount: (NSInteger) cardCount usingDeck:(Deck *) deck matchingCards:(NSUInteger) number;
-(void)flipCardAtIndex:(NSUInteger) index;

-(Card *)cardAtIndex: (NSUInteger)index;
@property(nonatomic,readonly) int score;
@property(nonatomic, strong) NSString *lastEvent;
@property(nonatomic)NSUInteger matchingNum;
@end
