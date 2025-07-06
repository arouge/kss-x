#import <Cocoa/Cocoa.h>
#import "CAOutputUnit.h"

#import "kssplay.h"
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
	bool bufferGenerated;
	
	// Audio
	CAOutputUnit *m_OutputUnit;

	AudioStreamBasicDescription myAudioProperty;
	short shortBuffer[2][MAX_RATE*2]; // Buffers interlaced up to 112Khz
	bool whichBuffer;
	bool m_moreToDo;
	int position;
	bool kssUpdated;
    id m_playerController;

	
	int songShouldChange;
	long framePlayed;
	
	// KSS Libraries
	KSSPLAY *kssplay;
	KSS	*kss;
	
	ComponentResult	returnedValue;
	
	// Public Var (accessible via methods)
    NSInteger m_fileOpen;
	NSString *m_kssFile;
    NSInteger m_frameRate;
    NSInteger m_defaultPlayTime;
    NSInteger m_bufferSize;
    NSInteger m_playTime;
    NSInteger m_songNumber;
    NSInteger m_timePlayed;
    NSInteger m_vdpSpeed;
    NSInteger m_cpuSpeed;
    NSInteger m_masterVolume;
    NSInteger m_psgVolume;
    NSInteger m_sccVolume;
    NSInteger m_oplVolume;
    NSInteger m_opllVolume;
    NSInteger m_psgMask;
    NSInteger m_sccMask;
    NSInteger m_oplMask;
    NSInteger m_opllMask;
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

- (void)setCpuSpeed:(NSInteger)cpuSpeed;
-(NSInteger)getCpuSpeed;
-(int)shouldReadNotes;

-(NSInteger)sccMask;
-(NSInteger)psgMask;
-(void)setPsgMask:(NSInteger)psgMask;
-(void)setSccMask:(NSInteger)sccMask;
-(void)setOplMask:(NSInteger)oplMask;

-(void)setPsgPan:(NSInteger)psgPan;
-(void)setSCCPan:(NSInteger)sccPan;
-(void)setOplPan:(NSInteger)oplPan;
-(void)setOpllPan:(NSInteger)opllPan;

-(NSInteger)psgVolume;
-(NSInteger)sccVolume;
-(NSInteger)oplVolume;
-(NSInteger)opllVolume;




-(NSInteger)size;
-(BOOL)isRunning;
-(void)changeMasterVolume:(NSInteger)psgVolume;
-(NSInteger)masterVolume;
-(void)changePsgVolume:(NSInteger)psgVolume;
-(void)changeSccVolume:(NSInteger)sccVolume;
-(void)changeOplVolume:(NSInteger)oplVolume;
-(void)changeOpllVolume:(NSInteger)opllVolume;
-(void)setMoreToDo:(NSInteger)value;
-(NSInteger)moreToDo;
-(void)setOpllMask:(NSInteger)opllMask;
-(void)setOpllPan:(NSInteger)channel value:(NSInteger)value;


- (NSInteger)getVdpSpeed;

// nouvelles fonctions crees essentiellement pour l'export en wave.
-(NSInteger)defaultPlayTime;
- (void)setDefaultPlayTime:(NSInteger)defaultPlayTime;



-(NSInteger)getPsgVolume;
-(NSInteger)getPsgMask;

-(NSInteger)getSccVolume;
-(NSInteger)getSccMask;

-(NSInteger)getOplVolume;
-(NSInteger)oplMask;

-(NSInteger)getOpllVolume;

-(NSInteger)opllMask;
-(NSInteger)getOpllPan:(NSInteger)channelNumber;

-(NSInteger)getMasterVolume;

-(NSString *)m3uFileLocation;
-(void)setm3uFileLocation:(NSString *)filePath type:(NSString *)typeName;

-(void)fileDraged:(NSString *)filePath type:(NSString *)typeName;

-(void)play;
-(void)pause;
-(void)togglePause;
-(void)setFadeOutTime:(int)fadeTime;
- (NSInteger)frameRate;
- (void)setFrameRate:(NSInteger)frameRate;
- (NSInteger)songNumber;
- (void)setSongNumber:(NSInteger)songNumber;
- (NSInteger)playTime;
- (void)setPlayTime:(NSInteger)playTime;
- (NSInteger)bufferSize;
- (void)setBufferSize:(NSInteger)bufferSize;
- (NSInteger)fileOpen;
- (void)setFileOpen:(NSInteger)status;
- (void)setVdpSpeed:(NSInteger)vdpSpeed;
- (void)resetSong;
- (void)setSongTime:(int)songTime;

- (NSString *)kssFile;
- (BOOL)setKssFile:(NSString *)kssFile;

- (void)createAudio; // Create Audio Stuff
- (void)updateKss:(BOOL)complete; // Create KSS stuff


- (id)generateBuffer;
- (void)setPlayerAddress:(id)playerAddress;

-(PSG *)psg;
-(SCC *)scc;
-(OPLL *)opll;
-(SNG *)sng;
-(OPL *)opl;
-(KMZ80_CONTEXT)context;

@end
