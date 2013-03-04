//
//  main.m
//  xgrep
//
//  Created by Masayuki Nii on 2013/03/03.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSError *error;
        NSString *pattern = [[NSString alloc] initWithBytes: argv[1] length: strlen(argv[1]) encoding: NSUTF8StringEncoding];
        NSString *targetFile = [[NSString alloc] initWithBytes: argv[2] length: strlen(argv[2]) encoding: NSUTF8StringEncoding];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error: &error];
        
        NSStringEncoding usedEnc;
        NSString *fileContent = [NSString stringWithContentsOfFile: targetFile usedEncoding: &usedEnc error:&error];
        
        [[fileContent componentsSeparatedByString: @"\n"] enumerateObjectsUsingBlock: ^(NSString *aLine, NSUInteger idx, BOOL *stop){
            if ( [regex numberOfMatchesInString: aLine options: 0 range: NSMakeRange(0, aLine.length)] > 0 )   {
                NSLog( @"%@", aLine );
            };
        }];
        
    }
    return 0;
}

