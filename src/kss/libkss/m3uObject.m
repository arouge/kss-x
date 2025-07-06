#import "m3uObject.h"


@implementation m3uObject

- (id)initWithTrackNumber:(NSInteger)trackNumber title:(NSString *)title fileLocation:(NSString *)fileLocation duration:(NSInteger)duration fadeOut:(NSInteger)fadeOut
{
    if (self = [super init]) {
        m_trackNumber = trackNumber;
        m_title = [title copy];
        m_fileLocation = [fileLocation copy];
        m_duration = duration;
		m_fadeOut = fadeOut;
    }
    return self;
}

/*- (void)dealloc
{
    [m_title release];
    [m_fileLocation release];
    [super dealloc];
}
*/
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

- (NSInteger)trackNumber
{
    return m_trackNumber;
}

- (void)setTrackNumber:(NSInteger)trackNumber
{
    m_trackNumber = trackNumber;
}

- (NSString *)title;
{
    return m_title;
}

- (void)setTitle:(NSString *)title;
{
    m_title = [title copy];
}

- (NSString *)fileLocation
{
    return m_fileLocation;
}

- (void)setFileLocation:(NSString *)fileLocation
{
    m_fileLocation = [fileLocation copy];
}

-(NSInteger)intDuration
{
	return m_duration;
}

- (NSString *)duration
{
	NSString *temporaryString;
    temporaryString = [NSString stringWithFormat: @"%d:%02d:%02ld",(int) (m_duration  / (60 * 60)),(int) (m_duration / 60 % 60), (m_duration % 60)];
	return temporaryString;
}

- (void)setDuration:(NSInteger)duration
{
    m_duration = duration;
}

- (NSInteger)fadeOut
{
    return m_fadeOut;
}

- (void)setFadeOut:(NSInteger)fadeOut
{
    m_fadeOut = fadeOut;
}
/*
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
*/
/*
- (id)initWithCoder:(NSCoder *)pCoder;
{
	
	m_fileLocation = [pCoder decodeObject];
	m_fileType = [pCoder decodeObject];
	m_trackNumber = [pCoder decodeObject];
	m_title = [pCoder decodeObject];
	m_duration = [pCoder decodeObject];
	m_loopTime = [pCoder decodeObject];
	m_fadeOut = [pCoder decodeObject];
	m_loopNumber = [pCoder decodeObject];
	m_psgVolume = [pCoder decodeObject];
	m_sccVolume = [pCoder decodeObject];
	m_oplVolume = [pCoder decodeObject];
	m_opllVolume = [pCoder decodeObject];
	
	return self;
	
}// end initWithCoder
*/

@end
