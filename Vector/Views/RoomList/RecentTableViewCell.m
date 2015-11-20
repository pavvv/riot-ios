/*
 Copyright 2015 OpenMarket Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RecentTableViewCell.h"

@implementation RecentTableViewCell

#pragma mark - Class methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Round image view
    [_roomAvatar.layer setCornerRadius:_roomAvatar.frame.size.width / 2];
    _roomAvatar.clipsToBounds = YES;
}

- (void)render:(MXKCellData *)cellData
{
    id<MXKRecentCellDataStoring> roomCellData = (id<MXKRecentCellDataStoring>)cellData;
    if (roomCellData)
    {
        // Report computed values as is
        self.roomTitle.text = roomCellData.roomDisplayname;
        self.lastEventDate.text = roomCellData.lastEventDate;
        
        // FIXME handle room avatar
        self.roomAvatar.image = nil;
        self.roomAvatar.backgroundColor = [UIColor lightGrayColor];
        
        // Manage lastEventAttributedTextMessage optional property
        if ([roomCellData respondsToSelector:@selector(lastEventAttributedTextMessage)])
        {
            self.lastEventDescription.attributedText = roomCellData.lastEventAttributedTextMessage;
        }
        else
        {
            self.lastEventDescription.text = roomCellData.lastEventTextMessage;
        }
        
        // Notify unreads and bing
        self.bingIndicator.hidden = YES;
        
        if (roomCellData.unreadCount)
        {
            if (0 < roomCellData.unreadBingCount)
            {
                self.bingIndicator.hidden = NO;
                self.bingIndicator.backgroundColor = roomCellData.recentsDataSource.eventFormatter.bingTextColor;
            }
            self.roomTitle.font = [UIFont boldSystemFontOfSize:19];
        }
        else
        {
            self.roomTitle.font = [UIFont systemFontOfSize:19];
        }
    }
    else
    {
        self.lastEventDescription.text = @"";
    }
}

+ (CGFloat)heightForCellData:(MXKCellData *)cellData withMaximumWidth:(CGFloat)maxWidth
{
    // The height is fixed
    return 74;
}

@end
