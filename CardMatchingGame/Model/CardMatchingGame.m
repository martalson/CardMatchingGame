//
//  CardMatchingGame.m
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property(strong, nonatomic)NSMutableArray *cards;
@property(nonatomic) int score;
@end

@implementation CardMatchingGame
-(NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

-(instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck matchingCards:(NSUInteger) number
{
    self = [super init];
    if(self){
        self.matchingNum = number;
        NSLog(@" count = %lu", count);
        for(int i = 0; i < count; i+=2){
            NSLog(@"%d", i);
            Card *card = [deck drawRandomCard];
            if(!card){
                self = nil;
            }else{
                [self.cards insertObject:card atIndex:i];
                [self.cards insertObject:[[PlayingCard alloc]init] atIndex:i + 1];
                PlayingCard *cpy = ((PlayingCard *)self.cards[i+1]);
                cpy.rank = ((PlayingCard *)self.cards[i]).rank;
                cpy.suit = ((PlayingCard *)self.cards[i]).suit;
            }
        }
        [self shuffle];
    }
    return self;
}
-(void) shuffle{
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger n = (NSUInteger)arc4random() *i % count;
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    int change = self.score;
    if(!card.isUnplayable){
        if(!card.isFaceUp){
            NSMutableArray *cardsUp = [[NSMutableArray alloc] init];
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    [cardsUp addObject:otherCard];
                    int matchScore = [card match: cardsUp];
                    
                    //Case of 2 cards mode
                    
                    if(matchScore && self.matchingNum == 2){
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        NSArray *text = @[@"Matched", otherCard.contents,@"&",card.contents,[NSString stringWithFormat:@"for a value of %d points.", matchScore * MATCH_BONUS]];
                        self.lastEvent = [text componentsJoinedByString:@ " "];
                        break;
                    }
                
                    else if(self.matchingNum == 2 && !matchScore){
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        NSArray *text = @[otherCard.contents , @"&", card.contents,@"Don't match!" , [NSString stringWithFormat:@"%d point penalty", MISMATCH_PENALTY]];
                        self.lastEvent = [text componentsJoinedByString:@" "];
                        break;
                                    
                }
                   
                    //Case of 3 cards mode
                
                    
                    else if(self.matchingNum == 3 && [cardsUp count] ==2){
                        NSMutableArray *matches = [[NSMutableArray alloc]init];
                        for(Card *other in cardsUp){
                            if([card match: @[other]]){
                                [matches addObject:other];
                                card.unplayable = YES;
                                other.unplayable = YES;
                            }
                        }
                        if(matchScore){
                            [matches addObject:card];
                        }
                        if(![matches containsObject:cardsUp[0]] || ![matches containsObject:cardsUp[1]]){
                            int a = ([cardsUp[0] match: @[cardsUp[1]]])/2;
                            if(a){
                                ((Card *) cardsUp[0]).unplayable = YES;
                                ((Card *) cardsUp[1]).unplayable = YES;
                                if(![matches containsObject:cardsUp[0]]){
                                    [matches addObject:cardsUp[0]];
                                }
                                if(![matches containsObject:cardsUp[1]]){
                                    [matches addObject:cardsUp[1]];
                                }
                                matchScore += a + 1;
                            }
                        }
                        self.score += matchScore * MATCH_BONUS;
                        if([matches count] ==0){
                            for(Card *x in cardsUp){
                                x.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            NSArray *text = @[((Card *) cardsUp[0]).contents, @",", ((Card *) cardsUp[1]).contents, @"&", card.contents, @"Don't match!", [NSString stringWithFormat:@"%d point penalty", MISMATCH_PENALTY]];
                                self.lastEvent = [text componentsJoinedByString:@" "];
                            
                        }
                        else{
                            for(int l = 0; l<[matches count]; l++){
                                matches[l] = ((Card *) matches[l]).contents;
                            }
                            NSString *txt = [matches componentsJoinedByString:@" "];
                            NSArray *text = @[@"Matched", txt, [NSString stringWithFormat:@"for a value of %d points.", matchScore * MATCH_BONUS]];
                            self.lastEvent = [text componentsJoinedByString:@" "];
                            }
                        break;
                    }
                }
            }
                if(self.matchingNum ==3){
                    self.score -= FLIP_COST;
                }
                self.score -= FLIP_COST;
        }
            if(change == self.score){
                self.lastEvent = [NSString stringWithFormat:@"You flipped %@ down", card.contents];
            }
            else if(change == self.score + FLIP_COST){
                self.lastEvent = [NSString stringWithFormat:@"You flipped %@ up! 1 pt lost", card.contents];
            }
            else if(change == self.score + 2* FLIP_COST){
                self.lastEvent = [NSString stringWithFormat:@"You flipped %@ up! 2pts lost", card.contents];
            }
            card.faceUp = !card.isFaceUp;
    }
}

-(Card *) cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
