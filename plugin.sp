//Precache sounds in OnMapStart()


//GetClientTeam(clientid) - 2=survivors 3=infected
//GetRandomInt(min,max) - includes min and max

#include <sourcemod>
#include <sdktools>

#define FUBUKI_COFFIN_DANCE "Awoo/fubuki_coffin_dance.mp3"
#define KOROFUNK "Awoo/korofunk.mp3"
#define HACHAMACHAMA "Awoo/hachamachama.mp3"
#define HACHAMAREMIX "Awoo/hachamaremix.mp3"
#define DRAGONOP "Awoo/dragonop.mp3"
#define SORAN "Awoo/soran.mp3"
#define YAGOOTEME "Awoo/yagooteme.mp3"

#define PEKO_ATTACK_SIZE 4
static const char sPekoAttack[PEKO_ATTACK_SIZE][] =
{
	"Awoo/ahahahaha.mp3",
	"Awoo/ecchisketchy.mp3",
	"Awoo/pekopekopeko.mp3",
	"Awoo/pekopekopeko2.mp3"
}


new	bool:b_logEvents = false;
new bool:b_finaleStarted = false;

enum ZOMBIECLASS
{
	ZOMBIECLASS_SMOKER = 1,
	ZOMBIECLASS_BOOMER,
	ZOMBIECLASS_HUNTER,
	ZOMBIECLASS_SPITTER,
	ZOMBIECLASS_JOCKEY,
	ZOMBIECLASS_CHARGER,
	ZOMBIECLASS_UNKNOWN,
	ZOMBIECLASS_TANK,
}

enum MUSIC
{
	MUSIC_FUBUKI_COFFIN_DANCE = 0,
	MUSIC_KOROFUNK,
	MUSIC_HACHAMACHAMA,
	MUSIC_HACHAMAREMIX,
	MUSIC_DRAGONOP,
	MUSIC_SORAN
}

#define MUSIC_PATH_SIZE 6

static const char sMusic[MUSIC_PATH_SIZE][] =
{
	"Awoo/fubuki_coffin_dance.mp3",
	"Awoo/korofunk.mp3",
	"Awoo/hachamachama.mp3",
	"Awoo/hachamaremix.mp3",
	"Awoo/dragonop.mp3",
	"Awoo/soran.mp3"
}
 
public Plugin myinfo =
{
	name = "AWOO SERVER PLUGIN",
	author = "ZRMDSXA",
	description = "Plugin for Awoo Server",
	version = "1.6",
	url = ""
};
 
public void OnPluginStart()
{
	PrintToServer("AWOO SERVER PLUGGIN");

	RegConsoleCmd("startlog", startLog);
	RegConsoleCmd("stoplog", stopLog);

	RegConsoleCmd("fbk", fubuki_coffin_dance);
	RegConsoleCmd("krn", korofunk);
	RegConsoleCmd("haato", hachamachama);
	RegConsoleCmd("haator", hachamaremix);
	RegConsoleCmd("coco", coco);
	RegConsoleCmd("soran", soran);
	RegConsoleCmd("ecchisketchy", ecchisketchy);

	RegConsoleCmd("fbk2", fubuki_coffin_dance2);
	RegConsoleCmd("krn2", korofunk2);
	RegConsoleCmd("haato2", hachamachama2);
	RegConsoleCmd("haator2", hachamaremix2);
	RegConsoleCmd("coco2", coco2);
	RegConsoleCmd("soran2", soran2);

	RegConsoleCmd("test", test);

	HookEvent("tank_spawn", Event_TankSpawn, EventHookMode_Post);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	HookEvent("mission_lost", Event_MissionLost,EventHookMode_Post);
	HookEvent("ability_use", Event_AbilityUse,EventHookMode_Post);


	//Finale Start

		//mall,carnival,no mercy
		HookEvent("finale_start", PlayFinaleStartMusic, EventHookMode_PostNoCopy);

		//mall,carnival,the parish
		HookEvent("finale_radio_start", PlayFinaleStartMusic, EventHookMode_PostNoCopy);

	//Escape

		//carnival,swamp
		//"finale_vehicle_incoming", EventCallback, EventHookMode_PostNoCopy);
		HookEvent("finale_escape_start", Event_FinaleEscape, EventHookMode_PostNoCopy);

		//mall,carnival,swamp,the parish
		//HookEvent("finale_vehicle_ready", Event_FinaleEscape, EventHookMode_PostNoCopy);

	HookEvent("finale_bridge_lowering", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_escape_start", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_radio_damaged", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_radio_start", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_rush", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_start", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_win", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_vehicle_incoming", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_vehicle_leaving", EventCallback, EventHookMode_PostNoCopy);
	HookEvent("finale_vehicle_ready", EventCallback, EventHookMode_PostNoCopy);

	//HookEvent("witch_spawn", Event_WitchSpawn, EventHookMode_Post);

	LogMessage("AWOO SERVER PLUGIN STARTED")
}

