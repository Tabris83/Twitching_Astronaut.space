//Satellite Boot Script - Auto Circularize at Apoapsis
Print "Waiting until Released".
wait until ship:modulesnamed("kOSProcessor"):length = 1 and kuniverse:ActiveVessel:name = ship:name.
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SAS OFF. RCS OFF. GEAR OFF. LIGHTS OFF.  CLEARVECDRAWS().
clearscreen. set tv to 0. lock throttle to tv.
function thS{set kp to 0.1. set ki to 0.01. set kd to 0.05. Set PID to PIDLOOP(kp,ki,kd). set pid:setpoint to 30. set pid:maxoutput to 0.1. set pid:minoutput to -0.1.
  RETURN max(0,min(1,tv+pid:update(time:seconds,eta:apoapsis))).}
Function OrbPeratAlt {return SQRT(((4 * CONSTANT:PI ^2) * ((SHIP:APOAPSIS + Body:Radius)^3))/ BODY:MU).}
if eta:apoapsis > 180 warpto(time:seconds + (ETA:apoapsis - 60)). wait 3.
ship:modulesnamed("moduleEnginesFX")[0]:doevent("Activate Engine"). set TarP to OrbPeratAlt().
until obt:period >= TarP {lock steering to prograde. set tv to thS(). print obt:period - TarP at (0,0).}
set ship:control:pilotmainthrottle to 0.
panels on.
list parts in parts. for p in parts{if p:hasmodule("ModuleDeployableAntenna") p:GETMODULE("ModuleDeployableAntenna"):doaction("Toggle Antenna",true).}
ship:modulesnamed("moduleEnginesFX")[0]:doevent("Shutdown Engine"). wait 2.
set kuniverse:ActiveVessel to VESSEL("" + core:tag + "").
