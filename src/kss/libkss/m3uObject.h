/* MyController */

#import <Cocoa/Cocoa.h>

@interface m3uObject : NSObject
{
//	NSNumber *m_activated;
	NSString *m_fileLocation;
	NSString *m_fileType;
    NSInteger m_trackNumber;
    NSString *m_title;
    NSInteger m_duration;
	NSString *m_loopTime;
    NSInteger m_fadeOut;
    NSInteger m_loopNumber;
    NSInteger m_psgVolume;
    NSInteger m_sccVolume;
    NSInteger m_oplVolume;
    NSInteger m_opllVolume;
}

- (id)initWithTrackNumber:(NSInteger)trackNumber title:(NSString *)title fileLocation:(NSString *)fileLocation duration:(NSInteger)duration fadeOut:(NSInteger)fadeOut; 

//- (NSNumber *)activated;
//- (void)setActivated:(NSNumber *)activated;

- (NSInteger)trackNumber;
- (void)setTrackNumber:(NSInteger)trackNumber;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)fileLocation;
- (void)setFileLocation:(NSString *)fileLocation;

- (NSInteger)intDuration;
- (NSString *)duration;
- (void)setDuration:(NSInteger)duration;

- (NSInteger)fadeOut;
- (void)setFadeOut:(NSInteger)fadeOut;

@end
