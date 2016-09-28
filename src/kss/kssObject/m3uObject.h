/* MyController */

#import <Cocoa/Cocoa.h>

@interface m3uObject : NSObject
{
//	NSNumber *m_activated;
	NSString *m_fileLocation;
	NSString *m_fileType;
    NSNumber *m_trackNumber;
    NSString *m_title;
    NSString *m_duration;
	NSString *m_loopTime;
    NSNumber *m_fadeOut;
	NSString *m_loopNumber;
	NSString *m_psgVolume;
	NSString *m_sccVolume;
	NSString *m_oplVolume;
	NSString *m_opllVolume;
}

- (id)initWithTrackNumber:(NSNumber *)trackNumber title:(NSString *)title fileLocation:(NSString *)fileLocation duration:(NSString *)duration fadeOut:(NSString *)fadeOut; 

//- (NSNumber *)activated;
//- (void)setActivated:(NSNumber *)activated;

- (NSNumber *)trackNumber;
- (void)setTrackNumber:(NSNumber *)trackNumber;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)fileLocation;
- (void)setFileLocation:(NSString *)fileLocation;

-(int)intDuration;
- (NSString *)duration;
- (void)setDuration:(NSString *)duration;

- (NSNumber *)fadeOut;
- (void)setFadeOut:(NSNumber *)fadeOut;

@end
