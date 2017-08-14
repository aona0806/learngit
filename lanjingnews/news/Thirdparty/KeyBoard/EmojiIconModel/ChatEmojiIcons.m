//
//  ChatEmojiIcons.m
//  chatUI
//
//  Created by TI on 15/4/23.
//  Copyright (c) 2015年 YccTime. All rights reserved.
//

#import "ChatEmojiIcons.h"

@implementation ChatEmojiIcons

+ (NSArray *)emojis {
    static NSArray *_emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojis = @[@"[0_grinning]",
                    @"[2_heart_eyes]",
                    @"[3_flushed]",
                    @"[4_sunglasses]",
                    @"[5_sob]",
                    @"[6_blush]",
                    @"[7_sleeping]",
                    @"[8_ciya]",
                    @"[9_stuck_out_tongue_closed_eyes]",
                    @"[10_cold_sweat]",
                    @"[11_jianjiande]",
                    @"[12_mask]",
                    @"[13_joy]",
                    @"[14_scream]",
                    @"[15_kissing_heart]",
                    @"[16_innocent]",
                    @"[17_triumph]",
                    @"[18_dizzy_face]",
                    @"[19_pensive]",
                    @"[20_unamused]",
                    @"[21_smiling_imp]",
                    @"[22_byebye]",
                    @"[23_cupid]",
                    @"[24_kiss]",
                    @"[25_koushui]",
                    @"[11_grin]",
                    @"[ges_clap]",
                    @"[ges_facepunch]",
                    @"[ges_metal]",
                    @"[ges_muscle]",
                    @"[ges_ok_hand]",
                    @"[ges_pray]",
                    @"[ges_thumbdown]",
                    @"[ges_thumbup]",
                    @"[ges_v]",
                    @"[food_banana]",
                    @"[food_cake]",
                    @"[food_candy]",
                    @"[food_cherries]",
                    @"[food_chocolate_bar]",
                    @"[food_cocktail]",
                    @"[food_corn]",
                    @"[food_custard]",
                    @"[food_dango]",
                    @"[food_doughnut]",
                    @"[food_eggplant]",
                    @"[food_fried_shrimp]",
                    @"[food_fries]",
                    @"[food_grapes]",
                    @"[food_green_apple]",
                    @"[food_hamburger]",
                    @"[food_honey_pot]",
                    @"[food_icecream]",
                    @"[food_lemon]",
                    @"[food_lollipop]",
                    @"[food_meat_on_bone]",
                    @"[food_peach]",
                    @"[food_pear]",
                    @"[food_pineapple]",
                    @"[food_pizza]",
                    @"[food_ramen]",
                    @"[food_spaghetti]",
                    @"[food_strawberry]",
                    @"[food_sushi]",
                    @"[food_tangerine]",
                    @"[food_tea]",
                    @"[food_tropical_drink]",
                    @"[food_watermelon]",
                    @"[other_baby_bottle]",
                    @"[other_bomb]",
                    @"[other_hocho]",
                    @"[other_money_with_wings]",
                    @"[other_musical_note]",
                    @"[other_secret]",
                    @"[other_snowflake]",
                    @"[other_snowman]",
                    @"[other_sos]",
                    @"[other_turtle]",
                    @"[other_underage]",
                    @"[other_up]",
                    @"[party_bikini]",
                    @"[party_christmas_tree]",
                    @"[party_fire]",
                    @"[party_ghost]",
                    @"[party_jack_o_lantern]",
                    @"[party_tada]",
                    @"[sport_basketball]",
                    @"[sport_soccer]"];
    });
    return _emojis;
}

+(NSInteger)getEmojiPopCount{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag {
    NSArray *emojis = [[self class] emojis];
    return emojis[tag];
}

+(NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag{
    NSString * name = [[self class] getEmojiNameByTag:tag];
    return [[self class] imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag {
    NSString *key = [NSString stringWithFormat:@"emoji_%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+ (NSArray *)pandas {
    static NSArray *_pandas;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"emoticons" ofType:@"json"];
        //获取plist中的数据

        NSData *citysData = [NSData dataWithContentsOfFile:path];
        
        NSError *error;
        _pandas = [NSJSONSerialization JSONObjectWithData:citysData options:kNilOptions error:&error];
        
    });
    return _pandas;
}

+(NSInteger)getPandaPopCount{
    return [[self class] pandas].count;
}

+ (NSString *)getPandaNameByTag:(NSInteger)tag {
    NSArray *pandas = [[self class] pandas];
    return pandas[tag][@"chs"];
}

+(NSString *)getPandaPopIMGNameByTag:(NSInteger)tag{
    
//    NSString * name = [[self class]getPandaNameByTag:tag];
//    return [[self class]imgNameWithName:name];
    
    NSArray *pandas = [[self class] pandas];
    return pandas[tag][@"png"];
}

+ (NSString *)getPandaPopNameByTag:(NSInteger)tag {
    NSString *key = [NSString stringWithFormat:@"panda_%@", [self getPandaNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+(NSString *)imgNameWithName:(NSString*)name{
    NSRange  range = NSMakeRange(1, 0);
    range.length = MAX(name.length-2, 0);
    NSString * key = [name substringWithRange:range];
    return [NSString stringWithFormat:@"emo_%@",key];
}

@end
