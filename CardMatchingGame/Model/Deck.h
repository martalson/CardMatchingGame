//
//  Deck.h
//  CardMatchingGame
//
//  Created by Martin Alonso on 4/24/14.
//  Copyright (c) 2014 martalson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Deck : NSObject

-(void) addCard: (Card *) card atTop: (BOOL) atTop;

-(Card*) drawRandomCard;

@end
