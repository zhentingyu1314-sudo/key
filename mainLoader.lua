
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local _g8b3bh75j = function()
    --[[
    Rivals Raging Comp — Delta Mobile Rebuild
    Same void methods, orbit, desync, evasion as original
    No LinoriaLib · No HttpGet · No setfflag · No keypress
    Works on Delta mobile confirmed
    Tap ⚡ to open menu
]]

local Players    = game:GetService((function()
        local a={1077,1441,1298,1610,1350,1519,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local RunService = game:GetService((function()
        local a={1103,1558,1467,1116,1350,1519,1571,1402,1324,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local UIS        = game:GetService((function()
        local a={1142,1532,1350,1519,986,1467,1493,1558,1545,1116,1350,1519,1571,1402,1324,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local Camera     = workspace.CurrentCamera
local LP         = Players.LocalPlayer
local Debris     = game:GetService((function()
        local a={921,1350,1311,1519,1402,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())

-- Camera hook stored for UI status display
local _E = {}; pcall(function() _E = getfenv() end)
local hasHook = type(_E.hookmetamethod) == (function()
        local a={1363,1558,1467,1324,1545,1402,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
local _orbitActive = false

-- ══════════════════════════════════════════════════════════════
-- CONFIG
-- ══════════════════════════════════════════════════════════════
local CFG = {
    -- Void
    VOID_ENABLED        = false,
    VOID_METHOD         = (function()
        local a={1090,1558,1298,1467,1545,1558,1454,453,1129,1558,1467,1467,1350,1441,1402,1467,1376};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),
    VOID_BYPASS_MODE    = (function()
        local a={934,1597,1545,1519,1350,1454,1350,453,1051,1350,1545,1584,1480,1519,1428,1402,1467,1376};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),
    VOID_DRIFT_SPEED    = 9e6,
    VOID_DRIFT_CHAOS    = 0.98,
    VOID_Y_BASE         = 1e10 + (math.random()*10e9 - 5e9) + 7369123,
    VOID_Y_DRIFT_SPEED  = 4e6,
    VOID_Y_DRIFT_RANGE  = 2e9,
    VOID_SCRAMBLE       = true,
    VOID_SCRAMBLE_TIME  = 1.2,
    VOID_ANCHOR_THRESH  = 50,
    VOID_EVADE          = true,
    VOID_EVADE_RADIUS   = 8e9,
    VOID_EVADE_SPEED    = 6e9,
    VOID_EVADE_COOLDOWN = 0.05,
    VOID_EVADE_VERT     = 3e9,
    VOID_EVADE_VERT_BIAS= 0.5,
    VOID_EVADE_FORCE_UP = false,
    VOID_LISSAJOUS_A    = 2,
    VOID_LISSAJOUS_B    = 3,
    VOID_FLICKER_INT    = 0.05,
    VOID_GRAVITY_STR    = 1e8,
    VOID_GHOSTING       = false,
    VOID_GHOSTING_INT   = 0.5,
    VOID_Y_DRIFT_RANGE_V= 10,  -- UI display value (B)
    VOID_SCRAMBLE_INT   = 12,
    VOID_FLICKER_MS     = 5,
    VOID_GRAVITY_M      = 100,

    -- Desync
    DESYNC_ENABLED      = true,
    DESYNC_TICK         = 0.18,
    DESYNC_SPOOF_Y      = 3,
    DESYNC_RADIUS       = 22,
    DESYNC_WANDER_SPEED = 3.5,
    DESYNC_WANDER_CHAOS = 0.4,

    -- Orbit
    ORBIT_ENABLED       = false,
    ORBIT_SPEED         = 5,
    ORBIT_MODE          = (function()
        local a={921,1350,1363,1298,1558,1441,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),
    ORBIT_STABILITY     = 1,
    ORBIT_JITTER        = 0,
    HEIGHT_OFFSET       = 50000,
    ELLIPSE_RATIO       = 0.65,
    MIN_RADIUS          = 200000,
    MAX_RADIUS          = 12e9,
    LOCK_FOV            = 120,
    PREDICTION          = 0.22,
    CAM_LERP_BASE       = 0.12,
    AUTO_LOCK           = false,
    AUTO_LOCK_RADIUS    = 200,
    KILL_HP             = 0,

    -- Kill Notifier
    KILL_NOTIFIER       = true,
    -- Desync standalone
    DESYNC_STANDALONE   = false,

    -- Extras
    SPEED_ENABLED       = false,
    WALK_SPEED          = 35,
    INF_JUMP            = false,
    NOCLIP              = false,
    LOW_GRAVITY         = false,
    GRAVITY_VAL         = 50,
    FPS_BOOST           = false,
}

-- ══════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════
local function clamp(x,a,b) return x<a and a or x>b and b or x end
local function getHRP()
    local c=LP.Character; return c and c:FindFirstChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337,1103,1480,1480,1545,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
end
local function getHum()
    local c=LP.Character; return c and c:FindFirstChildOfClass((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
end

-- ══════════════════════════════════════════════════════════════
-- VOID SYSTEM — exact same logic as original
-- ══════════════════════════════════════════════════════════════
local elapsed         = 0
local voidX           = (math.random()-0.5)*2e8
local voidZ           = (math.random()-0.5)*2e8
local voidYOffset     = 0
local voidYDir        = 1
local voidDirX        = math.random()*2-1
local voidDirZ        = math.random()*2-1
local voidScrambleT   = 0
local voidEvadeCD     = 0
local intendedVoidPos = Vector3.new(voidX, CFG.VOID_Y_BASE, voidZ)
local desyncTimer     = 0
local spoofAngle      = math.random()*math.pi*2
local spoofAngleDir   = (math.random()>0.5) and 1 or -1
local spoofBaseX,spoofBaseZ = 0,0
local fakeGroundPos   = Vector3.new(0, CFG.DESYNC_SPOOF_Y, 0)
local inFlicker       = false
local voidConn        = nil

local function computeVoidDriftDir(t)
    local nx,nz,amp,freq = 0,0,1,0.0001
    for i=1,4 do
        nx=nx+math.noise(t*freq,0)*amp
        nz=nz+math.noise(0,t*freq)*amp
        freq=freq*2.37; amp=amp*0.5
    end
    local sp=t*0.00073
    nx=nx+math.noise(sp+13.7,7.3)*0.3
    nz=nz+math.noise(sp+31.1,17.9)*0.3
    local cp=t*0.00213
    nx=nx+math.sin(cp)*math.cos(cp*1.618)*0.2
    nz=nz+math.cos(cp*0.618)*math.sin(cp*2.718)*0.2
    local len=math.sqrt(nx*nx+nz*nz)
    if len<0.001 then
        local a=t*3.14159*0.1; return math.cos(a),math.sin(a)
    end
    return nx/len,nz/len
end

local function stepVoidDrift(dt)
    local p=Vector3.new(voidX,CFG.VOID_Y_BASE+voidYOffset,voidZ)
    local m=CFG.VOID_METHOD
    if m==(function()
        local a={1116,1545,1298,1311,1441,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then return p
    elseif m==(function()
        local a={921,1519,1402,1363,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local dx,dz=computeVoidDriftDir(elapsed)
        voidDirX=voidDirX+(dx-voidDirX)*CFG.VOID_DRIFT_CHAOS*dt*10
        voidDirZ=voidDirZ+(dz-voidDirZ)*CFG.VOID_DRIFT_CHAOS*dt*10
        voidX=voidX+voidDirX*CFG.VOID_DRIFT_SPEED*dt
        voidZ=voidZ+voidDirZ*CFG.VOID_DRIFT_SPEED*dt
        voidYOffset=voidYOffset+voidYDir*CFG.VOID_Y_DRIFT_SPEED*dt
        if math.abs(voidYOffset)>=CFG.VOID_Y_DRIFT_RANGE then voidYDir=-voidYDir end
        return Vector3.new(voidX,CFG.VOID_Y_BASE+voidYOffset,voidZ)
    elseif m==(function()
        local a={908,1389,1298,1480,1545,1402,1324};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        voidX=voidX+(math.random()-0.5)*CFG.VOID_DRIFT_SPEED*dt*5
        voidZ=voidZ+(math.random()-0.5)*CFG.VOID_DRIFT_SPEED*dt*5
        voidYOffset=voidYOffset+(math.random()-0.5)*CFG.VOID_Y_DRIFT_SPEED*dt*5
        return Vector3.new(voidX,CFG.VOID_Y_BASE+voidYOffset,voidZ)
    elseif m==(function()
        local a={908,1402,1519,1324,1441,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1e9; return Vector3.new(voidX+math.cos(elapsed*2)*r,CFG.VOID_Y_BASE+voidYOffset,voidZ+math.sin(elapsed*2)*r)
    elseif m==(function()
        local a={1116,1493,1402,1519,1298,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1e9*(1+math.sin(elapsed)); return Vector3.new(voidX+math.cos(elapsed*3)*r,CFG.VOID_Y_BASE+voidYOffset,voidZ+math.sin(elapsed*3)*r)
    elseif m==(function()
        local a={1025,1402,1532,1532,1298,1415,1480,1558,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=2e9; return Vector3.new(voidX+math.sin(elapsed*CFG.VOID_LISSAJOUS_A)*r,CFG.VOID_Y_BASE+voidYOffset,voidZ+math.sin(elapsed*CFG.VOID_LISSAJOUS_B)*r)
    elseif m==(function()
        local a={1077,1350,1519,1441,1402,1467,453,1051,1480,1402,1532,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed*0.1; return Vector3.new(voidX+math.noise(t,0)*5e9,CFG.VOID_Y_BASE+voidYOffset,voidZ+math.noise(0,t)*5e9)
    elseif m==(function()
        local a={947,1441,1402,1324,1428,1350,1519,453,1155,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local flip=(tick()%(CFG.VOID_FLICKER_INT*2)<CFG.VOID_FLICKER_INT)
        return flip and Vector3.new(voidX,CFG.VOID_Y_BASE,voidZ) or Vector3.new(-voidX,CFG.VOID_Y_BASE+1e9,-voidZ)
    elseif m==(function()
        local a={960,1519,1298,1571,1402,1545,1610,453,1168,1350,1441,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed*0.5; local r=CFG.VOID_GRAVITY_STR*(1+math.sin(t))
        return Vector3.new(voidX+math.cos(t)*r,CFG.VOID_Y_BASE+math.sin(t*0.7)*r,voidZ+math.sin(t)*r)
    elseif m==(function()
        local a={973,1350,1441,1402,1597};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1e9; local t=elapsed*2
        return Vector3.new(voidX+math.cos(t)*r,CFG.VOID_Y_BASE+voidYOffset+math.sin(t*0.5)*r,voidZ+math.sin(t)*r)
    elseif m==(function()
        local a={947,1402,1376,1558,1519,1350,453,765};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1.5e9; local t=elapsed*1.5
        return Vector3.new(voidX+math.sin(t)*r,CFG.VOID_Y_BASE+voidYOffset,voidZ+math.sin(t)*math.cos(t)*r)
    elseif m==(function()
        local a={1129,1480,1519,1467,1298,1337,1480};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=2e9*math.abs(math.sin(elapsed)); local t=elapsed*5
        return Vector3.new(voidX+math.cos(t)*r,CFG.VOID_Y_BASE+math.sin(elapsed*2)*1e9,voidZ+math.sin(t)*r)
    elseif m==(function()
        local a={895,1558,1545,1545,1350,1519,1363,1441,1610};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed
        local r=(math.exp(math.sin(t))-2*math.cos(4*t)+math.sin((2*t-math.pi)/24)^5)*5e8
        return Vector3.new(voidX+math.sin(t)*r,CFG.VOID_Y_BASE+math.cos(t)*r,voidZ+math.sin(t*0.5)*r)
    elseif m==(function()
        local a={921,1480,1558,1311,1441,1350,453,973,1350,1441,1402,1597};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1e9; local t=elapsed*3; local off=(tick()%1<0.5) and 1 or -1
        return Vector3.new(voidX+math.cos(t)*r*off,CFG.VOID_Y_BASE+math.sin(t)*5e8,voidZ+math.sin(t)*r*off)
    elseif m==(function()
        local a={908,1389,1298,1480,1545,1402,1324,453,1116,1493,1389,1350,1519,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=2e9; local t1,t2=elapsed*2,elapsed*1.3
        return Vector3.new(voidX+math.sin(t1)*math.cos(t2)*r,CFG.VOID_Y_BASE+math.sin(t1)*math.sin(t2)*r,voidZ+math.cos(t1)*r)
    elseif m==(function()
        local a={1090,1558,1298,1467,1545,1558,1454,453,1129,1558,1467,1467,1350,1441,1402,1467,1376};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=1e11*(math.random()>0.5 and 1 or -1)
        local j=Vector3.new((math.random()-0.5)*2e9,(math.random()-0.5)*2e8,(math.random()-0.5)*2e9)
        return Vector3.new(voidX+r,CFG.VOID_Y_BASE+j.Y,voidZ+r)+j
    elseif m==(function()
        local a={947,1519,1298,1324,1545,1298,1441,453,921,1350,1532,1610,1467,1324};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed*5
        local x=math.sin(t)+math.sin(t*2.1)/2+math.sin(t*3.2)/4
        local z=math.cos(t)+math.cos(t*2.2)/2+math.cos(t*3.1)/4
        return Vector3.new(voidX+x*1e10,CFG.VOID_Y_BASE+math.sin(t*10)*1e9,voidZ+z*1e10)
    elseif m==(function()
        local a={934,1597,1545,1519,1350,1454,1350,453,921,1350,1532,1610,1467,1324};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed*15; local r=1e12
        return Vector3.new(voidX+math.sin(t)*r,CFG.VOID_Y_BASE+math.cos(t*1.5)*r*0.1,voidZ+math.cos(t)*r)
    elseif m==(function()
        local a={1090,1558,1298,1467,1545,1558,1454,453,1064,1532,1324,1402,1441,1441,1298,1545,1402,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local t=elapsed*50; local r=1e11*math.sin(t)
        return Vector3.new(voidX+r,CFG.VOID_Y_BASE+math.cos(t)*1e10,voidZ+r)
    elseif m==(function()
        local a={947,1519,1298,1454,1350,453,1116,1428,1402,1493};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        if tick()%0.1<0.05 then return Vector3.new(voidX*2,CFG.VOID_Y_BASE+1e11,voidZ*2) end
        return Vector3.new(voidX,CFG.VOID_Y_BASE,voidZ)
    end
    return p
end

local groundY = 0  -- cached real ground Y

local function updateGroundY()
    -- Raycast from a safe position to find real map ground
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    if LP.Character then rp.FilterDescendantsInstances = {LP.Character} end
    -- Cast from sky down to find ground
    local ray = workspace:Raycast(Vector3.new(0, 1000, 0), Vector3.new(0,-2000,0), rp)
    if ray then groundY = ray.Position.Y + 3 end
end

local groundUpdateT = 0
local function stepSpoofPos(dt)
    -- Update ground Y every 5 seconds
    groundUpdateT = groundUpdateT + dt
    if groundUpdateT > 5 then groundUpdateT = 0; task.spawn(updateGroundY) end

    local nv=math.noise(elapsed*0.8,42.0)
    spoofAngle=spoofAngle+spoofAngleDir*(1.5+nv*CFG.DESYNC_WANDER_CHAOS)*CFG.DESYNC_WANDER_SPEED*dt
    if math.noise(elapsed*0.3,7.7)>0.6 then spoofAngleDir=-spoofAngleDir end
    local r=CFG.DESYNC_RADIUS*(0.5+0.5*math.abs(math.noise(elapsed*0.5,0)))
    -- Use real ground Y so server thinks we're standing on the map
    fakeGroundPos=Vector3.new(spoofBaseX+math.cos(spoofAngle)*r, groundY, spoofBaseZ+math.sin(spoofAngle)*r)
end

local function runDesyncFlicker()
    if inFlicker then return end
    local hrp=getHRP(); if not hrp then return end
    inFlicker=true
    local savedVoid=intendedVoidPos

    -- Snap to fake ground position (server sees us here briefly)
    pcall(function()
        hrp.CFrame=CFrame.new(fakeGroundPos)
        hrp.AssemblyLinearVelocity=Vector3.new(0,-0.01,0)
    end)

    -- Return to void after 1 physics frame
    task.delay(0, function()
        local hrp2=getHRP()
        if hrp2 and CFG.VOID_ENABLED then
            pcall(function()
                hrp2.CFrame=CFrame.new(savedVoid)
                hrp2.AssemblyLinearVelocity=Vector3.zero
            end)
        end
        inFlicker=false
    end)
end

local function checkVoidEvasion()
    if not CFG.VOID_EVADE or voidEvadeCD>0 then return end
    local minDist,threatVec=math.huge,Vector3.new()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hrp=p.Character:FindFirstChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337,1103,1480,1480,1545,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
            local hum=p.Character:FindFirstChildOfClass((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
            if hrp and hum and hum.Health>0 then
                local vel=hrp.AssemblyLinearVelocity
                local pred=hrp.Position+vel*0.5
                local d=(pred-intendedVoidPos).Magnitude
                if d<minDist then minDist=d; threatVec=(pred-intendedVoidPos).Unit end
            end
        end
    end
    if minDist<CFG.VOID_EVADE_RADIUS then
        local esc=threatVec*-1
        local tl=clamp(1-(minDist/CFG.VOID_EVADE_RADIUS),0,1)
        voidX=voidX+esc.X*CFG.VOID_EVADE_SPEED*(1+tl*2)
        voidZ=voidZ+esc.Z*CFG.VOID_EVADE_SPEED*(1+tl*2)
        if math.random()<(CFG.VOID_EVADE_VERT_BIAS+tl*0.2) then
            local vd=CFG.VOID_EVADE_FORCE_UP and 1 or (math.random()>0.5 and 1 or -1)
            voidYOffset=voidYOffset+vd*CFG.VOID_EVADE_VERT
        end
        voidEvadeCD=CFG.VOID_EVADE_COOLDOWN*(1-tl*0.3)
    end
end

local function lockToVoid(dt)
    if inFlicker then return end
    if voidEvadeCD>0 then voidEvadeCD=voidEvadeCD-dt end
    checkVoidEvasion()
    intendedVoidPos=stepVoidDrift(dt)
    local targetPos=intendedVoidPos
    -- Anti-detect micro offset
    if CFG.VOID_METHOD~=(function()
        local a={1116,1545,1298,1311,1441,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local mt=tick()*1000
        targetPos=targetPos+Vector3.new(math.sin(mt*0.1)*50,math.sin(mt*0.07)*20,math.cos(mt*0.13)*50)
    end
    local hrp=getHRP(); if not hrp then return end
    local byp=CFG.VOID_BYPASS_MODE
    if byp==(function()
        local a={1155,1350,1441,1480,1324,1402,1545,1610};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        pcall(function() hrp.AssemblyLinearVelocity=(targetPos-hrp.Position)*100 end)
    elseif byp==(function()
        local a={908,947,1519,1298,1454,1350,453,1480,1467,1441,1610};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        pcall(function() hrp.CFrame=CFrame.new(targetPos) end)
    elseif byp==(function()
        local a={973,1610,1311,1519,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        pcall(function() hrp.CFrame=CFrame.new(targetPos); hrp.AssemblyLinearVelocity=Vector3.new(0,0.01,0) end)
    elseif byp==(function()
        local a={1077,1389,1610,1532,1402,1324,1532,453,895,1610,1493,1298,1532,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        pcall(function()
            hrp.CFrame=CFrame.new(targetPos)
            hrp.AssemblyLinearVelocity=Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))*1e5
        end)
    else -- Extreme Networking (default) — most aggressive
        pcall(function()
            hrp.CFrame=CFrame.new(targetPos)
            hrp.AssemblyLinearVelocity=Vector3.zero
            hrp.AssemblyAngularVelocity=Vector3.zero
        end)
        -- Velocity chaos every ~10 frames to confuse server-side interpolation
        if math.random(1,10)==1 then
            pcall(function()
                hrp.AssemblyLinearVelocity=Vector3.new(
                    (math.random()-0.5)*2e7,
                    (math.random()-0.5)*2e7,
                    (math.random()-0.5)*2e7
                )
            end)
        end
    end

    if CFG.DESYNC_ENABLED then
        stepSpoofPos(dt)
        desyncTimer=desyncTimer+dt
        if desyncTimer>=CFG.DESYNC_TICK then
            desyncTimer=0
            task.spawn(runDesyncFlicker)
        end
    end
end

local function startVoid()
    if voidConn then voidConn:Disconnect(); voidConn=nil end

    -- Grab network ownership so server accepts our position writes
    task.spawn(function()
        local hrp=getHRP()
        if hrp then
            pcall(function() hrp:SetNetworkOwner(LP) end)
        end
        -- Initial ground Y scan for desync
        task.spawn(updateGroundY)
    end)

    -- Reset void starting point to current player position
    local hrp=getHRP()
    if hrp then
        local pos=hrp.Position
        voidX=pos.X; voidZ=pos.Z
        intendedVoidPos=Vector3.new(voidX,CFG.VOID_Y_BASE,voidZ)
        spoofBaseX=pos.X; spoofBaseZ=pos.Z
    end

    voidConn=RunService.Heartbeat:Connect(function(dt)
        if not CFG.VOID_ENABLED then voidConn:Disconnect(); voidConn=nil; return end
        elapsed=elapsed+dt
        lockToVoid(dt)
    end)
end
local function stopVoid()
    if voidConn then voidConn:Disconnect(); voidConn=nil end
end


-- ══════════════════════════════════════════════════════════════
-- KILL NOTIFIER
-- Watches all enemy humanoids for health drops to 0
-- Shows on-screen notification with killer info
-- ══════════════════════════════════════════════════════════════
local killNotifSG = nil
local killQueue   = {}
local notifShowing = false

local function getKillSG()
    if killNotifSG and killNotifSG.Parent then return killNotifSG end
    killNotifSG = Instance.new((function()
        local a={1116,1324,1519,1350,1350,1467,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
    killNotifSG.Name = (function()
        local a={1012,1402,1441,1441,1051,1480,1545,1402,1363};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(); killNotifSG.ResetOnSpawn = false
    killNotifSG.IgnoreGuiInset = true; killNotifSG.DisplayOrder = 998
    pcall(function() killNotifSG.Parent = game:GetService((function()
        local a={908,1480,1519,1350,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end)
    if not killNotifSG.Parent then killNotifSG.Parent = LP:WaitForChild((function()
        local a={1077,1441,1298,1610,1350,1519,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end
    return killNotifSG
end

local function showKillNotif(name)
    local sg = getKillSG()
    local f = Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), sg)
    f.Size = UDim2.new(0,220,0,36); f.Position = UDim2.new(0.5,-110,0,60)
    f.BackgroundColor3 = Color3.fromRGB(20,14,30); f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(160,32,240); f.ZIndex = 10
    Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f).CornerRadius = UDim.new(0,6)
    local icon = Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    icon.Size = UDim2.new(0,30,1,0); icon.BackgroundTransparency = 1
    icon.Text = (function()
        local a={719678,733861};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(); icon.TextSize = 18; icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(255,80,80); icon.ZIndex = 11
    local lbl = Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    lbl.Size = UDim2.new(1,-36,1,0); lbl.Position = UDim2.new(0,32,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = (function()
        local a={934,1441,1402,1454,1402,1467,1298,1545,1350,1337,453,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() .. name
    lbl.TextColor3 = Color3.fromRGB(220,180,255)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 11
    -- Slide in then fade out after 2.5s
    task.delay(2.5, function() f:Destroy() end)
end

local watchedHumanoids = {}

local function watchPlayer(p)
    if not p or p == LP then return end
    local function hookChar(ch)
        if not ch then return end
        local hum = ch:WaitForChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), 5)
        if not hum then return end
        if watchedHumanoids[hum] then return end
        watchedHumanoids[hum] = true
        hum.Died:Connect(function()
            if CFG.KILL_NOTIFIER then
                showKillNotif(p.Name)
            end
            watchedHumanoids[hum] = nil
        end)
    end
    if p.Character then task.spawn(hookChar, p.Character) end
    p.CharacterAdded:Connect(hookChar)
end

for _,p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
Players.PlayerAdded:Connect(watchPlayer)

-- ══════════════════════════════════════════════════════════════
-- STANDALONE DESYNC (works without void)
-- Rapidly flickers HRP between real pos and spoof pos
-- Makes server-side hitbox differ from client visual
-- ══════════════════════════════════════════════════════════════
local desyncOnlyConn = nil
local dsFlicker      = false
local dsAcc          = 0

local function startDesyncOnly()
    if desyncOnlyConn then desyncOnlyConn:Disconnect(); desyncOnlyConn=nil end
    dsAcc = 0; dsFlicker = false
    desyncOnlyConn = RunService.Heartbeat:Connect(function(dt)
        if not CFG.DESYNC_STANDALONE then
            desyncOnlyConn:Disconnect(); desyncOnlyConn=nil; return
        end
        local hrp = getHRP(); if not hrp then return end
        dsAcc = dsAcc + dt
        if dsAcc < CFG.DESYNC_TICK then return end
        dsAcc = 0
        -- Update spoof position wander
        stepSpoofPos(dt)
        if not dsFlicker then
            -- Save real pos, flicker to spoof
            local realCF = hrp.CFrame
            pcall(function()
                hrp.CFrame = CFrame.new(fakeGroundPos)
                hrp.AssemblyLinearVelocity = Vector3.new(0,-0.01,0)
            end)
            task.delay(0.016, function()
                local hrp2 = getHRP()
                if hrp2 and CFG.DESYNC_STANDALONE then
                    pcall(function()
                        hrp2.CFrame = realCF
                        hrp2.AssemblyLinearVelocity = Vector3.zero
                    end)
                end
            end)
        end
        dsFlicker = not dsFlicker
    end)
end

local function stopDesyncOnly()
    if desyncOnlyConn then desyncOnlyConn:Disconnect(); desyncOnlyConn=nil end
end

-- ══════════════════════════════════════════════════════════════
-- ORBIT SYSTEM
-- ══════════════════════════════════════════════════════════════
local orbitAngle  = math.random(0,360)
local orbitConn   = nil
local currentTgt  = nil
local lastVel     = Vector3.new()
local smoothAccel = Vector3.new()
local smoothedPred= nil

local function findBestTarget()
    -- Find by closest distance — works regardless of camera direction
    local best,bestDist=nil,math.huge
    local myHRP=getHRP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local hum=p.Character:FindFirstChildOfClass((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
            local hrp=p.Character:FindFirstChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337,1103,1480,1480,1545,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
            if hum and hrp and hum.Health>CFG.KILL_HP then
                local origin=myHRP and myHRP.Position or Camera.CFrame.Position
                local dist=(origin-hrp.Position).Magnitude
                if dist<bestDist then bestDist=dist; best=p end
            end
        end
    end
    return best,bestDist
end

local function getOrbitOffset(resolvedPos, dt)
    local m=CFG.ORBIT_MODE
    local r_base=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*0.5
    local h=CFG.HEIGHT_OFFSET
    local t=orbitAngle
    if m==(function()
        local a={921,1350,1363,1298,1558,1441,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*(0.5+0.5*math.sin(elapsed*0.3))
        return Vector3.new(math.cos(t)*r,h,math.sin(t)*r)
    elseif m==(function()
        local a={1116,1493,1402,1519,1298,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=CFG.MIN_RADIUS+(elapsed*100000)%(CFG.MAX_RADIUS-CFG.MIN_RADIUS)
        return Vector3.new(math.cos(t)*r,h,math.sin(t)*r)
    elseif m==(function()
        local a={1103,1298,1467,1337,1480,1454};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=CFG.MIN_RADIUS+math.random()*(CFG.MAX_RADIUS-CFG.MIN_RADIUS)
        return Vector3.new(math.cos(t)*r,h+(math.random()-0.5)*20000,math.sin(t)*r)
    elseif m==(function()
        local a={1025,1402,1532,1532,1298,1415,1480,1558,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local rx=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*0.7
        local rz=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*0.3
        return Vector3.new(math.sin(t*3)*rx,h,math.sin(t*2)*rz)
    elseif m==(function()
        local a={973,1350,1441,1402,1597};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        return Vector3.new(math.cos(t)*r_base,h+math.sin(t*2)*50000,math.sin(t)*r_base)
    elseif m==(function()
        local a={947,1402,1376,1558,1519,1350,453,765};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        return Vector3.new(math.sin(t)*r_base,h,math.sin(t)*math.cos(t)*r_base)
    elseif m==(function()
        local a={1077,1558,1441,1532,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local pr=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*(0.5+0.5*math.sin(elapsed*5))
        return Vector3.new(math.cos(t)*pr,h,math.sin(t)*pr)
    elseif m==(function()
        local a={1129,1480,1519,1467,1298,1337,1480};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local r=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*(0.3+0.7*math.abs(math.sin(elapsed*2)))
        return Vector3.new(math.cos(t*3)*r,h+math.sin(elapsed*10)*100000,math.sin(t*3)*r)
    elseif m==(function()
        local a={895,1558,1545,1545,1350,1519,1363,1441,1610};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local br=(math.exp(math.sin(t))-2*math.cos(4*t)+math.sin((2*t-math.pi)/24)^5)*(CFG.MIN_RADIUS/1000000)
        return Vector3.new(math.sin(t)*br,h+math.cos(t)*br*0.3,math.sin(t*0.5)*br)
    elseif m==(function()
        local a={1090,1558,1298,1467,1545,1558,1454,453,1064,1519,1311,1402,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local qr=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*(0.5+0.5*math.sin(elapsed*13))
        local qp=math.sin(elapsed*7)*math.pi
        return Vector3.new(math.cos(t+qp)*qr,h+math.sin(qp*2)*50000,math.sin(t+qp)*qr)
    elseif m==(function()
        local a={973,1610,1493,1350,1519,453,934,1441,1441,1402,1493,1545,1402,1324,1298,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() then
        local rx=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*CFG.ELLIPSE_RATIO
        local rz=CFG.MIN_RADIUS+(CFG.MAX_RADIUS-CFG.MIN_RADIUS)*(1-CFG.ELLIPSE_RATIO)
        return Vector3.new(math.cos(t)*rx,h,math.sin(t)*rz)
    end
    -- Default fallback
    return Vector3.new(math.cos(t)*r_base,h,math.sin(t)*r_base)
end

local function startOrbit()
    if orbitConn then orbitConn:Disconnect(); orbitConn=nil end
    _orbitActive = true
    currentTgt   = nil
    -- Force scriptable so we own the camera
    pcall(function() Camera.CameraType = Enum.CameraType.Scriptable end)

    orbitConn = RunService.Heartbeat:Connect(function(dt)
        if not CFG.ORBIT_ENABLED then
            orbitConn:Disconnect(); orbitConn=nil
            _orbitActive = false; return
        end

        elapsed = elapsed + dt

        -- Force scriptable every frame (game tries to reset it)
        pcall(function()
            if Camera.CameraType ~= Enum.CameraType.Scriptable then
                Camera.CameraType = Enum.CameraType.Scriptable
            end
        end)

        -- Find target every frame — instant response
        if not currentTgt or not currentTgt.Character
        or not currentTgt.Character:FindFirstChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337,1103,1480,1480,1545,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) then
            currentTgt = findBestTarget()
        end
        if not currentTgt then return end

        local tch  = currentTgt.Character
        local hrp  = tch and tch:FindFirstChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337,1103,1480,1480,1545,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
        local hum  = tch and tch:FindFirstChildOfClass((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
        if not hrp or not hum or hum.Health <= 0 then
            currentTgt = nil; return
        end

        local vel         = hrp.AssemblyLinearVelocity
        local resolvedPos = hrp.Position + vel * CFG.PREDICTION
        orbitAngle        = orbitAngle + CFG.ORBIT_SPEED * dt

        local offset   = getOrbitOffset(resolvedPos, dt)
        local jitter   = Vector3.new(
            (math.random()-0.5)*2*CFG.ORBIT_JITTER,
            (math.random()-0.5)*2*CFG.ORBIT_JITTER,
            (math.random()-0.5)*2*CFG.ORBIT_JITTER
        )
        local camPos   = resolvedPos + offset + jitter
        local targetCF = CFrame.lookAt(camPos, resolvedPos)
        local lerpF    = clamp(CFG.CAM_LERP_BASE + vel.Magnitude*0.004, CFG.CAM_LERP_BASE, 0.45)

        pcall(function()
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, lerpF * CFG.ORBIT_STABILITY)
        end)
    end)
end

local function stopOrbit()
    if orbitConn then orbitConn:Disconnect(); orbitConn=nil end
    _orbitActive = false
    pcall(function()
        Camera.CameraType = Enum.CameraType.Custom
        local hum = getHum()
        if hum then Camera.CameraSubject = hum end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- EXTRAS
-- ══════════════════════════════════════════════════════════════
local speedConn,noclipConn,ijConn

local function applySpeed()
    if speedConn then speedConn:Disconnect(); speedConn=nil end
    local h=getHum(); if h then pcall(function() h.WalkSpeed=CFG.SPEED_ENABLED and CFG.WALK_SPEED or 16 end) end
    if not CFG.SPEED_ENABLED then return end
    speedConn=RunService.Heartbeat:Connect(function()
        if not CFG.SPEED_ENABLED then speedConn:Disconnect(); speedConn=nil; return end
        local hum=getHum(); if hum and hum.WalkSpeed~=CFG.WALK_SPEED then pcall(function() hum.WalkSpeed=CFG.WALK_SPEED end) end
    end)
end

local function startNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    noclipConn=RunService.Stepped:Connect(function()
        if not CFG.NOCLIP then noclipConn:Disconnect(); noclipConn=nil; return end
        local c=LP.Character; if not c then return end
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA((function()
        local a={895,1298,1532,1350,1077,1298,1519,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) then pcall(function() p.CanCollide=false end) end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
end

local function startIJ()
    if ijConn then ijConn:Disconnect(); ijConn=nil end
    ijConn=UIS.JumpRequest:Connect(function()
        if not CFG.INF_JUMP then ijConn:Disconnect(); ijConn=nil; return end
        local h=getHum(); if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end)
end

local origGravity=workspace.Gravity
local function applyGravity()
    pcall(function() workspace.Gravity=CFG.LOW_GRAVITY and CFG.GRAVITY_VAL or origGravity end)
end

-- FPS Boost
local function applyFPSBoost()
    pcall(function()
        local l=game:GetService((function()
        local a={1025,1402,1376,1389,1545,1402,1467,1376};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
        l.GlobalShadows=false; l.FogEnd=9e9; l.Brightness=0
        workspace.Terrain.WaterWaveSize=0; workspace.Terrain.WaterWaveSpeed=0
        for _,v in ipairs(l:GetChildren()) do
            if v:IsA((function()
        local a={895,1441,1558,1519,934,1363,1363,1350,1324,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={1116,1558,1467,1103,1298,1610,1532,934,1363,1363,1350,1324,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={908,1480,1441,1480,1519,908,1480,1519,1519,1350,1324,1545,1402,1480,1467,934,1363,1363,1350,1324,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={895,1441,1480,1480,1454,934,1363,1363,1350,1324,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) then
                v.Enabled=false
            end
        end
        for _,v in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA((function()
        local a={1077,1298,1519,1545,1402,1324,1441,1350,934,1454,1402,1545,1545,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={1129,1519,1298,1402,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) then v.Lifetime=NumberRange.new(0)
                elseif v:IsA((function()
        local a={947,1402,1519,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={1116,1493,1480,1545,1025,1402,1376,1389,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) or v:IsA((function()
        local a={1116,1454,1480,1428,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) then v.Enabled=false end
            end)
        end
    end)
    print((function()
        local a={1220,1103,1402,1571,1298,1441,1532,453,1103,1298,1376,1402,1467,1376,453,908,1480,1454,1493,1246,453,947,1077,1116,453,895,1480,1480,1532,1545,453,1298,1493,1493,1441,1402,1350,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
end


-- ══════════════════════════════════════════════════════════════
-- KILL NOTIFIER + HIT NOTIFICATION
-- ══════════════════════════════════════════════════════════════
local CFG_KN = {ON=true, COLOR=Color3.fromRGB(160,32,240), SOUND=true}

local notifSG = Instance.new((function()
        local a={1116,1324,1519,1350,1350,1467,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
notifSG.Name=(function()
        local a={1103,1402,1571,1298,1441,1532,1103,1298,1376,1402,1467,1376,908,1480,1454,1493,1272,1051,1480,1545,1402,1363,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(); notifSG.ResetOnSpawn=false
notifSG.IgnoreGuiInset=true; notifSG.DisplayOrder=998
pcall(function() notifSG.Parent=game:GetService((function()
        local a={908,1480,1519,1350,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end)
if not notifSG.Parent then notifSG.Parent=LP:WaitForChild((function()
        local a={1077,1441,1298,1610,1350,1519,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end

local notifList = {}
local NOTIF_Y = 80

local function showNotif(txt, col, duration)
    if not CFG_KN.ON then return end
    col = col or CFG_KN.COLOR
    duration = duration or 2.5

    local f = Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), notifSG)
    f.Size = UDim2.new(0,220,0,32)
    f.Position = UDim2.new(0.5,-110,0,NOTIF_Y + #notifList*36)
    f.BackgroundColor3 = Color3.fromRGB(14,14,18)
    f.BorderSizePixel = 1
    f.BorderColor3 = col
    f.ZIndex = 10
    Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f).CornerRadius = UDim.new(0,6)

    -- Color accent left bar
    local bar = Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    bar.Size = UDim2.new(0,3,1,0)
    bar.BackgroundColor3 = col
    bar.BorderSizePixel = 0; bar.ZIndex = 11
    Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),bar).CornerRadius = UDim.new(0,3)

    local lbl = Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    lbl.Size = UDim2.new(1,-10,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 11

    table.insert(notifList, f)

    -- Play sound if enabled
    if CFG_KN.SOUND then
        pcall(function()
            local snd = Instance.new((function()
        local a={1116,1480,1558,1467,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), workspace)
            snd.SoundId = (function()
        local a={1519,1311,1597,1298,1532,1532,1350,1545,1402,1337,791,648,648,713,752,739,713,674,661,778,661,661,661};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
            snd.Volume = 0.4; snd.RollOffMaxDistance = 0
            snd:Play()
            game:GetService((function()
        local a={921,1350,1311,1519,1402,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()):AddItem(snd, 2)
        end)
    end

    task.delay(duration, function()
        pcall(function()
            for i,v in ipairs(notifList) do
                if v == f then table.remove(notifList, i); break end
            end
            f:Destroy()
            -- Reposition remaining
            for i,v in ipairs(notifList) do
                pcall(function()
                    v.Position = UDim2.new(0.5,-110,0,NOTIF_Y+(i-1)*36)
                end)
            end
        end)
    end)
end

-- Watch for kills — detect when enemies die
local function watchKills()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local function hookChar(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
            if not hum then return end
            hum.Died:Connect(function()
                showNotif((function()
        local a={126917,453,1012,1402,1441,1441,1350,1337,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() .. p.Name, Color3.fromRGB(160,32,240), 3)
            end)
        end
        hookChar(p.Character)
        p.CharacterAdded:Connect(hookChar)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild((function()
        local a={973,1558,1454,1298,1467,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),5)
        if not hum then return end
        hum.Died:Connect(function()
            if p ~= LP then
                showNotif((function()
        local a={126917,453,1012,1402,1441,1441,1350,1337,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() .. p.Name, Color3.fromRGB(160,32,240), 3)
            end
        end)
    end)
end)

task.defer(watchKills)

-- Desync notif
local desyncActive = false
RunService.Heartbeat:Connect(function()
    if CFG.DESYNC_ENABLED and CFG.VOID_ENABLED and not desyncActive then
        desyncActive = true
        showNotif((function()
        local a={128594,453,921,1350,1532,1610,1467,1324,453,882,1324,1545,1402,1571,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Color3.fromRGB(255,200,0), 1.5)
    elseif not (CFG.DESYNC_ENABLED and CFG.VOID_ENABLED) then
        desyncActive = false
    end
end)

-- ══════════════════════════════════════════════════════════════
-- GUI — compact dark theme matching Rivals Raging Comp style
-- 4 tabs: Void | Orbit | Extras | Settings
-- ══════════════════════════════════════════════════════════════
local guiSG=Instance.new((function()
        local a={1116,1324,1519,1350,1350,1467,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
guiSG.Name=(function()
        local a={1103,1402,1571,1298,1441,1532,1103,1298,1376,1402,1467,1376,908,1480,1454,1493};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(); guiSG.ResetOnSpawn=false
guiSG.IgnoreGuiInset=true; guiSG.DisplayOrder=999
pcall(function() guiSG.Parent=game:GetService((function()
        local a={908,1480,1519,1350,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end)
if not guiSG.Parent then guiSG.Parent=LP:WaitForChild((function()
        local a={1077,1441,1298,1610,1350,1519,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()) end

-- Colors matching original dark purple theme
local BG    =Color3.fromRGB(14,14,18)
local PANEL =Color3.fromRGB(22,22,28)
local HDR   =Color3.fromRGB(8,8,12)
local ACC   =Color3.fromRGB(120,50,180)  -- purple
local ACC2  =Color3.fromRGB(180,60,255)
local TXT   =Color3.fromRGB(210,210,220)
local SUB   =Color3.fromRGB(140,140,160)
local ON_C  =Color3.fromRGB(120,50,180)
local OFF_C =Color3.fromRGB(45,45,55)
local BORD  =Color3.fromRGB(80,40,120)

-- Status
local stV=Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),guiSG)
stV.Size=UDim2.new(0,160,0,12); stV.Position=UDim2.new(0,4,0,2)
stV.BackgroundTransparency=1; stV.Text = (function()
        local a={1155,1480,1402,1337,791,453,1064,947,947};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
stV.TextColor3=SUB; stV.Font=Enum.Font.GothamBold
stV.TextSize=10; stV.TextXAlignment=Enum.TextXAlignment.Left; stV.ZIndex=10
local stO=Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),guiSG)
stO.Size=UDim2.new(0,160,0,12); stO.Position=UDim2.new(0,4,0,14)
stO.BackgroundTransparency=1; stO.Text = (function()
        local a={1064,1519,1311,1402,1545,791,453,1064,947,947};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
stO.TextColor3=SUB; stO.Font=Enum.Font.GothamBold
stO.TextSize=10; stO.TextXAlignment=Enum.TextXAlignment.Left; stO.ZIndex=10

local function updSt()
    stV.Text=CFG.VOID_ENABLED and (function()
        local a={1155,1480,1402,1337,791,453,1064,1051,453,128594};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() or (function()
        local a={1155,1480,1402,1337,791,453,1064,947,947};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
    stV.TextColor3=CFG.VOID_ENABLED and ACC2 or SUB
    stO.Text=CFG.ORBIT_ENABLED and (function()
        local a={1064,1519,1311,1402,1545,791,453,1064,1051,453,719678,736214};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() or (function()
        local a={1064,1519,1311,1402,1545,791,453,1064,947,947};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
    stO.TextColor3=CFG.ORBIT_ENABLED and Color3.fromRGB(60,140,255) or SUB
end

-- FAB
local fab=Instance.new((function()
        local a={1129,1350,1597,1545,895,1558,1545,1545,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),guiSG)
fab.Size=UDim2.new(0,70,0,30); fab.Position=UDim2.new(0.5,-35,1,-80)
fab.BackgroundColor3=ACC; fab.BorderSizePixel=0
fab.TextColor3=Color3.new(1,1,1); fab.Font=Enum.Font.GothamBold
fab.TextSize=11; fab.Text = (function()
        local a={1103,1402,1571,1298,1441,1532,453,1103,1298,1376,1402,1467,1376,453,908,1480,1454,1493};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(); fab.ZIndex=10

-- Main window
local WIN_W=280
local win=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),guiSG)
win.Size=UDim2.new(0,WIN_W,0,10); win.Position=UDim2.new(0.5,-WIN_W/2,0.5,-200)
win.BackgroundColor3=BG; win.BorderSizePixel=1
win.BorderColor3=BORD; win.Visible=false; win.ZIndex=5
win.ClipsDescendants=true

-- Title bar
local tb=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),win)
tb.Size=UDim2.new(1,0,0,32); tb.BackgroundColor3=HDR
tb.BorderSizePixel=0; tb.ZIndex=6
-- Accent line
local al=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),tb)
al.Size=UDim2.new(1,-20,0,2); al.Position=UDim2.new(0,10,1,-1)
al.BackgroundColor3=ACC; al.BorderSizePixel=0; al.ZIndex=7
local ag=Instance.new((function()
        local a={1142,986,960,1519,1298,1337,1402,1350,1467,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),al)
ag.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(80,30,200)),
    ColorSequenceKeypoint.new(0.5,ACC2),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(80,30,200))
})
local tl=Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),tb)
tl.Size=UDim2.new(1,-8,1,0); tl.Position=UDim2.new(0,8,0,0)
tl.BackgroundTransparency=1; tl.Text = (function()
        local a={1103,1402,1571,1298,1441,1532,453,1103,1298,1376,1402,1467,1376,453,908,1480,1454,1493,453,106793,453,1038,1480,1311,1402,1441,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
tl.TextColor3=ACC2; tl.Font=Enum.Font.GothamBold
tl.TextSize=12; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=7

-- Drag
local dg=false; local ds,dp
tb.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        dg=true; ds=i.Position; dp=win.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dg and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-ds
        win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false end
end)

-- Tabs
local TABS={(function()
        local a={1155,1480,1402,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),(function()
        local a={1064,1519,1311,1402,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),(function()
        local a={934,1597,1545,1519,1298,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),(function()
        local a={1116,1350,1545,1545,1402,1467,1376,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}
local tBtns={}; local tPages={}; local curTab=1
local tabBar=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),win)
tabBar.Size=UDim2.new(1,0,0,24); tabBar.Position=UDim2.new(0,0,0,32)
tabBar.BackgroundColor3=Color3.fromRGB(10,10,14); tabBar.BorderSizePixel=0; tabBar.ZIndex=6
local tw=math.floor(WIN_W/#TABS)
for i,name in ipairs(TABS) do
    local btn=Instance.new((function()
        local a={1129,1350,1597,1545,895,1558,1545,1545,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),tabBar)
    btn.Size=UDim2.new(0,tw,1,0); btn.Position=UDim2.new(0,(i-1)*tw,0,0)
    btn.BackgroundColor3=i==1 and ACC or Color3.fromRGB(20,20,28)
    btn.TextColor3=i==1 and Color3.new(1,1,1) or SUB
    btn.Font=Enum.Font.GothamBold; btn.TextSize=10
    btn.Text=name; btn.BorderSizePixel=0; btn.ZIndex=7
    tBtns[i]=btn
    local pg=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),win)
    pg.Size=UDim2.new(1,0,0,2000); pg.Position=UDim2.new(0,0,0,58)
    pg.BackgroundTransparency=1; pg.BorderSizePixel=0
    pg.Visible=(i==1); pg.ZIndex=5; pg.ClipsDescendants=true
    tPages[i]=pg
end
local pY={0,0,0,0}

-- Touch + mouse scroll for tab pages
local scrollDragging = false
local scrollLastY    = 0

-- Win captures all input for scrolling
win.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch
    or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        scrollDragging=true; scrollLastY=inp.Position.Y
    end
end)
win.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch
    or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        scrollDragging=false
    end
end)
UIS.InputChanged:Connect(function(inp)
    if not scrollDragging then return end
    if inp.UserInputType~=Enum.UserInputType.Touch
    and inp.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local delta = inp.Position.Y - scrollLastY
    scrollLastY = inp.Position.Y
    local pg = tPages[curTab]
    if not pg then return end
    local curY  = pg.Position.Y.Offset
    local maxUp = -(pY[curTab] - (WIN_H_VISIBLE - 70))
    local newY  = math.clamp(curY + delta, math.min(maxUp,-10), 58)
    pg.Position = UDim2.new(0,0,0,newY)
end)
local RH=26; local SH=36; local G=3; local SEC=17

local WIN_H_VISIBLE = 430

local function switchTab(idx)
    curTab=idx
    for i,pg in ipairs(tPages) do
        pg.Visible=(i==idx)
        pg.Position=UDim2.new(0,0,0,58)  -- reset scroll on tab switch
    end
    for i,btn in ipairs(tBtns) do
        btn.BackgroundColor3=i==idx and ACC or Color3.fromRGB(20,20,28)
        btn.TextColor3=i==idx and Color3.new(1,1,1) or SUB
    end
    win.Size=UDim2.new(0,WIN_W,0,WIN_H_VISIBLE)
end
for i,btn in ipairs(tBtns) do
    local ii=i; btn.MouseButton1Click:Connect(function() switchTab(ii) end)
end

-- Row builders
local function mkSec(pg,txt)
    local f=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),tPages[pg])
    f.Size=UDim2.new(1,-8,0,SEC); f.Position=UDim2.new(0,4,0,pY[pg])
    f.BackgroundColor3=Color3.fromRGB(20,16,28); f.BorderSizePixel=0; f.ZIndex=6
    local l=Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    l.Size=UDim2.new(1,-6,1,0); l.Position=UDim2.new(0,5,0,0)
    l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=ACC2
    l.Font=Enum.Font.GothamBold; l.TextSize=10
    l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=7
    pY[pg]=pY[pg]+SEC+G
end

local function mkTog(pg,txt,getter,setter)
    local f=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),tPages[pg])
    f.Size=UDim2.new(1,-8,0,RH); f.Position=UDim2.new(0,4,0,pY[pg])
    f.BackgroundColor3=PANEL; f.BorderSizePixel=0; f.ZIndex=6
    local l=Instance.new((function()
        local a={1129,1350,1597,1545,1025,1298,1311,1350,1441};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    l.Size=UDim2.new(1,-48,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=TXT
    l.Font=Enum.Font.Gotham; l.TextSize=11
    l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true; l.ZIndex=7
    -- Toggle pill
    local pill=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    pill.Size=UDim2.new(0,36,0,18); pill.Position=UDim2.new(1,-40,0.5,-9)
    pill.BackgroundColor3=getter() and ON_C or OFF_C
    pill.BorderSizePixel=0; pill.ZIndex=7
    Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),pill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new((function()
        local a={947,1519,1298,1454,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),pill)
    knob.Size=UDim2.new(0,14,0,14)
    knob.Position=getter() and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; knob.ZIndex=8
    Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),knob).CornerRadius=UDim.new(1,0)
    local btn=Instance.new((function()
        local a={1129,1350,1597,1545,895,1558,1545,1545,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),f)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=9
    btn.MouseButton1Click:Connect(function()
        local v=not getter(); setter(v)
        pill.BackgroundColor3=v and ON_C or OFF_C
        knob.Position=v and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7)
    end)
    pY[pg]=pY[pg]+RH+G
end

local function mkSlide(pg,txt,getter,setter,mn,mx,suf,cb)
    local f=Instance.new("Frame(function()
        local a={609,1545,1077,1298,1376,1350,1532,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,674,609,622,765,609,661,609,1116,973,570,804,453,1363,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,713,609,661,609,1493,1194,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,1077,882,1051,934,1025,804,453,1363,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,804,453,1363,635,1207,986,1467,1337,1350,1597,830,739,167,453,453,453,453,1441,1480,1324,1298,1441,453,1441,1311,1441,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextLabel(function()
        local a={609,1363,570,167,453,453,453,453,1441,1311,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,726,726,609,661,609,661,609,674,713,570,804,453,1441,1311,1441,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,765,609,661,609,687,570,167,453,453,453,453,1441,1311,1441,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,1129,1519,1298,1467,1532,1493,1298,1519,1350,1467,1324,1610,830,674,804,453,1441,1311,1441,635,1129,1350,1597,1545,830,1545,1597,1545,804,453,1441,1311,1441,635,1129,1350,1597,1545,908,1480,1441,1480,1519,700,830,1116,1142,895,167,453,453,453,453,1441,1311,1441,635,947,1480,1467,1545,830,934,1467,1558,1454,635,947,1480,1467,1545,635,960,1480,1545,1389,1298,1454,804,453,1441,1311,1441,635,1129,1350,1597,1545,1116,1402,1623,1350,830,674,661,167,453,453,453,453,1441,1311,1441,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,830,934,1467,1558,1454,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,635,1025,1350,1363,1545,804,453,1441,1311,1441,635,1207,986,1467,1337,1350,1597,830,752,167,453,453,453,453,1441,1480,1324,1298,1441,453,1571,1441,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextLabel(function()
        local a={609,1363,570,167,453,453,453,453,1571,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,713,726,609,622,739,609,661,609,674,713,570,804,453,1571,1441,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,726,726,609,661,609,661,609,687,570,167,453,453,453,453,1571,1441,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,1129,1519,1298,1467,1532,1493,1298,1519,1350,1467,1324,1610,830,674,804,453,1571,1441,635,1129,1350,1597,1545,830,1545,1480,1532,1545,1519,1402,1467,1376,557,1376,1350,1545,1545,1350,1519,557,570,570,635,635,557,1532,1558,1363,453,1480,1519,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={570,167,453,453,453,453,1571,1441,635,1129,1350,1597,1545,908,1480,1441,1480,1519,700,830,882,908,908,687,804,453,1571,1441,635,947,1480,1467,1545,830,934,1467,1558,1454,635,947,1480,1467,1545,635,960,1480,1545,1389,1298,1454,895,1480,1441,1337,167,453,453,453,453,1571,1441,635,1129,1350,1597,1545,1116,1402,1623,1350,830,674,674,804,453,1571,1441,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,830,934,1467,1558,1454,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,635,1103,1402,1376,1389,1545,804,453,1571,1441,635,1207,986,1467,1337,1350,1597,830,752,167,453,453,453,453,1441,1480,1324,1298,1441,453,1545,1519,1428,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextButton(function()
        local a={609,1363,570,167,453,453,453,453,1545,1519,1428,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,674,609,622,674,739,609,661,609,778,570,804,453,1545,1519,1428,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,765,609,661,609,687,687,570,167,453,453,453,453,1545,1519,1428,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,908,1480,1441,1480,1519,700,635,1363,1519,1480,1454,1103,960,895,557,700,661,609,700,661,609,713,661,570,804,453,1545,1519,1428,635,1129,1350,1597,1545,830};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={167,453,453,453,453,1545,1519,1428,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,804,453,1545,1519,1428,635,1207,986,1467,1337,1350,1597,830,752,167,453,453,453,453,1441,1480,1324,1298,1441,453,1363,1402,1441,1441,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Frame(function()
        local a={609,1545,1519,1428,570,167,453,453,453,453,1363,1402,1441,1441,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,882,908,908,804,453,1363,1402,1441,1441,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,167,453,453,453,453,1363,1402,1441,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,1324,1441,1298,1454,1493,557,557,1376,1350,1545,1545,1350,1519,557,570,622,1454,1467,570,648,557,1454,1597,622,1454,1467,570,609,661,609,674,570,609,661,609,674,609,661,570,804,453,1363,1402,1441,1441,635,1207,986,1467,1337,1350,1597,830,765,167,453,453,453,453,622,622,453,960,1519,1298,1337,1402,1350,1467,1545,453,1480,1467,453,1363,1402,1441,1441,167,453,453,453,453,1441,1480,1324,1298,1441,453,1363,1376,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()UIGradient(function()
        local a={609,1363,1402,1441,1441,570,167,453,453,453,453,1363,1376,635,908,1480,1441,1480,1519,830,908,1480,1441,1480,1519,1116,1350,1506,1558,1350,1467,1324,1350,635,1467,1350,1584,557,1636,908,1480,1441,1480,1519,1116,1350,1506,1558,1350,1467,1324,1350,1012,1350,1610,1493,1480,1402,1467,1545,635,1467,1350,1584,557,661,609,908,1480,1441,1480,1519,700,635,1363,1519,1480,1454,1103,960,895,557,765,661,609,700,661,609,687,661,661,570,570,609,908,1480,1441,1480,1519,1116,1350,1506,1558,1350,1467,1324,1350,1012,1350,1610,1493,1480,1402,1467,1545,635,1467,1350,1584,557,674,609,882,908,908,687,570,1662,570,167,453,453,453,453,1441,1480,1324,1298,1441,453,1363,1558,1467,1324,1545,1402,1480,1467,453,1532,1571,557,1597,570,167,453,453,453,453,453,453,453,453,1441,1480,1324,1298,1441,453,1493,1324,1545,830,1324,1441,1298,1454,1493,557,557,1597,622,1545,1519,1428,635,882,1311,1532,1480,1441,1558,1545,1350,1077,1480,1532,1402,1545,1402,1480,1467,635,1181,570,648,1454,1298,1545,1389,635,1454,1298,1597,557,1545,1519,1428,635,882,1311,1532,1480,1441,1558,1545,1350,1116,1402,1623,1350,635,1181,609,674,570,609,661,609,674,570,167,453,453,453,453,453,453,453,453,1441,1480,1324,1298,1441,453,1571,830,1324,1441,1298,1454,1493,557,1454,1298,1545,1389,635,1519,1480,1558,1467,1337,557,1454,1467,596,1493,1324,1545,583,557,1454,1597,622,1454,1467,570,570,609,1454,1467,609,1454,1597,570,167,453,453,453,453,453,453,453,453,1532,1350,1545,1545,1350,1519,557,1571,570,804,453,1363,1402,1441,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,557,1571,622,1454,1467,570,648,557,1454,1597,622,1454,1467,570,609,661,609,674,609,661,570,167,453,453,453,453,453,453,453,453,1571,1441,635,1129,1350,1597,1545,830,1545,1480,1532,1545,1519,1402,1467,1376,557,1571,570,635,635,557,1532,1558,1363,453,1480,1519,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={570,167,453,453,453,453,453,453,453,453,1402,1363,453,1324,1311,453,1545,1389,1350,1467,453,1493,1324,1298,1441,1441,557,1324,1311,609,1571,570,453,1350,1467,1337,167,453,453,453,453,1350,1467,1337,167,453,453,453,453,1441,1480,1324,1298,1441,453,1532,1441,830,1363,1298,1441,1532,1350,167,453,453,453,453,1545,1519,1428,635,986,1467,1493,1558,1545,895,1350,1376,1298,1467,791,908,1480,1467,1467,1350,1324,1545,557,1363,1558,1467,1324,1545,1402,1480,1467,557,1402,570,167,453,453,453,453,453,453,453,453,1402,1363,453,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1129,1480,1558,1324,1389,453,1480,1519,453,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1038,1480,1558,1532,1350,895,1558,1545,1545,1480,1467,674,453,1545,1389,1350,1467,453,1532,1441,830,1545,1519,1558,1350,804,453,1532,1571,557,1402,635,1077,1480,1532,1402,1545,1402,1480,1467,635,1181,570,453,1350,1467,1337,167,453,453,453,453,1350,1467,1337,570,167,453,453,453,453,1545,1519,1428,635,986,1467,1493,1558,1545,908,1389,1298,1467,1376,1350,1337,791,908,1480,1467,1467,1350,1324,1545,557,1363,1558,1467,1324,1545,1402,1480,1467,557,1402,570,167,453,453,453,453,453,453,453,453,1402,1363,453,1532,1441,453,1298,1467,1337,557,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1129,1480,1558,1324,1389,453,1480,1519,453,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1038,1480,1558,1532,1350,1038,1480,1571,1350,1454,1350,1467,1545,570,453,1545,1389,1350,1467,453,1532,1571,557,1402,635,1077,1480,1532,1402,1545,1402,1480,1467,635,1181,570,453,1350,1467,1337,167,453,453,453,453,1350,1467,1337,570,167,453,453,453,453,1545,1519,1428,635,986,1467,1493,1558,1545,934,1467,1337,1350,1337,791,908,1480,1467,1467,1350,1324,1545,557,1363,1558,1467,1324,1545,1402,1480,1467,557,1402,570,167,453,453,453,453,453,453,453,453,1402,1363,453,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1129,1480,1558,1324,1389,453,1480,1519,453,1402,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,830,830,934,1467,1558,1454,635,1142,1532,1350,1519,986,1467,1493,1558,1545,1129,1610,1493,1350,635,1038,1480,1558,1532,1350,895,1558,1545,1545,1480,1467,674,453,1545,1389,1350,1467,453,1532,1441,830,1363,1298,1441,1532,1350,453,1350,1467,1337,167,453,453,453,453,1350,1467,1337,570,167,453,453,453,453,1493,1194,1220,1493,1376,1246,830,1493,1194,1220,1493,1376,1246,596,1116,973,596,960,167,1350,1467,1337,167,167,1441,1480,1324,1298,1441,453,1363,1558,1467,1324,1545,1402,1480,1467,453,1454,1428,921,1519,1480,1493,1337,1480,1584,1467,557,1493,1376,609,1545,1597,1545,609,1480,1493,1545,1402,1480,1467,1532,609,1376,1350,1545,1545,1350,1519,609,1532,1350,1545,1545,1350,1519,570,167,453,453,453,453,622,622,453,1116,1402,1454,1493,1441,1350,453,1324,1610,1324,1441,1350,453,1311,1558,1545,1545,1480,1467,453,557,1467,1480,453,1337,1519,1480,1493,1337,1480,1584,1467,453,1467,1350,1350,1337,1350,1337,609,453,1532,1298,1571,1350,1532,453,1402,1467,1532,1545,1298,1467,1324,1350,1532,570,167,453,453,453,453,1441,1480,1324,1298,1441,453,1363,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Frame(function()
        local a={609,1545,1077,1298,1376,1350,1532,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,674,609,622,765,609,661,609,1103,973,570,804,453,1363,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,713,609,661,609,1493,1194,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,1077,882,1051,934,1025,804,453,1363,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,804,453,1363,635,1207,986,1467,1337,1350,1597,830,739,167,453,453,453,453,1441,1480,1324,1298,1441,453,1441,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextLabel(function()
        local a={609,1363,570,167,453,453,453,453,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,700,765,609,661,609,674,609,661,570,804,453,1441,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,765,609,661,609,661,570,167,453,453,453,453,1441,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,1129,1519,1298,1467,1532,1493,1298,1519,1350,1467,1324,1610,830,674,804,453,1441,635,1129,1350,1597,1545,830,1545,1597,1545,804,453,1441,635,1129,1350,1597,1545,908,1480,1441,1480,1519,700,830,1116,1142,895,167,453,453,453,453,1441,635,947,1480,1467,1545,830,934,1467,1558,1454,635,947,1480,1467,1545,635,960,1480,1545,1389,1298,1454,804,453,1441,635,1129,1350,1597,1545,1116,1402,1623,1350,830,674,661,167,453,453,453,453,1441,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,830,934,1467,1558,1454,635,1129,1350,1597,1545,1181,882,1441,1402,1376,1467,1454,1350,1467,1545,635,1025,1350,1363,1545,804,453,1441,635,1207,986,1467,1337,1350,1597,830,752,167,453,453,453,453,1441,1480,1324,1298,1441,453,1571,1441,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextButton(function()
        local a={609,1363,570,167,453,453,453,453,1571,1441,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,739,687,609,622,765,609,661,609,687,661,570,804,453,1571,1441,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,635,700,765,609,661,609,661,635,726,609,622,674,661,570,167,453,453,453,453,1571,1441,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,908,1480,1441,1480,1519,700,635,1363,1519,1480,1454,1103,960,895,557,700,661,609,687,661,609,726,661,570,804,453,1571,1441,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,167,453,453,453,453,1571,1441,635,1129,1350,1597,1545,908,1480,1441,1480,1519,700,830,882,908,908,687,804,453,1571,1441,635,947,1480,1467,1545,830,934,1467,1558,1454,635,947,1480,1467,1545,635,960,1480,1545,1389,1298,1454,895,1480,1441,1337,804,453,1571,1441,635,1129,1350,1597,1545,1116,1402,1623,1350,830,778,167,453,453,453,453,1571,1441,635,1129,1350,1597,1545,830,1376,1350,1545,1545,1350,1519,557,570,804,453,1571,1441,635,1207,986,1467,1337,1350,1597,830,752,804,453,1571,1441,635,1129,1350,1597,1545,1129,1519,1558,1467,1324,1298,1545,1350,830,934,1467,1558,1454,635,1129,1350,1597,1545,1129,1519,1558,1467,1324,1298,1545,1350,635,882,1545,934,1467,1337,167,453,453,453,453,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()UICorner",vl).CornerRadius=UDim.new(0,4)
    local idx=1
    for i,v in ipairs(options) do if v==getter() then idx=i; break end end
    vl.MouseButton1Click:Connect(function()
        idx=(idx%#options)+1
        setter(options[idx]); vl.Text=options[idx]
    end)
    pY[pg]=pY[pg]+RH+G
end

local function mkBtn(pg,txt,fn)
    local f=Instance.new("TextButton(function()
        local a={609,1545,1077,1298,1376,1350,1532,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,1116,1402,1623,1350,830,1142,921,1402,1454,687,635,1467,1350,1584,557,674,609,622,765,609,661,609,687,713,570,804,453,1363,635,1077,1480,1532,1402,1545,1402,1480,1467,830,1142,921,1402,1454,687,635,1467,1350,1584,557,661,609,713,609,661,609,1493,1194,1220,1493,1376,1246,570,167,453,453,453,453,1363,635,895,1298,1324,1428,1376,1519,1480,1558,1467,1337,908,1480,1441,1480,1519,700,830,882,908,908,804,453,1363,635,895,1480,1519,1337,1350,1519,1116,1402,1623,1350,1077,1402,1597,1350,1441,830,661,167,453,453,453,453,1363,635,1129,1350,1597,1545,908,1480,1441,1480,1519,700,830,908,1480,1441,1480,1519,700,635,1467,1350,1584,557,674,609,674,609,674,570,804,453,1363,635,947,1480,1467,1545,830,934,1467,1558,1454,635,947,1480,1467,1545,635,960,1480,1545,1389,1298,1454,895,1480,1441,1337,167,453,453,453,453,1363,635,1129,1350,1597,1545,1116,1402,1623,1350,830,674,674,804,453,1363,635,1129,1350,1597,1545,830,1545,1597,1545,804,453,1363,635,1207,986,1467,1337,1350,1597,830,739,167,453,453,453,453,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()UICorner(function()
        local a={609,1363,570,635,908,1480,1519,1467,1350,1519,1103,1298,1337,1402,1558,1532,830,1142,921,1402,1454,635,1467,1350,1584,557,661,609,726,570,167,453,453,453,453,1363,635,1038,1480,1558,1532,1350,895,1558,1545,1545,1480,1467,674,908,1441,1402,1324,1428,791,908,1480,1467,1467,1350,1324,1545,557,1363,1467,570,167,453,453,453,453,1493,1194,1220,1493,1376,1246,830,1493,1194,1220,1493,1376,1246,596,687,739,596,960,167,1350,1467,1337,167,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,622,622,453,1129,882,895,453,674,791,453,1155,1064,986,921,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,1454,1428,1116,1350,1324,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Void Control(function()
        local a={570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enable Void",function() return CFG.VOID_ENABLED end,function(v)
    CFG.VOID_ENABLED=v; updSt()
    if v then startVoid() else stopVoid() end
end)
mkDropdown(1,"Void Method(function()
        local a={609,167,453,453,453,453,1636};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Stable(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Drift(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Chaotic(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Circle(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Spiral(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Lissajous(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Perlin Noise(function()
        local a={609,167,453,453,453,453,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Flicker Void(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Gravity Well(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Helix(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Figure 8(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Tornado(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Butterfly(function()
        local a={609,167,453,453,453,453,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Double Helix(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Chaotic Sphere(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Quantum Tunneling(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Fractal Desync(function()
        local a={609,167,453,453,453,453,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Extreme Desync(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Quantum Oscillation(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Frame Skip"},
    function() return CFG.VOID_METHOD end,
    function(v) CFG.VOID_METHOD=v end
)
mkDropdown(1,"Bypass Method(function()
        local a={609,167,453,453,453,453,1636};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()None(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Velocity(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()CFrame only(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Hybrid(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Physics Bypass(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Extreme Networking"},
    function() return CFG.VOID_BYPASS_MODE end,
    function(v) CFG.VOID_BYPASS_MODE=v end
)
mkSlide(1,"Drift Speed",function() return math.floor(CFG.VOID_DRIFT_SPEED/1e6) end,function(v) CFG.VOID_DRIFT_SPEED=v*1e6 end,1,200," M/s(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Drift Chaos",function() return math.floor(CFG.VOID_DRIFT_CHAOS*100) end,function(v) CFG.VOID_DRIFT_CHAOS=v*0.01 end,1,100,"%(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Void Altitude",function() return math.floor(CFG.VOID_Y_BASE/1e12) end,function(v) CFG.VOID_Y_BASE=v*1e12 end,1,1000,"B(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Scramble Position",function() return CFG.VOID_SCRAMBLE end,function(v) CFG.VOID_SCRAMBLE=v end)
mkSlide(1,"Lissajous A",function() return CFG.VOID_LISSAJOUS_A end,function(v) CFG.VOID_LISSAJOUS_A=v end,1,10,"(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Lissajous B",function() return CFG.VOID_LISSAJOUS_B end,function(v) CFG.VOID_LISSAJOUS_B=v end,1,10,"(function()
        local a={609,1467,1402,1441,570,167,167,1454,1428,1116,1350,1324,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Evasion & Desync(function()
        local a={570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enable Desync",function() return CFG.DESYNC_ENABLED end,function(v) CFG.DESYNC_ENABLED=v end)
mkSlide(1,"Desync Rate",function() return math.floor(CFG.DESYNC_TICK*100) end,function(v) CFG.DESYNC_TICK=v*0.01 end,1,100,"x0.01s(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Desync Radius",function() return CFG.DESYNC_RADIUS end,function(v) CFG.DESYNC_RADIUS=v end,1,100," studs(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Dodge Enemies",function() return CFG.VOID_EVADE end,function(v) CFG.VOID_EVADE=v end)
mkSlide(1,"Evasion Radius",function() return math.floor(CFG.VOID_EVADE_RADIUS/1e9) end,function(v) CFG.VOID_EVADE_RADIUS=v*1e9 end,1,50,"B(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Evasion Speed",function() return math.floor(CFG.VOID_EVADE_SPEED/1e9) end,function(v) CFG.VOID_EVADE_SPEED=v*1e9 end,1,50,"B(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enable Ghosting",function() return CFG.VOID_GHOSTING end,function(v) CFG.VOID_GHOSTING=v end)
mkSlide(1,"Ghosting Intensity",function() return math.floor(CFG.VOID_GHOSTING_INT*100) end,function(v) CFG.VOID_GHOSTING_INT=v*0.01 end,1,100,"%(function()
        local a={609,1467,1402,1441,570,167,167,1454,1428,1116,1350,1324,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Advanced Void Settings(function()
        local a={570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Y Drift Range",function() return CFG.VOID_Y_DRIFT_RANGE_V end,function(v) CFG.VOID_Y_DRIFT_RANGE_V=v; CFG.VOID_Y_DRIFT_RANGE=v*1e9 end,0,10,"B(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Scramble Interval",function() return CFG.VOID_SCRAMBLE_INT end,function(v) CFG.VOID_SCRAMBLE_INT=v; CFG.VOID_SCRAMBLE_TIME=v*0.1 end,1,100,"x0.1s(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Flicker Interval",function() return CFG.VOID_FLICKER_MS end,function(v) CFG.VOID_FLICKER_MS=v; CFG.VOID_FLICKER_INT=v*0.01 end,1,50,"ms(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,674,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Force Vertical Evasion",function() return CFG.VOID_EVADE_FORCE_UP end,function(v) CFG.VOID_EVADE_FORCE_UP=v end)
mkSlide(1,"Gravity Well Strength",function() return CFG.VOID_GRAVITY_M end,function(v) CFG.VOID_GRAVITY_M=v; CFG.VOID_GRAVITY_STR=v*1e6 end,1,1000,"M(function()
        local a={609,1467,1402,1441,570,167,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,622,622,453,1129,882,895,453,687,791,453,1064,1103,895,986,1129,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,1454,1428,1116,1350,1324,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Orbit Control(function()
        local a={570,167,1454,1428,1129,1480,1376,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enable Orbit",function() return CFG.ORBIT_ENABLED end,function(v)
    CFG.ORBIT_ENABLED=v; updSt()
    if v then startOrbit() else stopOrbit() end
end)
mkDropdown(2,"Orbit Pattern(function()
        local a={609,167,453,453,453,453,1636};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Default(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Spiral(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Random(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Lissajous(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Helix(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Figure 8(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Pulse(function()
        local a={609,167,453,453,453,453,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Tornado(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Butterfly(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Quantum Orbit(function()
        local a={609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Hyper Elliptical"},
    function() return CFG.ORBIT_MODE end,
    function(v) CFG.ORBIT_MODE=v end
)
mkSlide(2,"Orbit Speed",function() return math.floor(CFG.ORBIT_SPEED*10) end,function(v) CFG.ORBIT_SPEED=v*0.1 end,0,100,"x0.1(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Orbit Jitter",function() return CFG.ORBIT_JITTER end,function(v) CFG.ORBIT_JITTER=v end,0,360,"°(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Orbit Stability",function() return math.floor(CFG.ORBIT_STABILITY*10) end,function(v) CFG.ORBIT_STABILITY=v*0.1 end,1,100,"%(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Camera Height",function() return math.floor(CFG.HEIGHT_OFFSET/1000) end,function(v) CFG.HEIGHT_OFFSET=v*1000 end,0,2000,"k st(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Min Radius",function() return math.floor(CFG.MIN_RADIUS/10000) end,function(v) CFG.MIN_RADIUS=v*10000 end,1,1000,"k(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Max Radius",function() return math.floor(CFG.MAX_RADIUS/1e8) end,function(v) CFG.MAX_RADIUS=v*1e8 end,1,10000,"B(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Lock FOV",function() return CFG.LOCK_FOV end,function(v) CFG.LOCK_FOV=v end,1,180,"°(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Prediction",function() return math.floor(CFG.PREDICTION*100) end,function(v) CFG.PREDICTION=v*0.01 end,1,100,"%(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Auto Lock",function() return CFG.AUTO_LOCK end,function(v) CFG.AUTO_LOCK=v end)
mkSlide(2,"Auto Lock Radius",function() return CFG.AUTO_LOCK_RADIUS end,function(v) CFG.AUTO_LOCK_RADIUS=v end,10,2000," st(function()
        local a={609,1467,1402,1441,570,167,1454,1428,895,1545,1467,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Restore Camera",function()
    stopOrbit()
    print("[Rivals Raging Comp] Camera restored(function()
        local a={570,167,1350,1467,1337,570,167,1454,1428,895,1545,1467,557,687,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Drop Target",function()
    currentTgt=nil
    print("[Rivals Raging Comp] Target dropped(function()
        local a={570,167,1350,1467,1337,570,167,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,622,622,453,1129,882,895,453,700,791,453,934,1181,1129,1103,882,1116,167,622,622,453,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,124213,167,1454,1428,1116,1350,1324,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Kill Notifier(function()
        local a={570,167,1454,1428,1129,1480,1376,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Kill Notifier ON",function() return CFG.KILL_NOTIFIER end,function(v) CFG.KILL_NOTIFIER=v end)
mkSec(3,"Standalone Desync(function()
        local a={570,167,1454,1428,1129,1480,1376,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Desync ON",function() return CFG.DESYNC_STANDALONE end,function(v)
    CFG.DESYNC_STANDALONE=v
    if v then startDesyncOnly() else stopDesyncOnly() end
end)
mkSlide(3,"Desync Rate",function() return math.floor(CFG.DESYNC_TICK*100) end,function(v) CFG.DESYNC_TICK=v*0.01 end,1,100,"x0.01s(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1441,1402,1337,1350,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Desync Radius",function() return CFG.DESYNC_RADIUS end,function(v) CFG.DESYNC_RADIUS=v end,1,100," st(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1350,1324,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Movement(function()
        local a={570,167,1454,1428,1129,1480,1376,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Speed Boost",function() return CFG.SPEED_ENABLED end,function(v) CFG.SPEED_ENABLED=v; applySpeed() end)
mkSlide(3,"Walk Speed",function() return CFG.WALK_SPEED end,function(v) CFG.WALK_SPEED=v; if CFG.SPEED_ENABLED then applySpeed() end end,16,100,"(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1129,1480,1376,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Infinite Jump",function() return CFG.INF_JUMP end,function(v) CFG.INF_JUMP=v; if v then startIJ() end end)
mkTog(3,"Noclip",function() return CFG.NOCLIP end,function(v) CFG.NOCLIP=v; if v then startNoclip() else stopNoclip() end end)
mkTog(3,"Low Gravity",function() return CFG.LOW_GRAVITY end,function(v) CFG.LOW_GRAVITY=v; applyGravity() end)
mkSlide(3,"Gravity Value",function() return CFG.GRAVITY_VAL end,function(v) CFG.GRAVITY_VAL=v; if CFG.LOW_GRAVITY then applyGravity() end end,5,196,"(function()
        local a={609,1467,1402,1441,570,167,1454,1428,1116,1350,1324,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Notifications(function()
        local a={570,167,1454,1428,1129,1480,1376,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Kill Notifier",function() return CFG_KN.ON end,function(v) CFG_KN.ON=v end)
mkTog(3,"Kill Sound",function() return CFG_KN.SOUND end,function(v) CFG_KN.SOUND=v end)
mkSec(3,"Performance(function()
        local a={570,167,1454,1428,895,1545,1467,557,700,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()FPS Booster",function() applyFPSBoost() end)
mkSec(3,"Info(function()
        local a={570,167,1441,1480,1324,1298,1441,453,1402,1467,1363,830,986,1467,1532,1545,1298,1467,1324,1350,635,1467,1350,1584,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()TextLabel",tPages[3])
inf.Size=UDim2.new(1,-8,0,40); inf.Position=UDim2.new(0,4,0,pY[3])
inf.BackgroundTransparency=1
inf.Text = (function()
        local a={1155,1480,1402,1337,791,453,908,947,1519,1298,1454,1350,453,1493,1480,1532,1402,1545,1402,1480,1467,453,1454,1298,1467,1402,1493,1558,1441,1298,1545,1402,1480,1467,1233,1467,1064,1519,1311,1402,1545,791,453,908,1298,1454,1350,1519,1298,453,1454,1480,1571,1350,1454,1350,1467,1545,453,1493,1298,1545,1545,1350,1519,1467,1532,1233,1467,1129,1298,1493,453,1454,1350,1545,1389,1480,1337,453,1467,1298,1454,1350,453,1545,1480,453,1324,1610,1324,1441,1350,453,1480,1493,1545,1402,1480,1467,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
inf.TextColor3=SUB; inf.Font=Enum.Font.Gotham; inf.TextSize=10
inf.TextWrapped=true; inf.TextXAlignment=Enum.TextXAlignment.Left; inf.ZIndex=6
pY[3]=pY[3]+42

-- ═══════════════════════════════════════════════════
-- TAB 4: SETTINGS
-- ═══════════════════════════════════════════════════
mkSec(4,"UI Settings(function()
        local a={570,167,1454,1428,1129,1480,1376,557,713,609};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Show FOV Circle",function() return false end,function(v) end)
local camSt=Instance.new("TextLabel",tPages[4])
camSt.Size=UDim2.new(1,-8,0,20); camSt.Position=UDim2.new(0,4,0,pY[4])
camSt.BackgroundTransparency=1
-- hasHook already defined above
camSt.Text = (function()
        local a={908,1298,1454,1350,1519,1298,453,973,1480,1480,1428,791,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()..(hasHook and "✅ Active(function()
        local a={453,1480,1519,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()⚠️ Fallback")
camSt.TextColor3=hasHook and Color3.fromRGB(0,215,100) or Color3.fromRGB(255,200,0)
camSt.Font=Enum.Font.Gotham; camSt.TextSize=11
camSt.TextXAlignment=Enum.TextXAlignment.Left; camSt.ZIndex=6
pY[4]=pY[4]+22

switchTab(1)

local winOpen=true
fab.MouseButton1Click:Connect(function()
    winOpen=not winOpen; win.Visible=winOpen
    if winOpen then switchTab(curTab) end
end)

-- Respawn
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if CFG.VOID_ENABLED then startVoid() end
    if CFG.ORBIT_ENABLED then startOrbit() end
    if CFG.SPEED_ENABLED then applySpeed() end
    if CFG.INF_JUMP then startIJ() end
    if CFG.NOCLIP then startNoclip() end
    if CFG.LOW_GRAVITY then applyGravity() end
    if CFG.DESYNC_STANDALONE then startDesyncOnly() end
    for _,p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
end)

-- Force correct window size after all rows built
-- switchTab already called above
print("[Rivals Raging Comp] Loaded - UI should be visible(function()
        local a={570,167,1493,1519,1402,1467,1545,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Tab 1 height: (function()
        local a={635,635,1545,1480,1532,1545,1519,1402,1467,1376,557,1493,1194,1220,674,1246,570,570,167,1493,1519,1402,1467,1545,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Tab 2 height: "..tostring(pY[2]))
end;
_g8b3bh75j();
