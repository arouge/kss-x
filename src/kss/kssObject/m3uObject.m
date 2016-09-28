#import "m3uObject.h"


@implementation m3uObject

- (id)initWithTrackNumber:(NSNumber *)trackNumber title:(NSString *)title fileLocation:(NSString *)fileLocation duration:(NSString *)duration fadeOut:(NSString *)fadeOut
{
    if (self = [super init]) {
        m_trackNumber = [trackNumber copy];
        m_title = [title copy];
        m_fileLocation = [fileLocation copy];
        m_duration = [duration copy];
		m_fadeOut = [fadeOut copy];
    }
    return self;
}

- (void)dealloc
{
    [m_title release];
    [m_fileLocation release];
    [super dealloc];
}

/*
- (NSNumber *)activated
{
    return m_activated;
}

- (void)setActivated:(NSNumber *)activated
{
	[m_activated release];
    m_activated = [activated copy];
}
*/

- (NSNumber *)trackNumber
{
    return m_trackNumber;
}

- (void)setTrackNumber:(NSNumber *)trackNumber
{
	[m_trackNumber release];
    m_trackNumber = [trackNumber copy];
}

- (NSString *)title;
{
    return m_title;
}

- (void)setTitle:(NSString *)title;
{
    [m_title release];
    m_title = [title copy];
}

- (NSString *)fileLocation
{
    return m_fileLocation;
}

- (void)setFileLocation:(NSString *)fileLocation
{
    [m_fileLocation release];
    m_fileLocation = [fileLocation copy];
}

-(int)intDuration
{
	return [m_duration intValue];
}

- (NSString *)duration
{
	NSString *temporaryString;
	temporaryString = [NSString stringWithFormat: @"%d:%02d:%02d",(int) ([m_duration intValue] / (60 * 60)),(int) ([m_duration intValue] / 60 % 60),(int) ([m_duration intValue] % 60)];
	return temporaryString;
}

- (void)setDuration:(NSString *)duration
{
    m_duration = [duration copy];
}

- (NSNumber *)fadeOut
{
    return m_fadeOut;
}

- (void)setFadeOut:(NSNumber *)fadeOut
{
    [m_fadeOut release];
    m_fadeOut = [fadeOut copy];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:m_fileLocation];
	[coder encodeObject:m_fileType];
    [coder encodeObject:m_trackNumber];
	[coder encodeObject:m_title];
    [coder encodeObject:m_duration];
	[coder encodeObject:m_loopTime];
    [coder encodeObject:m_fadeOut];
	[coder encodeObject:m_loopNumber];
    [coder encodeObject:m_psgVolume];
	[coder encodeObject:m_sccVolume];
    [coder encodeObject:m_oplVolume];
	[coder encodeObject:m_opllVolume];
}

- (id)initWithCoder:(NSCoder *)pCoder;
{
	
	m_fileLocation = [[pCoder decodeObject] retain];
	m_fileType = [[pCoder decodeObject] retain];
	m_trackNumber = [[pCoder decodeObject] retain];
	m_title = [[pCoder decodeObject] retain];
	m_duration = [[pCoder decodeObject] retain];
	m_loopTime = [[pCoder decodeObject] retain];
	m_fadeOut = [[pCoder decodeObject] retain];
	m_loopNumber = [[pCoder decodeObject] retain];
	m_psgVolume = [[pCoder decodeObject] retain];
	m_sccVolume = [[pCoder decodeObject] retain];
	m_oplVolume = [[pCoder decodeObject] retain];
	m_opllVolume = [[pCoder decodeObject] retain];
	
	return self;
	
}// end initWithCoder


@end