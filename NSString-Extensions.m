// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2009 Steve Nygard.

#import "NSString-Extensions.h"

@implementation NSString (CDExtensions)

+ (NSString *)stringWithFileSystemRepresentation:(const char *)str;
{
    // 2004-01-16: I'm don't understand why we need to pass in the length.
    return [[NSFileManager defaultManager] stringWithFileSystemRepresentation:str length:strlen(str)];
}

+ (NSString *)spacesIndentedToLevel:(int)level;
{
    return [self spacesIndentedToLevel:level spacesPerLevel:4];
}

+ (NSString *)spacesIndentedToLevel:(int)level spacesPerLevel:(int)spacesPerLevel;
{
    NSString *spaces = @"                                        ";
    NSString *levelSpaces;
    NSMutableString *str;
    int l;

    assert(spacesPerLevel <= [spaces length]);
    levelSpaces = [spaces substringToIndex:spacesPerLevel];

    str = [NSMutableString string];
    for (l = 0; l < level; l++)
        [str appendString:levelSpaces];

    return str;
}

+ (NSString *)stringWithUnichar:(unichar)character;
{
    return [NSString stringWithCharacters:&character length:1];
}

- (BOOL)isFirstLetterUppercase;
{
    NSRange letterRange;

    letterRange = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if (letterRange.length == 0)
        return NO;

    return [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:letterRange.location]];
}

- (void)print;
{
    NSData *data;

    data = [self dataUsingEncoding:NSUTF8StringEncoding];
    [(NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput] writeData:data];
}

- (NSString *)executablePathForFilename;
{
    NSBundle *bundle;
    NSString *path;

    // I give up, all the methods dealing with paths seem to resolve symlinks with a vengence.
    bundle = [NSBundle bundleWithPath:self];
    if (bundle != nil) {
        if ([bundle executablePath] == nil)
            return nil;

        path = [[[bundle executablePath] stringByResolvingSymlinksInPath] stringByStandardizingPath];
    } else {
        path = [[self stringByResolvingSymlinksInPath] stringByStandardizingPath];
    }

    return path;
}

@end
