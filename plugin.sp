//Precache sounds in OnMapStart()
//client = entity
//EmitSound - level (volume) should be left at 0. Higher values lower the sound

#include <sourcemod>
#include <sdktools>

#define FUBUKI_COFFIN_DANCE "fubuki_coffin_dance.mp3"
#define KOROFUNK "korofunk.mp3"
 
public Plugin myinfo =
{
	name = "AWOO SERVER PLUGIN",
	author = "ZRMDSXA",
	description = "Plugin for Awoo Server",
	version = "1.0",
	url = ""
};
 
public void OnPluginStart()
{
	PrintToServer("AWOO SERVER PLUGGIN");

	RegConsoleCmd("fbk", fubuki_coffin_dance);
	RegConsoleCmd("krn", korofunk);

	RegConsoleCmd("fbk2", fubuki_coffin_dance2);
	RegConsoleCmd("krn2", korofunk2);

	HookEvent("tank_spawn", Event_TankSpawn, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);

	


	
	LogMessage("AWOO SERVER PLUGIN STARTED")
}

public OnMapStart()
{

	PrecacheSound("fubuki_coffin_dance.mp3");
	PrecacheSound("korofunk.mp3");

	AddFileToDownloadsTable("sound/fubuki_coffin_dance.mp3");
	AddFileToDownloadsTable("sound/korofunk.mp3");

	PrintToServer("SOUND PRECACHE TIME");
}

public Event_TankSpawn(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	static tank;
	tank = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	new Float:pos[3];
	GetClientAbsOrigin(tank, pos);

	EmitAmbientSound(KOROFUNK, pos, tank,0);

	LogMessage("EVENT TANK SPAWN PLAYED")
}

public Event_PlayerDeath(Handle:hEvent, const String:sEventName[], bool:bDontBroadcast)
{
	static player;
	player = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	new Float:pos[3];
	GetClientAbsOrigin(player, pos);	

	EmitAmbientSound(FUBUKI_COFFIN_DANCE, pos, player);

	LogMessage("EVENT PLAYER INCAPACITATED PLAYED")
}


//COMMANDS FOR TESTING

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

public Action fubuki_coffin_dance2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(FUBUKI_COFFIN_DANCE,pos,client);
 	LogMessage("COMMAND FUBUKI COFFIN DANCE2 PLAYED");

    return Plugin_Handled;
}

public Action korofunk2(int client, int args)
{
	new Float:pos[3];
	GetClientAbsOrigin(client, pos);

    EmitAmbientSound(KOROFUNK,pos,client,0);
 	LogMessage("COMMAND KOROFUNK2 PLAYED");

    return Plugin_Handled;
}