// This is a Demo of the Irrlicht Engine (c) 2006 by N.Gebhardt.
// This file is not documented.

#ifndef __C_DEMO_H_INCLUDED__
#define __C_DEMO_H_INCLUDED__

#define USE_IRRKLANG
//#define USE_SDL_MIXER

// Include path in project by defaults assumes C:\irrlicht-1.5
// Get Irrlicht from http://irrlicht.sourceforge.net/ , it's a great engine
#include <irrlicht.h>

#define IRRLICHT_MEDIA_PATH "IrrlichtMedia/"

#ifdef __WIN32__
#include "WindowsIncludes.h" // Prevent 'fd_set' : 'struct' type redefinition
#include <windows.h>
#endif

using namespace irr;

// audio support

// Included in RakNet download with permission by Nikolaus Gebhardt
#ifdef USE_IRRKLANG
	#include <irrKlang-1.1.3/irrKlang.h>

	#ifdef _IRR_WINDOWS_
	#pragma comment (lib, "irrKlang-1.1.3/irrKlang.lib")
	#endif
#endif
#ifdef USE_SDL_MIXER
	# include <SDL/SDL.h>
	# include <SDL/SDL_mixer.h>
#endif

const int CAMERA_COUNT = 7;
const float CAMERA_HEIGHT=50.0f;
const float SHOT_SPEED=.6f;
const float BALL_DIAMETER=25.0f;

// RakNet
#include "RakNetStuff.h"
#include "DS_Multilist.h"
#include "RakString.h"
#include "RakNetTime.h"

class CDemo : public IEventReceiver, public RakNet::UDPProxyClientResultHandler
{
public:

	CDemo(bool fullscreen, bool music, bool shadows, bool additive, bool vsync, bool aa, video::E_DRIVER_TYPE driver, core::stringw &_playerName);

	~CDemo();

	void run();

	virtual bool OnEvent(const SEvent& event);
	IrrlichtDevice * GetDevice(void) const {return device;}
	scene::ISceneManager* GetSceneManager(void) const {return device->getSceneManager();}


	// RakNet: Control what animation is playing by what key is pressed on the remote system
	bool IsKeyDown(EKEY_CODE keyCode) const;
	bool IsMovementKeyDown(void) const;
	// RakNet: Decouple the origin of the shot from the camera, so the network code can use this same graphical effect
	RakNetTime shootFromOrigin(core::vector3df camPosition, core::vector3df camAt);
	const core::aabbox3df& GetSyndeyBoundingBox(void) const;
	void PlayDeathSound(core::vector3df position);
	void EnableInput(bool enabled);

private:

	void createLoadingScreen();
	void loadSceneData();
	void switchToNextScene();
	void shoot();
	void createParticleImpacts();

	bool fullscreen;
	bool music;
	bool shadows;
	bool additive;
	bool vsync;
	bool aa;
	video::E_DRIVER_TYPE driverType;
	core::stringw playerName;
	IrrlichtDevice *device;

#ifdef USE_IRRKLANG
	void startIrrKlang();
	irrklang::ISoundEngine* irrKlang;
	irrklang::ISoundSource* ballSound;
	irrklang::ISoundSource* deathSound;
	irrklang::ISoundSource* impactSound;
#endif

#ifdef USE_SDL_MIXER
	void startSound();
	void playSound(Mix_Chunk *);
	void pollSound();
	Mix_Music *stream;
	Mix_Chunk *ballSound;
	Mix_Chunk *impactSound;
#endif

	struct SParticleImpact
	{
		u32 when;
		core::vector3df pos;
		core::vector3df outVector;
	};

	int currentScene;
	video::SColor backColor;

	gui::IGUIStaticText* statusText;
	gui::IGUIInOutFader* inOutFader;

	scene::IQ3LevelMesh* quakeLevelMesh;
	scene::ISceneNode* quakeLevelNode;
	scene::ISceneNode* skyboxNode;
	scene::IAnimatedMeshSceneNode* model1;
	scene::IAnimatedMeshSceneNode* model2;
	scene::IParticleSystemSceneNode* campFire;

	scene::IMetaTriangleSelector* metaSelector;
	scene::ITriangleSelector* mapSelector;

	s32 sceneStartTime;
	s32 timeForThisScene;

	core::array<SParticleImpact> Impacts;

	// Per-tick game update for RakNet
	void UpdateRakNet(void);
	// Callbacks from RakNet::UDPProxyClientResultHandler
	virtual void OnForwardingSuccess(const char *proxyIPAddress, unsigned short proxyPort, unsigned short reverseProxyPort,
		SystemAddress proxyCoordinator, SystemAddress sourceAddress, SystemAddress targetAddress, RakNet::UDPProxyClient *proxyClientPlugin);
	virtual void OnForwardingNotification(const char *proxyIPAddress, unsigned short proxyPort, unsigned short reverseProxyPort,
		SystemAddress proxyCoordinator, SystemAddress sourceAddress, SystemAddress targetAddress, RakNet::UDPProxyClient *proxyClientPlugin);
	virtual void OnNoServersOnline(SystemAddress proxyCoordinator, SystemAddress sourceAddress, SystemAddress targetAddress, RakNet::UDPProxyClient *proxyClientPlugin);
	virtual void OnAllServersBusy(SystemAddress proxyCoordinator, SystemAddress sourceAddress, SystemAddress targetAddress, RakNet::UDPProxyClient *proxyClientPlugin);
	virtual void OnForwardingInProgress(SystemAddress proxyCoordinator, SystemAddress sourceAddress, SystemAddress targetAddress, RakNet::UDPProxyClient *proxyClientPlugin);
	// Holds output messages
	DataStructures::Multilist<ML_QUEUE, RakNet::RakString> outputMessages;
	RakNetTime whenOutputMessageStarted;
	void PushMessage(RakNet::RakString rs);
	const char *GetCurrentMessage(void);
	// Systems to try to connect to with NAT punchthrough
	DataStructures::Multilist<ML_QUEUE, RakNetGUID> systemsToConnectTo;
	bool isConnectedToNATPunchthroughServer;
	// We use this array to store the current state of each key
	bool KeyIsDown[KEY_KEY_CODES_COUNT];
	// Bounding box of syndney.md2, extended by BALL_DIAMETER/2 for collision against shots
	core::aabbox3df syndeyBoundingBox;
	void CalculateSyndeyBoundingBox(void);
};

#endif