public OnMapStart()
{

	PrecacheSound(FUBUKI_COFFIN_DANCE);
	PrecacheSound(KOROFUNK);
	PrecacheSound(HACHAMACHAMA);
	PrecacheSound(HACHAMAREMIX);
	PrecacheSound(DRAGONOP);
	PrecacheSound(SORAN);
	PrecacheSound(YAGOOTEME);

	PrecacheSound(sPekoAttack[0]);
	PrecacheSound(sPekoAttack[1]);
	PrecacheSound(sPekoAttack[2]);
	PrecacheSound(sPekoAttack[3]);

	AddFileToDownloadsTable("sound/Awoo/fubuki_coffin_dance.mp3");
	AddFileToDownloadsTable("sound/Awoo/korofunk.mp3");
	AddFileToDownloadsTable("sound/Awoo/hachamachama.mp3");
	AddFileToDownloadsTable("sound/Awoo/hachamaremix.mp3");
	AddFileToDownloadsTable("sound/Awoo/dragonop.mp3");
	AddFileToDownloadsTable("sound/Awoo/soran.mp3");
	AddFileToDownloadsTable("sound/Awoo/yagooteme.mp3");
	AddFileToDownloadsTable("sound/Awoo/ahahahaha.mp3");
	AddFileToDownloadsTable("sound/Awoo/ecchisketchy.mp3");
	AddFileToDownloadsTable("sound/Awoo/pekopekopeko.mp3");
	AddFileToDownloadsTable("sound/Awoo/pekopekopeko2.mp3");

	PrintToServer("SOUND PRECACHE TIME");
}

public Event_TankSpawn(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	static tank;
	tank = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if (tank != 0)
	{
		new Float:pos[3];
		GetClientAbsOrigin(tank, pos);

		EmitAmbientSound(KOROFUNK, pos, tank);
		EmitAmbientSound(KOROFUNK, pos, tank);
		EmitAmbientSound(KOROFUNK, pos, tank);
		EmitAmbientSound(KOROFUNK, pos, tank);
		EmitAmbientSound(KOROFUNK, pos, tank);
		EmitAmbientSound(KOROFUNK, pos, tank);
		SetEntityHealth(tank, 9000);


		LogMessage("EVENT TANK SPAWN PLAYED")
	}
	
}

public Event_PlayerDeath(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	static player;
	player = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if (player > 0)
	{
		switch(GetClientTeam(player))
		{
			case 2:
			{
				new Float:pos[3];
				GetClientAbsOrigin(player, pos);	

				EmitAmbientSound(FUBUKI_COFFIN_DANCE, pos, player);
				EmitAmbientSound(FUBUKI_COFFIN_DANCE, pos, player);

				LogMessage("EVENT PLAYER INCAPACITATED PLAYED")
			}
				
			case 3:
			{
				switch(GetEntProp(player, Prop_Send, "m_zombieClass"))
				{
					case ZOMBIECLASS_SPITTER:
					{
						new Float:pos[3];
						GetClientAbsOrigin(player, pos);

						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);
						EmitAmbientSound(YAGOOTEME, pos,SOUND_FROM_PLAYER);


						LogMessage("EVENT SPITTER KILLED PLAYED")
					}
						
				}
			}
				
		}
//
//		if (GetClientTeam(player) == 2)
//		{
//			new Float:pos[3];
//			GetClientAbsOrigin(player, pos);	
//
//			EmitAmbientSound(FUBUKI_COFFIN_DANCE, pos, player);
//			EmitAmbientSound(FUBUKI_COFFIN_DANCE, pos, player);
//
//			LogMessage("EVENT PLAYER INCAPACITATED PLAYED")
//		}

	}
}

public Event_AbilityUse(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	static player;
	player = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	static ability;

	if (player != 0)
	{

		switch(GetEntProp(player, Prop_Send, "m_zombieClass"))
			{
				case ZOMBIECLASS_SPITTER:
				{
					new Float:pos[3];
					GetClientAbsOrigin(player, pos);

					int i;
					i = GetRandomInt(0,PEKO_ATTACK_SIZE-1);

					EmitAmbientSound(sPekoAttack[i], pos, player);
					EmitAmbientSound(sPekoAttack[i], pos, player);

					LogMessage("EVENT SPITTER ABILITY")
				}
			
		}
		
	}
}

