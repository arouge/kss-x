#import <Cocoa/Cocoa.h>
#import "CAOutputUnit.h"
#import "libkss/kssplay.h"
#import "AUDIOToolbox.h"

@interface kssObject : NSObject
{
	#define MAX_RATE 111861
//	NSConditionLock *threadLock;
//	enum { HAS_DATA=0, NO_DATA=1 }; // Used to release a thread.
	
	// Cette constante est utilisee pour convertir un short en float.
	float shortMax ; //= 1.0f / ((float) 0x7fff);
	
	// Drivers load
	
	bool loadMgs;
	bool loadKinrou;
	bool loadMpk;
	bool loadMpk103;
	bool loadOpx;
	bool loadMbm;
	bool loadFmPac;
	bool  bufferGenerated;
	
	// Audio
	CAOutputUnit *m_OutputUnit;
	AudioStreamBasicDescription myAudioProperty;
	short shortBuffer[2][MAX_RATE*2]; // Buffers interlaced up to 112Khz
	bool whichBuffer;
	bool m_moreToDo;
	int position;
	bool kssUpdated;
	
//	int fastForwardState;
	
	int songShouldChange;
	long framePlayed;
	
	// KSS Libraries
	KSSPLAY *kssplay;
	KSS	*kss;
	
	ComponentResult	returnedValue;
	
	// Public Var (accessible via methods)
	//int *i_songPosition;
	NSNumber *m_fileOpen;
	NSString *m_kssFile;
	NSNumber *m_frameRate;
    NSNumber *m_defaultPlayTime;
	NSNumber *m_bufferSize;
	NSNumber *m_playTime;
	NSDate	*m_startTime;
	NSNumber *m_songNumber;
	NSNumber *m_timePlayed;
	NSNumber *m_vdpSpeed;
	NSNumber *m_cpuSpeed;
	NSNumber *m_masterVolume;	
	NSNumber *m_psgVolume;
	NSNumber *m_sccVolume;
	NSNumber *m_oplVolume;
	NSNumber *m_opllVolume;
	NSNumber *m_psgMask;
	NSNumber *m_sccMask;
	NSNumber *m_oplMask;
	NSNumber *m_opllMask;
	NSString *m_m3uFileLocation;
	int fadeOutTime;
	int m_songTime;
	
//	int directSongPositionValue;
	int shouldReadNote;
	int opllPan[14];
	
	int intPsgPan, intSccPan, intOplPan, intOpllPan;
	int opll_pan0, opll_pan1, opll_pan2, opll_pan3, opll_pan4, opll_pan5, opll_pan6, opll_pan7;
	int opll_pan8, opll_pan9, opll_pan10, opll_pan11, opll_pan12, opll_pan13;
}

- (void)setCpuSpeed:(NSNumber *)cpuSpeed;
-(NSNumber *)getCpuSpeed;
-(int)shouldReadNotes;

-(void)applyKssSettings;
-(NSNumber *)sccMask;
-(NSNumber *)psgMask;
-(void)setPsgMask:(NSNumber *)psgMask;
-(void)setSccMask:(NSNumber *)sccMask;
-(void)setOplMask:(NSNumber *)oplMask;

-(void)setPsgPan:(NSNumber *)psgPan;
-(void)setSCCPan:(NSNumber *)sccPan;
-(void)setOplPan:(NSNumber *)oplPan;
-(void)setOpllPan:(NSNumber *)opllPan;

-(NSNumber *)psgVolume;
-(NSNumber *)sccVolume;
-(NSNumber *)oplVolume;
-(NSNumber *)opllVolume;
-(NSDate *)startTime;




-(NSNumber *)size;
-(BOOL)isRunning;
-(void)changeMasterVolume:(NSNumber *)psgVolume;
-(NSNumber *)masterVolume;
-(void)changePsgVolume:(NSNumber *)psgVolume;
-(void)changeSccVolume:(NSNumber *)sccVolume;
-(void)changeOplVolume:(NSNumber *)oplVolume;
-(void)changeOpllVolume:(NSNumber *)opllVolume;
-(void)setMoreToDo:(NSNumber *)value;
-(NSNumber *)moreToDo;
-(void)setOpllMask:(NSNumber *)opllMask;
-(void)setOpllPan:(NSNumber *)channel value:(NSNumber *)value;


- (NSNumber *)getVdpSpeed;

// nouvelles fonctions crees essentiellement pour l'export en wave.
-(NSNumber *)defaultPlayTime;
- (void)setDefaultPlayTime:(NSNumber *)defaultPlayTime;



-(NSNumber *)getPsgVolume;
-(NSNumber *)getPsgMask;

-(NSNumber *)getSccVolume;
-(NSNumber *)getSccMask;

-(NSNumber *)getOplVolume;
-(NSNumber *)getOplMask;

-(NSNumber *)getOpllVolume;

-(NSNumber *)getOpllMask;
-(NSNumber *)getOpllPan:(NSNumber *)channelNumber;

-(NSNumber *)getMasterVolume;

-(NSString *)m3uFileLocation;
-(void)setm3uFileLocation:(NSString *)filePath type:(NSString *)typeName;

-(void)fileDraged:(NSString *)filePath type:(NSString *)typeName;

-(void)play;
-(void)pause;
-(void)togglePause;
-(void)setFadeOutTime:(int)fadeTime;
- (NSNumber *)frameRate;
- (void)setFrameRate:(NSNumber *)frameRate;
- (NSNumber *)songNumber;
- (void)setSongNumber:(NSNumber *)songNumber;
- (NSNumber *)playTime;
- (void)setPlayTime:(NSNumber *)playTime;
- (NSNumber *)bufferSize;
- (void)setBufferSize:(NSNumber *)bufferSize;
- (NSNumber *)fileOpen;
- (void)setFileOpen:(NSNumber *)status;
- (void)setVdpSpeed:(NSNumber *)vdpSpeed;
- (void)resetSong;
- (void)setSongTime:(int)songTime;

- (NSString *)kssFile;
- (BOOL)setKssFile:(NSString *)kssFile;

- (void)createAudio; // Create Audio Stuff
- (void)updateKss:(BOOL)complete; // Create KSS stuff


- (id)generateBuffer;



-(PSG *)psg;
-(SCC *)scc;
-(OPLL *)opll;
-(SNG *)sng;
-(OPL *)opl;
-(KMZ80_CONTEXT)context;

@end