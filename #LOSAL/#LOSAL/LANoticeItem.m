//
//  LANoticeItem.m
//  #LOSAL
//
//  Created by James Orion Hall on 8/29/13.
//  Copyright (c) 2013 Localism. All rights reserved.
//

#import "LANoticeItem.h"

@implementation LANoticeItem

- (id)initWithnoticeObject:(PFObject *)object
               NoticeTitle:(NSString *)title
             noticeContent:(NSString *)content
{
    self = [super init];
    if (self) {
        [self setPostObject:object];
        [self setNoticeTitle:title];
        [self setNoticeContent:content];
    }

    return self;
}

- (UIImage *)thumbnail
{
    if (!_thumbnailData)
        return nil;

    if (!_thumbnail)
        // create the image from the data
        _thumbnail = [UIImage imageWithData:_thumbnailData];

    return _thumbnail;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_noticeTitle forKey:@"noticeTitle"];
    [aCoder encodeObject:_noticeContent forKey:@"noticeContent"];
    [aCoder encodeObject:_imageKey forKey:@"imageKey"];
    [aCoder encodeObject:_thumbnailData forKey:@"thumbnailData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setNoticeTitle:[aDecoder decodeObjectForKey:@"noticeTitle"]];
        [self setNoticeContent:[aDecoder decodeObjectForKey:@"noticeContent"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        _thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 70, 70);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}

@end
