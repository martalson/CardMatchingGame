//
//  PlayingCard.h
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
@property(strong,nonatomic) NSString *suit;
@property(nonatomic)NSUInteger rank;

+(NSArray *) validSuits;
+(NSUInteger) maxRank;

@end