public Event_MissionLost(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	EmitSoundToAll(FUBUKI_COFFIN_DANCE);
}

public PlayFinaleStartMusic(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	if (!b_finaleStarted)
	{
		EmitSoundToAll(DRAGONOP);
		EmitSoundToAll(DRAGONOP);
		b_finaleStarted = true;
	}
}

public Event_FinaleEscape(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{

	switch(GetRandomInt(0,2))
	{
		case 0:
			EmitSoundToAll(HACHAMACHAMA);
		case 1:
			EmitSoundToAll(HACHAMAREMIX);
		case 2:
			EmitSoundToAll(SORAN);
	}	



}


//COMMANDS FOR TESTING

//GLOBAL SOUNDS

public Action fubuki_coffin_dance(int client, int args)
{
    EmitSoundToAll(FUBUKI_COFFIN_DANCE);
 	LogMessage("COMMAND FUBUKI COFFIN DANCE PLAYED");

    return Plugin_Handled;
}

public Action korofunk(int client, int args)
{
    EmitSoundToAll(KOROFUNK);
 	LogMessage("COMMAND KOROFUNK PLAYED");

    return Plugin_Handled;
}

public Action hachamachama(int client, int args)
{
    EmitSoundToAll(HACHAMACHAMA);
 	LogMessage("COMMAND HACHAMACHAMA PLAYED");

    return Plugin_Handled;
}

public Action hachamaremix(int client, int args)
{
    EmitSoundToAll(HACHAMAREMIX);
 	LogMessage("COMMAND HACHAMAREMIX PLAYED");

    return Plugin_Handled;
}

public Action coco(int client, int args)
{
    EmitSoundToAll(DRAGONOP);
    EmitSoundToAll(DRAGONOP);
 	LogMessage("COMMAND COCO PLAYED");

    return Plugin_Handled;
}

public Action soran(int client, int args)
{
    EmitSoundToAll(SORAN);
 	LogMessage("COMMAND SORAN PLAYED");

    return Plugin_Handled;
}



public Action ecchisketchy(int client, int args)
{
    EmitSoundToAll(sPekoAttack[1]);
 	LogMessage("COMMAND ECCHISKETCHY PLAYED");

    return Plugin_Handled;
}

public Action test(int client, int args)
{
    EmitSoundToAll(DRAGONOP,SOUND_FROM_PLAYER,SNDCHAN_AUTO,140);
 	LogMessage("COMMAND TEST PLAYED");

    return Plugin_Handled;
}


//FROM PLAYER SOUNDS

public Action fubuki_coffin_dance2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(FUBUKI_COFFIN_DANCE,pos,client);
    EmitAmbientSound(FUBUKI_COFFIN_DANCE,pos,client);
 	LogMessage("COMMAND FUBUKI COFFIN DANCE2 PLAYED");

    return Plugin_Handled;
}

public Action korofunk2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(KOROFUNK,pos,client);
    EmitAmbientSound(KOROFUNK,pos,client);
 	LogMessage("COMMAND KOROFUNK2 PLAYED");

    return Plugin_Handled;
}

public Action hachamachama2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(HACHAMACHAMA,pos,client);
    EmitAmbientSound(HACHAMACHAMA,pos,client);
 	LogMessage("COMMAND HACHAMACHAMA2 PLAYED");

    return Plugin_Handled;
}

public Action hachamaremix2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(HACHAMAREMIX,pos,client);
    EmitAmbientSound(HACHAMAREMIX,pos,client);
 	LogMessage("COMMAND HACHAMAREMIX2 PLAYED");

    return Plugin_Handled;
}

public Action coco2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(DRAGONOP,pos,client);
    EmitAmbientSound(DRAGONOP,pos,client);
    EmitAmbientSound(DRAGONOP,pos,client);
 	LogMessage("COMMAND COCO2 PLAYED");

    return Plugin_Handled;
}

public Action soran2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(SORAN,pos,client);
 	LogMessage("COMMAND SORAN2 PLAYED");

    return Plugin_Handled;
}




public EventCallback(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (b_logEvents)
	{
		PrintToChatAll("\x04Event \"%s\" ", name);
	}
	
}


public Action startLog(int client, int args)
{
    b_logEvents = true;
    PrintToChatAll("\x04Showing Events ");

    return Plugin_Handled;
}

public Action stopLog(int client, int args)
{
    b_logEvents = false;
    PrintToChatAll("\x04Not Showing Events ");

    return Plugin_Handled;
}

