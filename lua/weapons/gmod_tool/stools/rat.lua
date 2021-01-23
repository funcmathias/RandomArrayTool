-- Random Array Tool [R.A.T] made by func_Mathias 🐀

TOOL.Name = "#tool.rat.name"
TOOL.Description = "#tool.rat.desc"
TOOL.Category = "func_Mathias"

local toolActive = false

local maxArrayPosition = Vector()

-- Model sting paths table
local modelPathTable = {}

-- Various tool setting ConVars
TOOL.ClientConVar["sphereRadius"] = "0"
TOOL.ClientConVar["previewTraceAxisSize"] = "10"

TOOL.ClientConVar["spawnFrozen"] = "1"
TOOL.ClientConVar["freezeRootBoneOnly"] = "1"
TOOL.ClientConVar["randomRagdollPose"] = "1"
TOOL.ClientConVar["noCollide"] = "0"
TOOL.ClientConVar["noShadow"] = "0"

TOOL.ClientConVar["randomSkin"] = "1"
TOOL.ClientConVar["randomSkinStart"] = "0"
TOOL.ClientConVar["randomSkinEnd"] = "100"
TOOL.ClientConVar["randomBodygroup"] = "1"
TOOL.ClientConVar["randomBodygroupStart"] = "0"
TOOL.ClientConVar["randomBodygroupEnd"] = "100"
TOOL.ClientConVar["randomColor"] = "0"

TOOL.ClientConVar["mdlName"] = ""

TOOL.ClientConVar["ignoreSurfaceAngle"] = "0"
TOOL.ClientConVar["facePlayerZ"] = "0"
TOOL.ClientConVar["localGroundPlane"] = "0"
TOOL.ClientConVar["pushAwayFromSurface"] = "0"

TOOL.ClientConVar["spawnChance"] = "100"


-- Array ConVars
TOOL.ClientConVar["arrayType"] = "1"
TOOL.ClientConVar["previewPointAxis"] = "1"
TOOL.ClientConVar["previewPointAxisSize"] = "5"
TOOL.ClientConVar["previewArrayBounds"] = "0"
TOOL.ClientConVar["arrayCount"] = "1"

-- UI foldout states
TOOL.ClientConVar["pointTransformExpanded"] = "1"
TOOL.ClientConVar["arrayTransformsExpanded"] = "0"
TOOL.ClientConVar["randomPointTransformsExpanded"] = "0"


-- X axis ConVars
TOOL.ClientConVar["xAmount"] = "3"

TOOL.ClientConVar["xSpacingBase"] = "50"
TOOL.ClientConVar["xRotationBase"] = "0"
TOOL.ClientConVar["xGapInterval"] = "2"
TOOL.ClientConVar["xGapSpacing"] = "0"
TOOL.ClientConVar["xGapStart"] = "1"

TOOL.ClientConVar["xArrayPivot"] = "0.50"
TOOL.ClientConVar["xArrayRotation"] = "0"

TOOL.ClientConVar["xOffsetRandom"] = "0"
TOOL.ClientConVar["xRotationRandom"] = "0"
TOOL.ClientConVar["xRotationRandomStepped"] = "0"


-- Y axis ConVars
TOOL.ClientConVar["yAmount"] = "3"

TOOL.ClientConVar["ySpacingBase"] = "50"
TOOL.ClientConVar["yRotationBase"] = "0"
TOOL.ClientConVar["yGapInterval"] = "2"
TOOL.ClientConVar["yGapSpacing"] = "0"
TOOL.ClientConVar["yGapStart"] = "1"

TOOL.ClientConVar["yArrayPivot"] = "0.50"
TOOL.ClientConVar["yArrayRotation"] = "0"

TOOL.ClientConVar["yOffsetRandom"] = "0"
TOOL.ClientConVar["yRotationRandom"] = "0"
TOOL.ClientConVar["yRotationRandomStepped"] = "0"


-- Z axis ConVars
TOOL.ClientConVar["zAmount"] = "2"

TOOL.ClientConVar["zSpacingBase"] = "50"
TOOL.ClientConVar["zRotationBase"] = "0"
TOOL.ClientConVar["zGapInterval"] = "2"
TOOL.ClientConVar["zGapSpacing"] = "0"
TOOL.ClientConVar["zGapStart"] = "1"

TOOL.ClientConVar["zArrayPivot"] = "0.00"
TOOL.ClientConVar["zArrayRotation"] = "0"

TOOL.ClientConVar["zOffsetRandom"] = "0"
TOOL.ClientConVar["zRotationRandom"] = "0"
TOOL.ClientConVar["zRotationRandomStepped"] = "0"

cleanup.Register( "rat_arrays" )

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}

	language.Add( "tool.rat.name", "Random Array Tool" )
	language.Add( "tool.rat.left", "Spawn array of randomized props." )
	language.Add( "tool.rat.right", "Randomize prop under cursor, or all props within the editing sphere if it's bigger than 0." )
	language.Add( "tool.rat.reload", "Remove prop under cursor, or all props within the editing sphere if it's bigger than 0." )
	language.Add( "tool.rat.desc", "This tool lets you spawn props in a randomized array, or randomize already spawned props in various ways." )

	language.Add( "tool.rat.sphereRadius", "Editing radius" )
	language.Add( "tool.rat.previewTraceAxisSizeDescription", "Cursor preview size" )

	language.Add( "tool.rat.spawnFrozen", "Spawn frozen" )
	language.Add( "tool.rat.freezeRootBoneOnly", "Freeze only root bone of ragdolls" )
	language.Add( "tool.rat.randomRagdollPose", "Random animation pose for ragdolls" )
	language.Add( "tool.rat.noCollide", "No collide (world only)" )
	language.Add( "tool.rat.noShadow", "No dynamic shadow" )

	language.Add( "tool.rat.randomSkin", "Randomize skins" )
	language.Add( "tool.rat.randomSkinRange", "Skin range" )
	language.Add( "tool.rat.randomBodygroup", "Randomize bodygroups" )
	language.Add( "tool.rat.randomBodygroupRange", "Bodygroup range" )
	language.Add( "tool.rat.rangeTo", "to" )
	language.Add( "tool.rat.randomColor", "Apply random colors" )

	language.Add( "tool.rat.listHelpTitle", "Prop list help - Click for info" )
	language.Add( "tool.rat.listHelp1", "With the panel below you can keep track of the props you want to randomly spawn." )
	language.Add( "tool.rat.listHelp2", "- You can drag and drop any prop from the default spawnlist into the grey panel below to add them. You can select and drag multiple at once!" )
	language.Add( "tool.rat.listHelp3", "- You can also add props by using a path, if it's a path to a folder it will add every model in the folder as a prop. Be careful with folders containing a large amount of models." )
	language.Add( "tool.rat.listHelp4", "- Right click any icon to remove it from the list." )
	language.Add( "tool.rat.listHelp5", "- Tip: There is no option for saving your prop list but you can create a custom spawnlist to keep all the desired props in one place for easy adding to this list." )

	language.Add( "tool.rat.mdlAdd", "Add prop by path" )
	language.Add( "tool.rat.mdlAddButton", "Add to list from path" )
	language.Add( "tool.rat.propProbabilityTooltip", "Prop spawn probability" )
	language.Add( "tool.rat.probabilityResetButton", "Reset prop probability" )
	language.Add( "tool.rat.mdlClearButton", "Clear prop list" )

	language.Add( "tool.rat.ignoreSurfaceAngle", "Ignore surface angle" )
	language.Add( "tool.rat.facePlayerZ", "Face player on Z axis" )
	language.Add( "tool.rat.localGroundPlane", "Local player ground plane" )
	language.Add( "tool.rat.pushAwayFromSurface", "Push array from surface" )

	language.Add( "tool.rat.numOfProps", "Number of props: " )
	language.Add( "tool.rat.numberIn", "Number in " )

	language.Add( "tool.rat.spawnChance", "% Spawn chance" )

	language.Add( "tool.rat.arrayType", "Array type" )
	language.Add( "tool.rat.arrayTypeFull", "Full" )
	language.Add( "tool.rat.arrayTypeHollow", "Hollow" )
	language.Add( "tool.rat.arrayTypeOutline", "Outline" )
	language.Add( "tool.rat.arrayTypeCheckered", "Checkered" )
	language.Add( "tool.rat.arrayTypeCheckeredInv", "Checkered inverted" )
	language.Add( "tool.rat.arrayType2DCheckered", "2D Checkered" )
	language.Add( "tool.rat.arrayType2DCheckeredInv", "2D Checkered inverted" )

	language.Add( "tool.rat.previewPointAxisDescription", "Show array point previews" )
	language.Add( "tool.rat.previewPointAxisSizeDescription", "Array point preview size" )
	language.Add( "tool.rat.previewArrayBoundsDescription", "Show array bounds preview" )

	language.Add( "tool.rat.pointTransforms", "Array point transforms" )
	language.Add( "tool.rat.pointSpacing", "Spacing" )
	language.Add( "tool.rat.pointSpacingDescription", "Space between each array point." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.pointRotation", "Rotation" )
	language.Add( "tool.rat.pointRotationDescription", "Rotation of all array points." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.pointGaps", "Gaps" )
	language.Add( "tool.rat.pointGapsDescription", "Add extra spacing every X number of rows." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.pointGapsInterval", "Gap interval" )
	language.Add( "tool.rat.pointGapsStart", "Gaps start" )

	language.Add( "tool.rat.arrayTransforms", "Array origin transforms" )
	language.Add( "tool.rat.arrayPivot", "Pivot" )
	language.Add( "tool.rat.arrayPivotDescription", "Pivot of the array. 0.5 in all axes will center it to cursor." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.arrayRotation", "Rotation" )
	language.Add( "tool.rat.arrayRotationDescription", "Rotation of the array origin." .. string.char(10) .. "Click this text to reset values!" )

	language.Add( "tool.rat.randomPointTransforms", "Randomized array point transforms" )
	language.Add( "tool.rat.randomPointSpacing", "Random offset" )
	language.Add( "tool.rat.randomPointSpacingDescription", "Random position offset per array point." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.randomPointRotation", "Random rotation" )
	language.Add( "tool.rat.randomPointRotationDescription", "Random rotation offset per array point." .. string.char(10) .. "Click this text to reset values!" )
	language.Add( "tool.rat.randomPointRotationStepped", "Random stepped rotation" )
	language.Add( "tool.rat.randomRotationSteppedDescription", "Random stepped rotation offset per array point." .. string.char(10) ..
	"If you use 90 degrees for example, each point will be rotated any of 0, 90, 180 or 270 degrees." .. string.char(10) .. "Click this text to reset values!" )

	language.Add( "tool.rat.xAxis", "X axis" )
	language.Add( "tool.rat.yAxis", "Y axis" )
	language.Add( "tool.rat.zAxis", "Z axis" )

	language.Add( "tool.rat.undo", "Undone Random Array" )
	language.Add( "Cleanup_rat_arrays", "Random Arrays" )
	language.Add( "Cleaned_rat_arrays", "Cleaned up all Random Arrays" )
end

if SERVER then
	-- Register the network string
	util.AddNetworkString( "sendTables" )

	-- When the server receives the clients network information
	-- Adds the players model table in a server side table with their steam id as the key
	net.Receive( "sendTables", function( len, player )
		local sid = player:SteamID()
		modelPathTable[sid] = net.ReadTable()
	end )
end

-- Send the local model path table to the server
local function UpdateServerTable()
	net.Start( "sendTables" )
	net.WriteTable( modelPathTable )
	net.SendToServer()
end

-- Debug print
function TOOL:CheckList()
	print( "--- Model Path Table Start ---" )
	PrintTable( modelPathTable )
	print( "--- Model Path Table End ---" )
end

-- Checks if input entity is a kind of prop that is supported by this tool
function TOOL:IsSupportedPropAndValid( entity )
	if ( !IsValid( entity ) ) then return false end
	local entityClass = entity:GetClass()

	if ( entityClass == "prop_physics" || entityClass == "prop_effect" || entityClass == "prop_dynamic" || entity:IsRagdoll() ) then
		return true
	end

	return false
end

-- Checks if path is for a model or a folder, if a folder then it returns a table of models in that folder. There are some instances where double // can occur but doesn't really matter
local function CheckModelPath( inputPath )
	-- Does path end with .mdl, if not then assume it's a folder path and set isModel to false
	if ( inputPath:sub( -4 ) == ".mdl" ) then
		return { inputPath }
	else
		-- Finds every model file in a path and adds them to a table
		local tempMdlTable = file.Find( inputPath .. "/*.mdl", "GAME" )

		-- file.Find returns file name, so need to add the rest of the path
		for i, fileName in pairs( tempMdlTable ) do
			tempMdlTable[i] = inputPath .. "/" .. fileName
			-- print( i .. "   Found model in path:   " .. tempMdlTable[i] )
		end

		return tempMdlTable
	end
end

-- Returns a random model path depending on probability
local function GetRandomModelPath( sid )
	-- Add every models probability together
	local probabilitySum = 0
	for _, probability in pairs( modelPathTable[sid] ) do
		probabilitySum = probabilitySum + probability
	end

	-- Generate a random number and loop until it goes under 0 and return that path
	local random = math.Rand( 0, probabilitySum )
	for path, probability in pairs( modelPathTable[sid] ) do
		-- print( "path " .. path .. "     random " .. random .. "     probability " .. probability )
		random = random - probability
		if random <= 0 then return path end
	end
end

-- Checks the normal trace vs a trace against a plane at the players feet, if the plane trace is closer it will override the input trace position and normal
function TOOL:CheckPlaneTrace( trace )
	local localGroundPlane = tobool( self:GetClientNumber( "localGroundPlane" ) )
	if ( !localGroundPlane ) then return end

	local player = self:GetOwner()
	local eyePosition = player:EyePos()
	local eyeAngles = player:EyeAngles():Forward()
	local playerPosition = player:GetPos()

	-- The main magic that does the plane trace, thank garry I didn't have to do this manually as I was fearing
	planeHitPosition = util.IntersectRayWithPlane( eyePosition, eyeAngles, playerPosition, Angle():Up() )

	-- If plane trace is not valid then return
	if ( planeHitPosition == nil ) then return end

	-- Measure distance of the normal trace and the plane trace to compare
	local traceHitDistance = eyePosition:DistToSqr( trace.HitPos )
	local planeHitDistance = eyePosition:DistToSqr( planeHitPosition )

	-- If plane hit is closer than trace hit then override the trace hit position and normal so it will be used instead
	if ( planeHitDistance < traceHitDistance ) then
		trace.HitPos = planeHitPosition
		trace.HitNormal = Vector()
		trace.HitNormal.Z = trace.HitNormal.Z + 90
	end
end

-- [[----------------------------------------------------------------]] -- ARRAY CREATION AND MODIFICATION

-- Calculates the position array for both preview and spawning
function TOOL:CreateLocalTransformArray()
	local xAmount = self:GetClientNumber( "xAmount" )
	local yAmount = self:GetClientNumber( "yAmount" )
	local zAmount = self:GetClientNumber( "zAmount" )

	local xSpacingBase = self:GetClientNumber( "xSpacingBase" )
	local ySpacingBase = self:GetClientNumber( "ySpacingBase" )
	local zSpacingBase = self:GetClientNumber( "zSpacingBase" )

	local xGapInterval = self:GetClientNumber( "xGapInterval" )
	local yGapInterval = self:GetClientNumber( "yGapInterval" )
	local zGapInterval = self:GetClientNumber( "zGapInterval" )

	local xGapSpacing = self:GetClientNumber( "xGapSpacing" )
	local yGapSpacing = self:GetClientNumber( "yGapSpacing" )
	local zGapSpacing = self:GetClientNumber( "zGapSpacing" )

	local xGapStart = self:GetClientNumber( "xGapStart" )
	local yGapStart = self:GetClientNumber( "yGapStart" )
	local zGapStart = self:GetClientNumber( "zGapStart" )

	local arrayType = self:GetClientNumber( "arrayType" )

	-- Calculate the array positions for a single axis at a time
	local function CalculateSingleAxisPoints( pointAmount, pointSpacing, gapIncrement, gapSize, gapStartPoint )
		local pointTable = {}
		local combinedGapSize = 0
		local gapCount = gapStartPoint

		for i = 0, pointAmount - 1 do
			if ( gapCount == i ) then
				combinedGapSize = combinedGapSize + gapSize
				gapCount = gapCount + gapIncrement
			end
			pointTable[i] = pointSpacing * i + combinedGapSize
		end

		return pointTable
	end

	local xTable = CalculateSingleAxisPoints( xAmount, xSpacingBase, xGapInterval, xGapSpacing, xGapStart )
	local yTable = CalculateSingleAxisPoints( yAmount, ySpacingBase, yGapInterval, yGapSpacing, yGapStart )
	local zTable = CalculateSingleAxisPoints( zAmount, zSpacingBase, zGapInterval, zGapSpacing, zGapStart )

	-- Saved for array pivot calculations later
	maxArrayPosition = Vector( xTable[#xTable], yTable[#yTable], zTable[#zTable] )

	local tempTable = {}
	local i = 0

	-- Calculate the full array from each axis table
	for x = 0, #xTable do
		for y = 0, #yTable do
			for z = 0, #zTable do
				local topBottomOutline = ( x == 0 || y == 0 || x == #xTable || y == #yTable ) && ( z == 0 || z == #zTable )
				local verticalSideLines = x == 0 && y == 0 || x == #xTable && y == #yTable || x == 0 && y == #yTable || y == 0 && x == #xTable

				local outline = ( topBottomOutline || verticalSideLines ) && arrayType == 3
				local hollow = ( x == 0 || x == #xTable || y == 0 || y == #yTable || z == 0 || z == #zTable  ) && arrayType == 2
				local full = arrayType == 1

				local xyCheckeredValue = ( x % 2 + y % 2 ) % 2
				local xyCheckered = ( xyCheckeredValue == 0 ) && arrayType == 6
				local xyCheckeredInverted = ( xyCheckeredValue == 1 ) && arrayType == 7
				local xyzCheckered = ( ( xyCheckeredValue + z ) % 2 == 0 ) && arrayType == 4
				local xyzCheckeredInverted = ( ( xyCheckeredValue + z ) % 2 == 1 ) && arrayType == 5

				if ( full || hollow || outline || xyzCheckered || xyzCheckeredInverted || xyCheckered || xyCheckeredInverted ) then
					tempTable[i] = Vector( xTable[x], yTable[y], zTable[z] )
					i = i + 1
				end
			end
		end
	end

	-- Check if the array count has changed and update the convar if so (triggering it's callbacks)
	local arrayCount = self:GetClientNumber( "arrayCount" )
	if ( arrayCount != i && CLIENT ) then
		GetConVar( "rat_arrayCount" ):SetInt( i )
	end

	return tempTable
end

-- Randomly offsets the input position by the random offset convars, should be called before ModifyTransformArray
function TOOL:RandomizeTransformArrayPosition( transformArray )
	local xOffsetRandom = self:GetClientNumber( "xOffsetRandom" )
	local yOffsetRandom = self:GetClientNumber( "yOffsetRandom" )
	local zOffsetRandom = self:GetClientNumber( "zOffsetRandom" )

	if ( xOffsetRandom == 0 && yOffsetRandom == 0 && zOffsetRandom == 0 ) then return end

	-- Offset each position in array
	for i, transform in pairs( transformArray ) do
		local xOffset = math.random( xOffsetRandom * -1, xOffsetRandom )
		local yOffset = math.random( yOffsetRandom * -1, yOffsetRandom )
		local zOffset = math.random( zOffsetRandom * -1, zOffsetRandom )
		local offset = Vector( xOffset, yOffset, zOffset )
		transform:Add( offset )
	end
end

-- A bit unconventional, but this function modifies the original array and returns the angle of the array plus prop rotation
function TOOL:ModifyTransformArray( trace, transformArray ) -- Calculates the position array for both preview and spawning
	local xRotationBase = self:GetClientNumber( "xRotationBase" )
	local yRotationBase = self:GetClientNumber( "yRotationBase" )
	local zRotationBase = self:GetClientNumber( "zRotationBase" )

	local xArrayPivot = self:GetClientNumber( "xArrayPivot" )
	local yArrayPivot = self:GetClientNumber( "yArrayPivot" )
	local zArrayPivot = self:GetClientNumber( "zArrayPivot" )

	local xArrayRotation = self:GetClientNumber( "xArrayRotation" )
	local yArrayRotation = self:GetClientNumber( "yArrayRotation" )
	local zArrayRotation = self:GetClientNumber( "zArrayRotation" )

	local ignoreSurfaceAngle = tobool( self:GetClientNumber( "ignoreSurfaceAngle" ) )
	local facePlayerZ = tobool( self:GetClientNumber( "facePlayerZ" ) )
	local pushAwayFromSurface = self:GetClientNumber( "pushAwayFromSurface" )

	-- Calcultate the array offset based on the pivot values
	local arrayPivot = Vector( xArrayPivot, yArrayPivot, zArrayPivot ) * maxArrayPosition

	-- Correct the hit angle
	local correctedHitAngle = trace.HitNormal:Angle()
	correctedHitAngle.X = correctedHitAngle.X + 90
	correctedHitAngle:Normalize()
	local tempAngle = correctedHitAngle + Angle()

	-- Push the array away from the hit surface in the angle of the surface
	local surfacePushOffset = correctedHitAngle:Up() * pushAwayFromSurface

	-- Ignore surface angle and set it do a default world angle, or face player on z axis
	if ( ignoreSurfaceAngle ) then
		if ( facePlayerZ ) then
			tempAngle = Angle( 0, self:GetOwner():EyeAngles().Y, 0 )
		else
			tempAngle = Angle()
		end
	end

	-- Angle for the array
	tempAngle:RotateAroundAxis( tempAngle:Forward(), xArrayRotation ) -- X
	tempAngle:RotateAroundAxis( tempAngle:Right(), yArrayRotation ) -- Y
	tempAngle:RotateAroundAxis( tempAngle:Up(), zArrayRotation ) -- Z

	-- Offset and rotate the array positions
	for i, transform in pairs( transformArray ) do
		transform:Sub( arrayPivot )
		transform:Rotate( tempAngle )
		transform:Add( surfacePushOffset )
	end

	-- Angle for each element on top of the array rotation
	tempAngle:RotateAroundAxis( tempAngle:Forward(), xRotationBase ) -- X
	tempAngle:RotateAroundAxis( tempAngle:Right(), yRotationBase ) -- Y
	tempAngle:RotateAroundAxis( tempAngle:Up(), zRotationBase ) -- Z

	return tempAngle
end

-- Randomly rotates the input angle by the random rotation convars
function TOOL:RandomizeRotation( baseRotation )
	local xRotationRandom = self:GetClientNumber( "xRotationRandom" )
	local yRotationRandom = self:GetClientNumber( "yRotationRandom" )
	local zRotationRandom = self:GetClientNumber( "zRotationRandom" )

	local xRotationRandomStepped = self:GetClientNumber( "xRotationRandomStepped" )
	local yRotationRandomStepped = self:GetClientNumber( "yRotationRandomStepped" )
	local zRotationRandomStepped = self:GetClientNumber( "zRotationRandomStepped" )

	local tempAngle = Angle() + baseRotation
	local snapAngle = Angle( math.random( 0, 359 ), math.random( 0, 359 ), math.random( 0, 359 ) )

	if ( xRotationRandomStepped >= 1 ) then
		snapAngle:SnapTo( "pitch", xRotationRandomStepped )
		tempAngle:RotateAroundAxis( tempAngle:Forward(), snapAngle.X ) -- X
	end

	if ( yRotationRandomStepped >= 1 ) then
		snapAngle:SnapTo( "yaw", yRotationRandomStepped )
		tempAngle:RotateAroundAxis( tempAngle:Right(), snapAngle.Y ) -- Y
	end

	if ( zRotationRandomStepped >= 1 ) then
		snapAngle:SnapTo( "roll", zRotationRandomStepped )
		tempAngle:RotateAroundAxis( tempAngle:Up(), snapAngle.Z ) -- Z
	end

	if ( xRotationRandom != 0 || yRotationRandom != 0 || zRotationRandom != 0 ) then
		xRotationRandom = math.random( xRotationRandom * -1, xRotationRandom )
		yRotationRandom = math.random( yRotationRandom * -1, yRotationRandom )
		zRotationRandom = math.random( zRotationRandom * -1, zRotationRandom )

		tempAngle:RotateAroundAxis( tempAngle:Forward(), xRotationRandom ) -- X
		tempAngle:RotateAroundAxis( tempAngle:Right(), yRotationRandom ) -- Y
		tempAngle:RotateAroundAxis( tempAngle:Up(), zRotationRandom ) -- Z
	end

	return tempAngle
end

-- [[----------------------------------------------------------------]] -- PROP MANIPULATION

-- Randomizes input entity in multiple ways
function TOOL:RandomizeProp( entity )
	if ( !self:IsSupportedPropAndValid( entity ) ) then return false end

	local randomSkin = tobool( self:GetClientNumber( "randomSkin" ) )
	local randomSkinStart = self:GetClientNumber( "randomSkinStart" )
	local randomSkinEnd = self:GetClientNumber( "randomSkinEnd" )
	local randomBodygroup = tobool( self:GetClientNumber( "randomBodygroup" ) )
	local randomBodygroupStart = self:GetClientNumber( "randomBodygroupStart" ) + 1
	local randomBodygroupEnd = self:GetClientNumber( "randomBodygroupEnd" ) + 1
	local randomColor = tobool( self:GetClientNumber( "randomColor" ) )

	local entityClass = entity:GetClass()
	if ( entityClass == "prop_effect" ) then entity = entity.AttachedEntity end -- Needed to change prop_effects when tracing directly

	-- print( "entity skin count " .. entity:SkinCount() )
	-- print( "entity number of bodygroup " .. entity:GetNumBodyGroups() )

	-- Pick a random skin within the range
	randomSkinEnd = ( entity:SkinCount() - 1 > randomSkinEnd ) && randomSkinEnd || entity:SkinCount() - 1

	if ( randomSkin ) then
		entity:SetSkin( math.random( randomSkinStart, randomSkinEnd ) )
	end

	-- Randomize bodygroups within the range, 0 seems to be base mesh, so we skip that by adding 1 to the start and end values above
	randomBodygroupEnd = ( entity:GetNumBodyGroups() > randomBodygroupEnd ) && randomBodygroupEnd || entity:GetNumBodyGroups()

	if ( randomBodygroup ) then
		for i = randomBodygroupStart, randomBodygroupEnd do
			entity:SetBodygroup( i, math.random( 0, entity:GetBodygroupCount( i ) - 1 ) )
		end
	end

	-- self:GetOwner():Say( "randomBodygroupStart " .. randomBodygroupStart )
	-- self:GetOwner():Say( "randomBodygroupEnd " .. randomBodygroupEnd )

	-- Randomize color
	if ( randomColor ) then
		entity:SetColor( ColorRand() )
	end

	return true
end

-- Spawns props from positions in a table
function TOOL:SpawnPropTable( player, trace, sid )
	local spawnedAnyProps = false

	if ( next( modelPathTable ) == nil ) then return end
	if ( next( modelPathTable[sid] ) == nil ) then return end
	local transformTable = self:CreateLocalTransformArray()
	if ( next( transformTable ) == nil ) then return end

	-- Check if we should use normal or plane trace, modifies original trace data
	self:CheckPlaneTrace( trace )

	-- Adds random offsets to the whole array
	self:RandomizeTransformArrayPosition( transformTable )
	-- Offsets and rotates the array as a whole, and returns the array ralative rotation for props
	local elementAngleStatic = self:ModifyTransformArray( trace, transformTable )
	local elementAngle = Angle()

	local spawnChance = self:GetClientNumber( "spawnChance" )
	local spawnFrozen = tobool( self:GetClientNumber( "spawnFrozen" ) )
	local freezeRootBoneOnly = tobool( self:GetClientNumber( "freezeRootBoneOnly" ) )
	local randomRagdollPose = tobool( self:GetClientNumber( "randomRagdollPose" ) )
	local noCollide = tobool( self:GetClientNumber( "noCollide" ) )
	local noShadow = tobool( self:GetClientNumber( "noShadow" ) )

	undo.Create( "rat_array_prop" )
	undo.SetCustomUndoText( "#tool.rat.undo" )
	undo.SetPlayer( player )

	-- Loop per position in the table
	for i, transform in pairs( transformTable ) do
		if ( !player:CheckLimit( "props" ) ) then break end
		-- Check spawn chance
		if ( spawnChance < math.random( 1, 100 ) ) then continue end

		-- Adds random rotation to input angle
		elementAngle = self:RandomizeRotation( elementAngleStatic )

		local modelPath = GetRandomModelPath( sid )
		local entityType = "prop_effect"
		-- Think this valid check includes checking for collision, so a model without collision will be a prop_effect?
		if ( util.IsValidProp( modelPath ) ) then entityType = "prop_physics" end
		if ( util.IsValidRagdoll( modelPath ) ) then entityType = "prop_ragdoll" end

		local entity = ents.Create( entityType )
		entity:SetModel( modelPath )
		entity:SetPos( trace.HitPos + transform )
		entity:SetAngles( elementAngle )
		entity:Spawn()
		entity:DrawShadow( !noShadow )

		self:RandomizeProp( entity )

		-- Make a prop_dynamic and set a random frame from a random animation that model has
		local animationEntity = nil
		if ( randomRagdollPose && spawnFrozen && !freezeRootBoneOnly ) then
			animationEntity = ents.Create( "prop_dynamic" )
			animationEntity:SetModel( modelPath )
			animationEntity:SetPos( trace.HitPos + transform )
			animationEntity:SetAngles( elementAngle )
			animationEntity:SetNoDraw( true )
			animationEntity:Spawn()

			local sequenceCount = animationEntity:GetSequenceCount()
			if ( sequenceCount > 1 ) then
				local sequenceRandom = math.random( 1, sequenceCount - 1 )
				local sequenceLabel = animationEntity:GetSequenceInfo( sequenceRandom ).label

				-- Animations containing these words are mostly T-pose so reroll and choose a different animation
				while ( string.find( sequenceLabel, "gesture" ) || string.find( sequenceLabel, "accent" ) || string.find( sequenceLabel, "Delta" ) ||
				string.find( sequenceLabel, "Frame" ) || string.find( sequenceLabel, "g_" ) || string.find( sequenceLabel, "G_" ) ||
				string.find( sequenceLabel, "apex" ) || string.find( sequenceLabel, "Spine" ) ) do
					sequenceRandom = math.random( 1, sequenceCount - 1 )
					sequenceLabel = animationEntity:GetSequenceInfo( sequenceRandom ).label
					-- print( "rerolled " .. sequenceLabel )
				end
				animationEntity:SetSequence( sequenceRandom )
				animationEntity:SetCycle( math.Rand( 0, 1 ) )
			else
				-- If jus one sequence (base pose) then remove the animationEntity to avoid some calculation
				animationEntity:Remove()
				animationEntity = nil
			end
		end

		-- Freeze prop (prop_effect doesn't move so don't freeze them)
		if ( spawnFrozen && entityType != "prop_effect" ) then
			local phys = entity:GetPhysicsObject()

			if ( entity:IsRagdoll() && !freezeRootBoneOnly ) then
				local boneCount = entity:GetPhysicsObjectCount()

				for bone = 0, boneCount - 1 do
					local physBone = entity:GetPhysicsObjectNum( bone )
					physBone:EnableMotion( false )
					-- Causes severe lag because of the halo effect, but can be a bit confusing/annoying to unfreeze a ragdoll without..
					player:AddFrozenPhysicsObject( entity, physBone )

					-- Copy bone positions from animationEntity to the ragdoll
					if ( animationEntity == nil ) then continue end

					-- Delay so it will start copying after the prop_dynamic animation is set
					timer.Simple( 0.1, function()
						local animBoneNum = entity:TranslatePhysBoneToBone( bone )
						local pos, ang = animationEntity:GetBonePosition( animBoneNum )
						physBone:SetPos( pos )
						physBone:SetAngles( ang )
					end )
				end
			elseif ( phys:IsValid() ) then
				phys:EnableMotion( false )
				player:AddFrozenPhysicsObject( entity, phys )
			end
		end

		-- Remove the animationEntity if it has been used
		if ( animationEntity != nil ) then
			timer.Simple( 0.2, function()
				animationEntity:Remove()
			end )
		end

		if ( noCollide && entityType != "prop_effect" ) then
			entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		-- Add entity to undo and cleanup
		undo.AddEntity( entity )
		player:AddCleanup( "rat_arrays", entity )
		player:AddCount( "props", entity )

		spawnedAnyProps = true
	end

	undo.Finish()

	return spawnedAnyProps
end

-- Removes input entity
function TOOL:RemoveProp( entity )
	if ( !self:IsSupportedPropAndValid( entity ) ) then return false end

	-- Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll( entity )

	-- Wait just a little bit before removing the model so the remove effect will show every time
	timer.Simple( 0.1, function() if ( IsValid( entity ) ) then entity:Remove() end end )

	-- Make it non solid and invisible since it's not removed instantly
	entity:SetNotSolid( true )
	entity:SetMoveType( MOVETYPE_NONE )
	entity:SetNoDraw( true )

	-- Particle effect for removing
	local effect = EffectData()
	effect:SetOrigin( entity:GetPos() )
	effect:SetEntity( entity )
	util.Effect( "entity_remove", effect, true, true )

	return true
end

-- [[----------------------------------------------------------------]] -- TOOL ACTIONS

function TOOL:LeftClick( trace )
	if ( SERVER ) then
		local player = self:GetOwner()
		local sid = player:SteamID()

		-- Spawns the props
		return self:SpawnPropTable( player, trace, sid )
	end

	-- Doing client side approximate checks for user feedback from the tool since the server return doesn't work clientside when on a server, in single player this code isn't reached
	-- Sadly can't do as good of a check for client side so just checking if the model table is empty, works well enough for most cases
	if ( CLIENT ) then
		if ( next( modelPathTable ) != nil ) then
			return true
		else
			return false
		end
	end
end

function TOOL:RightClick( trace )
	local sphereRadius = self:GetClientNumber( "sphereRadius" )

	if ( SERVER ) then
		local randomizedAnyProps = false

		if ( sphereRadius == 0 ) then
			-- Randomize prop under cursor
			randomizedAnyProps = self:RandomizeProp( trace.Entity )
		else
			-- Randomize props found within sphere volume
			local foundEnts = ents.FindInSphere( trace.HitPos, sphereRadius )

			-- Run randomization loop and save if any were successful
			for i, entity in pairs( foundEnts ) do
				if ( self:RandomizeProp( entity ) ) then randomizedAnyProps = true end
			end
		end

		return randomizedAnyProps
	end

	-- Doing client side approximate checks for user feedback from the tool since the server return doesn't work clientside when on a server, in single player this code isn't reached
	if ( CLIENT ) then
		if ( sphereRadius == 0 ) then
			-- Check if prop under cursor is a supported prop
			return self:IsSupportedPropAndValid( trace.Entity )
		else
			-- Return true if there are supported props within the sphere volume
			local foundEnts = ents.FindInSphere( trace.HitPos, sphereRadius )

			for i, entity in pairs( foundEnts ) do
				if ( self:IsSupportedPropAndValid( entity ) ) then
					return true
				end
			end
				return false
		end
	end
end

function TOOL:Reload( trace )
	local sphereRadius = self:GetClientNumber( "sphereRadius" )

	if ( SERVER ) then
		local removedAnyProps = false

		if ( sphereRadius == 0 ) then
			-- Remove prop under cursor
			removedAnyProps = self:RemoveProp( trace.Entity )
		else
			-- Remove props found within sphere volume
			local foundEnts = ents.FindInSphere( trace.HitPos, sphereRadius )

			-- Run remove loop and save if any were successful
			for i, entity in pairs( foundEnts ) do
				if ( self:RemoveProp( entity ) ) then removedAnyProps = true end
			end
		end

		return removedAnyProps
	end

	-- Doing client side approximate checks for user feedback from the tool since the server return doesn't work clientside when on a server, in single player this code isn't reached
	if ( CLIENT ) then
		if ( sphereRadius == 0 ) then
			-- Check if prop under cursor is a supported prop
			return self:IsSupportedPropAndValid( trace.Entity )
		else
			-- Return true if there are supported props within the sphere volume
			local foundEnts = ents.FindInSphere( trace.HitPos, sphereRadius )

			for i, entity in pairs( foundEnts ) do
				if ( self:IsSupportedPropAndValid( entity ) ) then
					return true
				end
			end
				return false
		end
	end
end

function TOOL:Think()
	if ( CLIENT ) then
		toolActive = true
	end
end

function TOOL:Holster()
	if ( CLIENT ) then
		toolActive = false
	end
end

gameevent.Listen( "player_connect_client" )
hook.Add( "player_connect_client", "rat_player_connect", function( data )
	local sid = data.networkid	-- Same as Player:SteamID()

	-- The table is stored server side, so we make sure to reset it every time someone joins to match the local empty model list
	-- Also fixes an error that could happen the first time someone joins, if they try to click before adding any models to the list
	modelPathTable[sid] = {}
end )

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
-------------------------UI-------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

-- [[----------------------------------------------------------------]] -- WORLD SPACE PREVIEWS

-- Render hook for drawing visualizations for array positions and some more
hook.Add( "PostDrawTranslucentRenderables", "rat_ArrayPreviewRender", function( bDrawingDepth, bDrawingSkybox )
	local playerTool = LocalPlayer():GetTool()
	if ( toolActive && playerTool && !bDrawingSkybox ) then
		local trace = LocalPlayer():GetEyeTrace()
		-- Check if we should use normal or plane trace, modifies original trace data
		playerTool:CheckPlaneTrace( trace )

		local traceHitDistance = LocalPlayer():EyePos():Distance( trace.HitPos )
		local previewPointAxis = tobool( playerTool:GetClientNumber( "previewPointAxis" ) )
		local previewPointAxisSize = playerTool:GetClientNumber( "previewPointAxisSize" )
		local previewArrayBounds = tobool( playerTool:GetClientNumber( "previewArrayBounds" ) )

		local transformTable = {}

		-- Calculate array if either point previews or array previews are active
		-- It's a bit wastefull if only bounds are on but much easier than having to keep track of when bounds should be updated otherwise
		if ( previewPointAxis || previewArrayBounds ) then
			transformTable = playerTool:CreateLocalTransformArray()
		end

		-- Render per position visualization
		if ( previewPointAxis ) then
			if ( next( transformTable ) == nil ) then return end

			-- playerTool:RandomizeTransformArrayPosition( transformTable ) -- For easy debugging of random positions
			local elementAngle = playerTool:ModifyTransformArray( trace, transformTable )
			-- elementAngle = playerTool:RandomizeRotation( elementAngle ) -- For easy debugging of random rotations

			local pointXAxisLine = elementAngle:Forward() * previewPointAxisSize
			local pointYAxisLine = elementAngle:Right() * previewPointAxisSize * -1
			local pointZAxisLine = elementAngle:Up() * previewPointAxisSize

			for i, transform in pairs( transformTable ) do
				local pointPosition = trace.HitPos + transform
				render.DrawLine( pointPosition, pointPosition + pointXAxisLine, Color( 255, 0, 0, 255 ), true ) -- Red
				render.DrawLine( pointPosition, pointPosition + pointYAxisLine, Color( 0, 255, 0, 255 ), true ) -- Green
				render.DrawLine( pointPosition, pointPosition + pointZAxisLine, Color( 0, 0, 255, 255 ), true ) -- Blue
			end
		end

		-- Render thicc axis at cursor trace hit
		local previewTraceAxisSize = playerTool:GetClientNumber( "previewTraceAxisSize" )
		local previewTraceAxisDistanceSize = previewTraceAxisSize * ( traceHitDistance / 400 )
		local correctedHitAngle = trace.HitNormal:Angle()
		correctedHitAngle.X = correctedHitAngle.X + 90
		correctedHitAngle:Normalize()
		local thicc = 0.3 * ( traceHitDistance / 400 )
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( previewTraceAxisDistanceSize, thicc, thicc ), Color( 255, 0, 0, 255 ) , false )
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, previewTraceAxisDistanceSize, thicc ), Color( 0, 255, 0, 255 ) , false )
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, thicc, previewTraceAxisDistanceSize ), Color( 0, 0, 255, 255 ) , false )

		-- Render single box that envelops the whole array
		if ( previewArrayBounds ) then
			local ignoreSurfaceAngle = tobool( playerTool:GetClientNumber( "ignoreSurfaceAngle" ) )
			local facePlayerZ = tobool( playerTool:GetClientNumber( "facePlayerZ" ) )
			local pushAwayFromSurface = playerTool:GetClientNumber( "pushAwayFromSurface" )

			local tempAngle = correctedHitAngle + Angle()

			-- Push the array away from the hit surface in the angle of the surface
			local surfacePushOffset = correctedHitAngle:Up() * pushAwayFromSurface

			-- Ignore surface angle and set it do a default world angle, or face player on z axis
			if ( ignoreSurfaceAngle ) then
				if ( facePlayerZ ) then
					tempAngle = Angle( 0, playerTool:GetOwner():EyeAngles().Y, 0 )
				else
					tempAngle = Angle()
				end
			end

			local arrayPivot = Vector( playerTool:GetClientNumber( "xArrayPivot" ), playerTool:GetClientNumber( "yArrayPivot" ), playerTool:GetClientNumber( "zArrayPivot" ) )
			local boundEdgeSpacing = Vector( -10, -10, -10 )
			local boundOffset = maxArrayPosition * arrayPivot
			boundOffset:Rotate( tempAngle )
			boundOffset:Sub( surfacePushOffset )
			render.DrawWireframeBox( trace.HitPos - boundOffset, tempAngle, boundEdgeSpacing, maxArrayPosition - boundEdgeSpacing, Color( 0, 255, 255, 127 ), false )
		end

		-- Render sphere for sphere volume
		local sphereRadius = playerTool:GetClientNumber( "sphereRadius" )

		if ( sphereRadius > 0 ) then
			render.DrawWireframeSphere( trace.HitPos, sphereRadius, 10, 10, Color( 0, 255, 255, 255 ), true )
		end
	end
end )

-- [[----------------------------------------------------------------]] -- TOOL SCREEN

-- Function to draw an axis line visualization on the tool screen
local function Draw2DAxisLine( startPosition, lineVector, lineLength, lineColor )
	local endPosition = Vector() + startPosition
	endPosition:Add( lineVector * lineLength )
	surface.SetDrawColor( lineColor )

	-- Render the line, doing it 3 times with a one pixel offset to make them thicker
	surface.DrawLine( startPosition.X, startPosition.Y, endPosition.X, endPosition.Y )
	surface.DrawLine( startPosition.X + 1, startPosition.Y, endPosition.X + 1, endPosition.Y )
	surface.DrawLine( startPosition.X, startPosition.Y + 1, endPosition.X, endPosition.Y + 1 )
end

-- Function to draw an axis plane visualization on the tool screen
local function Draw2DAxisPlane( startPosition, axisVector1, axisVector2, axisLength, planeColor )
	-- Set up vertex data for quad
	local vert1 = startPosition
	local vert2 = Vector() + vert1
	local vert3 = Vector() + vert1
	local vert4 = Vector() + vert1

	vert2:Add( axisVector1 * axisLength )
	vert3:Add( axisVector1 * axisLength )
	vert3:Add( axisVector2 * axisLength ) -- Vert 3 gets both axis vectors added since it's the outermost vert
	vert4:Add( axisVector2 * axisLength )

	local verts = {
		{ x = vert1.X, y = vert1.Y },
		{ x = vert2.X, y = vert2.Y },
		{ x = vert3.X, y = vert3.Y },
		{ x = vert4.X, y = vert4.Y },
	}

	-- Set color and draw quad
	surface.SetDrawColor( planeColor )
	draw.NoTexture()
	surface.DrawPoly( verts )
end

-- Make material for tool screen
local toolScreenRatMaterial = Material( "materials/rat_assets/rat_head.png", "noclamp ignorez mips" )

-- Draw tool screen, size is 256 x 256
function TOOL:DrawToolScreen( width, height )
	local xColor = Color( 255, 75, 75 )
	local yColor = Color( 75, 255, 75 )
	local zColor = Color( 75, 75, 255 )

	surface.SetDrawColor( Color( 20, 20, 20 ) )
	surface.DrawRect( 0, 0, width, height )

	-- Draw scrolling background, is additive to the rect above
	surface.SetMaterial( toolScreenRatMaterial )
	local uvOffset = math.TimeFraction( 0, 1, CurTime() / 10 )
	surface.DrawTexturedRectUV( 0, 0, width, height, 0 + uvOffset, -0.2, 1 + uvOffset, 0.8 )

	-- Tool title text, top left
	draw.SimpleText( "Random", "DermaLarge", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "Array", "DermaLarge", 10, 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "Tool", "DermaLarge", 10, 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	-- Cursor world position text, top right
	local trace = self:GetOwner():GetEyeTrace()
	draw.SimpleText( "X " .. math.Round( trace.HitPos.X ), "DermaLarge", 246, 10, xColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	draw.SimpleText( "Y " .. math.Round( trace.HitPos.Y ), "DermaLarge", 246, 40, yColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	draw.SimpleText( "Z " .. math.Round( trace.HitPos.Z ), "DermaLarge", 246, 70, zColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

	-- Set up needed data for screen axis visualization, and correcting the base rotation
	local baseEyeAngle = self:GetOwner():EyeAngles()
	local axisAngle = Angle( 90, 0, 90 )
	local lineLength = 50

	-- Rotating the screen axis according to player view, a bit confusing what axis does what, but it works
	axisAngle:RotateAroundAxis( Angle():Right(), baseEyeAngle.Y * -1 ) -- Z according to the local screen axis
	axisAngle:RotateAroundAxis( Angle():Forward(), baseEyeAngle.X ) -- Y according to the local screen axis

	-- Draw axis line visualization helpers
	Draw2DAxisLine( Vector( 128, 190 ), axisAngle:Forward() * -1, lineLength, xColor )
	Draw2DAxisLine( Vector( 128, 190 ), axisAngle:Right(), lineLength, yColor )
	Draw2DAxisLine( Vector( 128, 190 ), axisAngle:Up(), lineLength, zColor )

	-- Draw axis plane visualization helpers
	Draw2DAxisPlane( Vector( 128, 190 ), axisAngle:Right(), axisAngle:Forward() * -1, lineLength, Color( 255, 255, 100, 2 ) )
	Draw2DAxisPlane( Vector( 128, 190 ), axisAngle:Up(), axisAngle:Right(), lineLength, Color( 100, 255, 255, 2 ) )
	Draw2DAxisPlane( Vector( 128, 190 ), axisAngle:Forward() * -1, axisAngle:Up(), lineLength, Color( 255, 100, 255, 2 ) )
end

-- [[----------------------------------------------------------------]] -- UI CREATION FUNCTIONS

-- Creates icons for the prop list
local function AddSpawnIcon( inputListPanel, inputModelPath )
	for i, path in ipairs( CheckModelPath( inputModelPath ) ) do
		-- If path (model) already exists then don't add a new spawn icon for it
		if ( modelPathTable[path] != nil ) then continue end

		local ListItem = inputListPanel:Add( "SpawnIcon" )
		ListItem:SetSize( 64, 64 )
		ListItem:SetModel( path )

		ListItem.DoRightClick = function()
			if ( modelPathTable[path] != nil ) then
				modelPathTable[path] = nil
			end
			UpdateServerTable()
			ListItem:Remove()
		end

		-- Probability UI
		local probabilityTextBlack = vgui.Create( "DLabel", ListItem )
		probabilityTextBlack:SetText( string.format( "%.2f", 1 ) )
		probabilityTextBlack:Dock( NODOCK )
		probabilityTextBlack:SetPos( 7, 3 )
		probabilityTextBlack:SetSize( 40, 15 )
		probabilityTextBlack:SetColor( color_black )

		local probabilityTextWhite = vgui.Create( "DLabel", ListItem )
		probabilityTextWhite:SetText( string.format( "%.2f", 1 ) )
		probabilityTextWhite:Dock( NODOCK )
		probabilityTextWhite:SetPos( 5, 2 )
		probabilityTextWhite:SetSize( 40, 15 )
		probabilityTextWhite:SetColor( color_white )

		local probabilityScratch = vgui.Create( "DNumberScratch", ListItem )
		probabilityScratch:Dock( NODOCK )
		probabilityScratch:SetPos( 5, 5 )
		probabilityScratch:SetValue( 1 )
		probabilityScratch:SetMin( 0.01 )
		probabilityScratch:SetMax( 10 )
		probabilityScratch:SetDecimals( 2 )
		probabilityScratch:SetTooltip( "#tool.rat.propProbabilityTooltip" )
		probabilityScratch:SetColor( Color( 0, 0, 0, 0 ) )
		function probabilityScratch:OnValueChanged( val )
			local probabilityText = string.format( "%.2f", val )
			probabilityTextBlack:SetText( probabilityText )
			probabilityTextWhite:SetText( probabilityText )

			modelPathTable[path] = val
			UpdateServerTable()
		end

		modelPathTable[path] = 1
	end
end

local function MakeText( panel, color, str )
	local label = vgui.Create( "DLabel" )
	label:SetText( str )
	label:SetAutoStretchVertical( true )
	label:SetColor( color )
	label:SetWrap( true )
	panel:AddItem( label )

	return label
end

local function SetCheckboxState( checkbox, state )
	-- If using checkboxes made from MakeCheckbox there should always only be two children, 1 being the actuall checkbox and 2 being the text label
	local checkboxChildren = checkbox:GetChildren()
	checkboxChildren[1]:SetEnabled( state )
	checkboxChildren[2]:SetEnabled( state )
	checkboxChildren[2]:SetDark( state )
end

local function MakeCheckbox( panel, titleString, convar, leftSpacing )
	local contentHolder = vgui.Create( "DSizeToContents" )
	contentHolder:DockPadding( leftSpacing, -2, 0, -2 )
	contentHolder:Dock( TOP )
	panel:AddItem( contentHolder )

	local checkBox = vgui.Create( "DCheckBox", contentHolder )
	checkBox:DockMargin( 0, 3, 0, 2 )
	checkBox:SetConVar( convar )
	checkBox:Dock( LEFT )

	local label = vgui.Create( "DLabel", contentHolder )
	label:SetText( titleString )
	label:DockMargin( 10, 0, 0, 0 )
	label:SetDark( true )
	label:Dock( TOP )
	label:SetMouseInputEnabled( true )
	function label:DoClick()
		GetConVar( convar ):SetBool( !cvars.Bool( convar ) )
	end

	return contentHolder
end

local function MakeNumberWang( panel, titleString, tooltipString, convar, min, max, leftSpacing )
	local dList = vgui.Create( "DPanelList" )
	dList:Dock( TOP )
	dList:DockPadding( leftSpacing, 0, 0, 0 )
	panel:AddItem( dList )

	local numbox = vgui.Create( "DNumberWang", dList )
	numbox:SetSize( 40, 20 )
	numbox:SetPos( leftSpacing, 0 )
	numbox:SetMinMax( min, max )
	numbox:Dock( NODOCK )
	numbox:SetConVar( convar )
	numbox:SetValue( cvars.Number( convar ) )

	local label = vgui.Create( "DLabel", dList )
	label:SetText( titleString )
	label:SetDark( true )
	label:DockMargin( 50, 0, 0, 0 )
	label:Dock( TOP )
	label:SetTooltip( tooltipString )
	label:SetMouseInputEnabled( true )

	function label:DoClick()
		GetConVar( convar ):Revert()
	end
	function label:OnCursorEntered()
		label:SetColor( Color( 200, 100, 0 ) )
	end
	function label:OnCursorExited()
		label:SetColor( Color( 50, 50, 50 ) )
	end

	-- Callback to update wangs when preset changes
	cvars.AddChangeCallback( convar, function( convarName, valueOld, valueNew )
		numbox:SetValue( cvars.Number( convarName ) )
	end, convar .. "_callback" )

	return dList
end

local function MakeRangeWang( panel, titleString, tooltipString, convar, convar2, min, max, leftSpacing )
	local dList = vgui.Create( "DPanelList" )
	dList:Dock( TOP )
	dList:DockPadding( leftSpacing, 0, 0, 0 )
	panel:AddItem( dList )

	local WangHolder = vgui.Create( "DPanelList", dList )
	WangHolder:Dock( TOP )
	WangHolder:DockPadding( leftSpacing, 0, 0, 0 )
	WangHolder:SetSize( 100, 20 )
	WangHolder:SetPos( leftSpacing, 0 )
	WangHolder:Dock( NODOCK )

	local numboxStart = vgui.Create( "DNumberWang", WangHolder )
	numboxStart:SetSize( 40, 20 )
	numboxStart:SetPos( 0, 0 )
	numboxStart:SetMinMax( min, max )
	numboxStart:Dock( NODOCK )
	numboxStart:SetConVar( convar )
	numboxStart:SetValue( cvars.Number( convar ) )

	local labelTo = vgui.Create( "DLabel", WangHolder )
	labelTo:SetText( "#tool.rat.rangeTo" )
	labelTo:SetDark( true )
	labelTo:SetSize( 20, 12 )
	labelTo:SetPos( 46, 3 )
	labelTo:Dock( NODOCK )

	local numboxEnd = vgui.Create( "DNumberWang", WangHolder )
	numboxEnd:SetSize( 40, 20 )
	numboxEnd:SetPos( 60, 0 )
	numboxEnd:SetMinMax( min, max )
	numboxEnd:Dock( NODOCK )
	numboxEnd:SetConVar( convar2 )
	numboxEnd:SetValue( cvars.Number( convar2 ) )

	local label = vgui.Create( "DLabel", dList )
	label:SetText( titleString )
	label:SetDark( true )
	label:DockMargin( 110, 0, 0, 0 )
	label:Dock( TOP )
	label:SetTooltip( tooltipString )
	label:SetMouseInputEnabled( true )

	function label:DoClick()
		GetConVar( convar ):Revert()
		GetConVar( convar2 ):Revert()
	end
	function label:OnCursorEntered()
		label:SetColor( Color( 200, 100, 0 ) )
	end
	function label:OnCursorExited()
		label:SetColor( Color( 50, 50, 50 ) )
	end

	-- Callbacks to update wangs when preset changes
	-- Also to make sure the start value will not be larger than the end or oposite, and never above max
	cvars.AddChangeCallback( convar, function( convarName, valueOld, valueNew )
		valueNew = tonumber( valueNew )
		numboxStart:SetValue( valueNew )

		-- Make sure numboxEnd is never lower than numboxStart
		if ( valueNew > numboxEnd:GetValue() ) then
			numboxEnd:SetValue( valueNew )
		end

		-- Make sure convar (and numboxStart) does not go over max value
		if ( tonumber( valueNew ) > max ) then
			GetConVar( convarName ):SetFloat( max )
		end
	end, convar .. "_callback" )

	cvars.AddChangeCallback( convar2, function( convarName, valueOld, valueNew )
		valueNew = tonumber( valueNew )
		numboxEnd:SetValue( valueNew )

		-- Make sure numboxStart is never higher than numboxEnd
		if ( valueNew < numboxStart:GetValue() ) then
			numboxStart:SetValue( valueNew )
		end

		-- Make sure convar (and numboxEnd) does not go over max value
		if ( valueNew > max ) then
			GetConVar( convarName ):SetFloat( max )
		end
	end, convar2 .. "_callback" )

	return dList
end

local function MakeAxisSlider( panel, color, titleString, min, max, decimals, conVar )
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( titleString )
	slider:SetMinMax( min, max )
	slider:SetTall( 15 )
	slider:SetDecimals( decimals )
	slider:SetDark( true )
	slider:DockPadding( 10, 0, -18, 0 )
	slider:SetConVar( conVar )
	slider.Paint = function()
		surface.SetDrawColor( color )
		surface.DrawRect( 0, 3, 4, 10 )
	end
	panel:AddItem( slider )

	return slider
end

local function MakeAxisSliderGroup( panel, titleString, tooltipString, min, max, decimals, conVar1, conVar2, conVar3 )
	local groupTitle = MakeText( panel, Color( 50, 50, 50 ), titleString )
	groupTitle:SetTooltip( tooltipString )
	groupTitle:SetMouseInputEnabled( true )
	function groupTitle:DoClick()
		GetConVar( conVar1 ):Revert()
		GetConVar( conVar2 ):Revert()
		GetConVar( conVar3 ):Revert()
	end
	function groupTitle:OnCursorEntered()
		groupTitle:SetColor( Color( 200, 100, 0 ) )
	end
	function groupTitle:OnCursorExited()
		groupTitle:SetColor( Color( 50, 50, 50 ) )
	end

	MakeAxisSlider( panel, Color( 230, 0, 0 ), "#tool.rat.xAxis", min, max, decimals, conVar1 )
	MakeAxisSlider( panel, Color( 0, 230, 0 ), "#tool.rat.yAxis", min, max, decimals, conVar2 )
	MakeAxisSlider( panel, Color( 0, 0, 230 ), "#tool.rat.zAxis", min, max, decimals, conVar3 )
end

-- Very specialized but can't really get around it
local function MakeGapSliderWangCombo( panel, sliderString, axisColor, conVar1, conVar2, conVar3 )
	MakeAxisSlider( panel, axisColor, sliderString, 0, 1000, 0, conVar1 )

	local dList = vgui.Create( "DPanelList" )
	dList:DockPadding( 10, 0, 0, 0 )
	panel:AddItem( dList )

	local label = vgui.Create( "DLabel", dList )
	label:SetText( "#tool.rat.pointGapsInterval" )
	label:SetDark( true )
	label:DockMargin( 30, 0, 0, 0 )
	label:Dock( LEFT )

	local numbox = vgui.Create( "DNumberWang", dList )
	numbox:SetSize( 35, 20 )
	numbox:SetMinMax( 1, 100 )
	numbox:Dock( NODOCK )
	numbox:SetConVar( conVar2 )
	numbox:SetValue( cvars.Number( conVar2 ) )

	local label2 = vgui.Create( "DLabel", dList )
	label2:SetText( "#tool.rat.pointGapsStart" )
	label2:SetDark( true )
	label2:DockMargin( 45, 0, 0, 0 )
	label2:Dock( LEFT )

	local numbox2 = vgui.Create( "DNumberWang", dList  )
	numbox2:SetSize( 35, 20 )
	numbox2:SetPos( 110, 0 )
	numbox2:SetMinMax( 1, 100 )
	numbox2:Dock( NODOCK )
	numbox2:SetConVar( conVar3 )
	numbox2:SetValue( cvars.Number( conVar3 ) )

	cvars.AddChangeCallback( conVar2, function( convarName, valueOld, valueNew )
		numbox:SetValue( cvars.Number( convarName ) )
	end, conVar2 .. "_callback" )

	cvars.AddChangeCallback( conVar3, function( convarName, valueOld, valueNew )
		numbox2:SetValue( cvars.Number( convarName ) )
	end, conVar3 .. "_callback" )
end

local function MakeCollapsible( panel, titleString, toggleConVar )
	local toggledState = false

	if ( toggleConVar != nil ) then
		toggledState = cvars.Number( toggleConVar )
	end

	local collapsible = vgui.Create( "DCollapsibleCategory" )
	collapsible:SetLabel( titleString )
	collapsible:SetExpanded( toggledState )
	if ( toggleConVar != nil ) then
		function collapsible:OnToggle( val )
			GetConVar( toggleConVar ):SetInt( val && 1 || 0 ) -- 1 if val is true, 0 if false
		end
	end
	panel:AddItem( collapsible )

	local dList = vgui.Create( "DPanelList" )
	dList:SetAutoSize( true )
	dList:SetSpacing( 4 )
	dList:SetPadding( 8 )
	dList.Paint = function()
		surface.SetDrawColor( 235, 245, 255, 255 )
		surface.DrawRect( 0, 0, 1000, 500 )
	end
	collapsible:SetContents( dList )

	return dList
end

local function ChangeAndColorPropCount( panel, count )
	panel:SetText( language.GetPhrase( "#tool.rat.numOfProps" ) .. count )

	if ( count < 750 ) then
		panel:SetColor( Color( 250, 250, 250 ) ) -- White
	elseif ( count < 1500 ) then
		panel:SetColor( Color( 255, 200, 90 ) ) -- Orange
	else
		panel:SetColor( Color( 255, 133, 127 ) ) -- Red
	end
end

-- [[----------------------------------------------------------------]] -- CONTROL PANEL

-- Create table of all tool ConVars, used for presets
local ConVarsDefault = TOOL:BuildConVarList()
-- Remove some ConVars we don't want from the preset list, easier than adding all we want
ConVarsDefault["rat_arrayCount"] = nil
ConVarsDefault["rat_pointTransformExpanded"] = nil
ConVarsDefault["rat_arrayTransformsExpanded"] = nil
ConVarsDefault["rat_randomPointTransformsExpanded"] = nil

function TOOL.BuildCPanel( cpanel )
	MakeText( cpanel, Color( 50, 50, 50 ), "#tool.rat.desc" )

	cpanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "rat", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	MakeNumberWang( cpanel, "#tool.rat.sphereRadius", nil, "rat_sphereRadius", 0, 9999, 0 )
	MakeNumberWang( cpanel, "#tool.rat.previewTraceAxisSizeDescription", nil, "rat_previewTraceAxisSize", 1, 100, 0 )

	cpanel:ControlHelp( "" )

	MakeCheckbox( cpanel, "#tool.rat.spawnFrozen", "rat_spawnFrozen", 0 )
	local checkboxRootBoneOnly = MakeCheckbox( cpanel, "#tool.rat.freezeRootBoneOnly", "rat_freezeRootBoneOnly", 10 )
	local checkboxRandomRagdollPose = MakeCheckbox( cpanel, "#tool.rat.randomRagdollPose", "rat_randomRagdollPose", 10 )
	MakeCheckbox( cpanel, "#tool.rat.noCollide", "rat_noCollide", 0 )
	MakeCheckbox( cpanel, "#tool.rat.noShadow", "rat_noShadow", 0 )

	cpanel:ControlHelp( "" )

	MakeCheckbox( cpanel, "#tool.rat.randomSkin", "rat_randomSkin", 0 )
	MakeRangeWang( cpanel, "#tool.rat.randomSkinRange", nil, "rat_randomSkinStart", "rat_randomSkinEnd", 0, 100, 0 )

	MakeCheckbox( cpanel, "#tool.rat.randomBodygroup", "rat_randomBodygroup", 0 )
	MakeRangeWang( cpanel, "#tool.rat.randomBodygroupRange", nil, "rat_randomBodygroupStart", "rat_randomBodygroupEnd", 0, 100, 0 )

	MakeCheckbox( cpanel, "#tool.rat.randomColor", "rat_randomColor", 0 )

	cpanel:ControlHelp( "" )


	-- [[----------------------------------------------------------------]] -- PROP LIST DESCRIPTION
	local collapsible = MakeCollapsible( cpanel, "#tool.rat.listHelpTitle" )

	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp1" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp2" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp3" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp4" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp5" )


	-- [[----------------------------------------------------------------]] -- PROP GRID LIST
	cpanel:TextEntry( "#tool.rat.mdlAdd", "rat_mdlName" )

	-- Create the Scroll panel
	local Scroll = vgui.Create( "DScrollPanel" )
	Scroll:SetSize( 300, 204 )
	Scroll:SetPaintBackground( true )
	Scroll:SetBackgroundColor( Color( 240, 240, 240, 255 ) )
	Scroll:DockMargin( 0, -8, 0, 0 )

	local MdlView = vgui.Create( "DIconLayout", Scroll )
	MdlView:Dock( TOP )
	MdlView:SetSpaceY( 1 )
	MdlView:SetSpaceX( 1 )
	MdlView:SetBorder( 2 ) -- Works but not on the bottom....

	Scroll:Receiver( "SandboxContentPanel", function(self, inputPanels, dropped)
		if ( dropped ) then
			-- print( "Trying to drop" )

			for i, panel in pairs( inputPanels ) do
				if ( panel:GetName() != "SpawnIcon" ) then continue end
				local currentMdlPath = panel:GetModelName()
				AddSpawnIcon( MdlView, currentMdlPath )
			end

			UpdateServerTable()

			if ( inputPanels[1]:GetName() != "SpawnIcon" ) then return end
			-- print( "You just dropped " .. inputPanels[1]:GetModelName() .. " on me." )
		end
	end )


	local AddButton = vgui.Create( "DButton" )
	AddButton:SetText( "#tool.rat.mdlAddButton" )
	AddButton:SetTooltip( "#tool.rat.mdlAddButton" )
	AddButton.DoClick = function()
		AddSpawnIcon( MdlView, GetConVar( "rat_mdlName" ):GetString() )
		UpdateServerTable()
	end

	-- Some weird positioning here for everything to be able to reference what it needs to but still be in the right order in the ui
	-- The function needs to be made before it gets referenced, but also after the ui it is referencing, and the button needs to be added before the prop list
	cpanel:AddItem( AddButton )
	cpanel:AddItem( Scroll )


	local ResetButtonsHolder = vgui.Create( "DPanelList" )
	ResetButtonsHolder:Dock( TOP )
	ResetButtonsHolder:DockMargin( 0, -8, 0, 0 )
	cpanel:AddItem( ResetButtonsHolder )

	local ResetProbabilityButton = vgui.Create( "DButton", ResetButtonsHolder )
	ResetProbabilityButton:SetText( "#tool.rat.probabilityResetButton" )
	ResetProbabilityButton:Dock( LEFT )
	ResetProbabilityButton:SetWidth( 130 )
	ResetProbabilityButton.DoClick = function()
		for i, Icon in pairs( MdlView:GetChildren() ) do
			-- Get the children of the spawn icon to edit the probability ui
			-- Not a big fan of referencing child indicies like this but not sure how else to do it
			local checkboxChildren = Icon:GetChildren()
			checkboxChildren[2]:SetText( string.format( "%.2f", 1 ) )
			checkboxChildren[3]:SetText( string.format( "%.2f", 1 ) )
			-- Reset the DNumberScratch value
			checkboxChildren[4]:SetValue( 1 )

			modelPathTable[Icon:GetModelName()] = 1
		end
	end

	local ClearButton = vgui.Create( "DButton", ResetButtonsHolder )
	ClearButton:SetText( "#tool.rat.mdlClearButton" )
	ClearButton:Dock( RIGHT )
	ClearButton:SetWidth( 90 )
	-- ClearButton:SetTooltip( "#tool.rat.mdlAddButton" )
	ClearButton.DoClick = function()
		for i, Icon in pairs( MdlView:GetChildren() ) do
			Icon:Remove()
		end
		modelPathTable = {}
		UpdateServerTable()
	end



	-- [[----------------------------------------------------------------]] -- VARIOUS
	MakeCheckbox( cpanel, "#tool.rat.ignoreSurfaceAngle", "rat_ignoreSurfaceAngle", 0 )
	local checkboxFacePlayer = MakeCheckbox( cpanel, "#tool.rat.facePlayerZ", "rat_facePlayerZ", 10 )
	MakeCheckbox( cpanel, "#tool.rat.localGroundPlane", "rat_localGroundPlane", 0 )
	MakeNumberWang( cpanel, "#tool.rat.pushAwayFromSurface", nil, "rat_pushAwayFromSurface", -9999, 9999, 0 )


	-- [[----------------------------------------------------------------]] -- ARRAY AMOUNT
	local dListCountHolder = vgui.Create( "DPanelList" )
	dListCountHolder:SetAutoSize( true )
	dListCountHolder:SetTall( 20 )
	dListCountHolder.Paint = function()
		draw.RoundedBoxEx( 4, 0, 0, 200, 19, Color( 127, 127, 127 ), true, true, false, false )
	end
	cpanel:AddItem( dListCountHolder )

	local NumberOfPropsText = vgui.Create( "DLabel" )
	NumberOfPropsText:SetText( language.GetPhrase( "#tool.rat.numOfProps" ) .. "1" )
	NumberOfPropsText:Dock( LEFT )
	NumberOfPropsText:DockMargin( 10, 0, 0, 0 )
	NumberOfPropsText:SetFont( "DermaDefaultBold" )
	NumberOfPropsText:SetTall( 20 )
	NumberOfPropsText:SetColor( Color( 250, 250, 250 ) )
	NumberOfPropsText:SetWrap( true )
	dListCountHolder:AddItem( NumberOfPropsText )

	ChangeAndColorPropCount( NumberOfPropsText, cvars.Number( "rat_arrayCount" ) ) -- Make sure the text shows the correct count

	-- Only way I managed to get spacing on the top in this configuration was to make a spacer object sadly
	local dListSpacing = vgui.Create( "DPanelList" ) ----
	dListSpacing:DockMargin( 0, -10, 0, 0 )
	dListSpacing:SetHeight( 10 )
	dListSpacing.Paint = function()
		surface.SetDrawColor( 230, 230, 230, 255 )
		surface.DrawRect( 0, 0, 200, 200 )
	end
	cpanel:AddItem( dListSpacing )

	local dListNumber = vgui.Create( "DPanelList" ) ----
	dListNumber:DockMargin( 0, -10, 0, 0 )
	dListNumber:SetAutoSize( true )
	dListNumber:SetPadding( 4 )
	dListNumber.Paint = function()
		surface.SetDrawColor( 230, 230, 230, 255 )
		surface.DrawRect( 0, 0, 200, 200 )
	end
	cpanel:AddItem( dListNumber )

	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.xAxis" ), nil, "rat_xAmount", 1, 999, 10 )
	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.yAxis" ), nil, "rat_yAmount", 1, 999, 10 )
	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.zAxis" ), nil, "rat_zAmount", 1, 999, 10 )

	-- Only reliable way I found to update this value was a bunch of callbacks
	-- If using GetConVar within DNumberWang:OnValueChanged it would return the previous value
	cvars.AddChangeCallback( "rat_xAmount", function( convarName, valueOld, valueNew )
		LocalPlayer():GetTool( "rat" ):CreateLocalTransformArray()
	end, "rat_xAmount_callback_2" )
	cvars.AddChangeCallback( "rat_yAmount", function( convarName, valueOld, valueNew )
		LocalPlayer():GetTool( "rat" ):CreateLocalTransformArray()
	end, "rat_yAmount_callback_2" )
	cvars.AddChangeCallback( "rat_zAmount", function( convarName, valueOld, valueNew )
		LocalPlayer():GetTool( "rat" ):CreateLocalTransformArray()
	end, "rat_zAmount_callback_2" )
	cvars.AddChangeCallback( "rat_arrayType", function( convarName, valueOld, valueNew )
		LocalPlayer():GetTool( "rat" ):CreateLocalTransformArray()
		-- Update dropdown when preset changes
		comboBox:ChooseOptionID( tonumber( valueNew ) )
	end, "rat_arrayType_callback" )
	cvars.AddChangeCallback( "rat_arrayCount", function( convarName, valueOld, valueNew )
		ChangeAndColorPropCount( NumberOfPropsText, tonumber( valueNew ) )
	end, "rat_arrayCount_callback" )


	MakeNumberWang( cpanel, "#tool.rat.spawnChance", nil, "rat_spawnChance", 0, 100, 0 )


	-- [[----------------------------------------------------------------]] -- ARRAY TYPE AND VISUALIZATION SETTINGS
	local label = vgui.Create( "DLabel" )
	label:SetText( "#tool.rat.arrayType" )
	label:SetDark( true )
	label:Dock( TOP )
	cpanel:AddItem( label )

	local dList = vgui.Create( "DPanelList" )
	dList:Dock( TOP )
	dList:DockMargin( 0, -10, 0, 0 )
	cpanel:AddItem( dList )

	local comboBox = vgui.Create( "DComboBox", dList )
	comboBox:SetSize( 200, 20 )
	comboBox:SetSortItems( false )
	comboBox:Dock( NODOCK )
	comboBox:AddChoice( "#tool.rat.arrayTypeFull" )
	comboBox:AddChoice( "#tool.rat.arrayTypeHollow" )
	comboBox:AddChoice( "#tool.rat.arrayTypeOutline" )
	comboBox:AddChoice( "#tool.rat.arrayTypeCheckered" )
	comboBox:AddChoice( "#tool.rat.arrayTypeCheckeredInv" )
	comboBox:AddChoice( "#tool.rat.arrayType2DCheckered" )
	comboBox:AddChoice( "#tool.rat.arrayType2DCheckeredInv" )
	comboBox:ChooseOptionID( cvars.Number( "rat_arrayType" ) )
	comboBox.OnSelect = function( self, index, value )
		GetConVar( "rat_arrayType" ):SetInt( index )
	end


	MakeCheckbox( cpanel, "#tool.rat.previewPointAxisDescription", "rat_previewPointAxis", 0 )
	MakeNumberWang( cpanel, "#tool.rat.previewPointAxisSizeDescription", nil, "rat_previewPointAxisSize", 1, 100, 0 )
	MakeCheckbox( cpanel, "#tool.rat.previewArrayBoundsDescription", "rat_previewArrayBounds", 0 )


	-- [[----------------------------------------------------------------]] -- SPAWN TRANSFORMS
	local collapsiblePoint = MakeCollapsible( cpanel, "#tool.rat.pointTransforms", "rat_pointTransformExpanded" )


	MakeAxisSliderGroup( collapsiblePoint, "#tool.rat.pointSpacing", "#tool.rat.pointSpacingDescription", 0, 1000, 0,
	"rat_xSpacingBase", "rat_ySpacingBase", "rat_zSpacingBase" )

	MakeText( collapsiblePoint, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( collapsiblePoint, "#tool.rat.pointRotation", "#tool.rat.pointRotationDescription", -180, 180, 0,
	"rat_xRotationBase", "rat_yRotationBase", "rat_zRotationBase" )

	MakeText( collapsiblePoint, Color( 50, 50, 50 ), "" )

	local groupTitle = MakeText( collapsiblePoint, Color( 50, 50, 50 ), "#tool.rat.pointGaps" )
	groupTitle:SetTooltip( "#tool.rat.pointGapsDescription" )
	groupTitle:SetMouseInputEnabled( true )
	function groupTitle:DoClick() -- Three commands per line to just save some space
		GetConVar( "rat_xGapSpacing" ):Revert() GetConVar( "rat_xGapInterval" ):Revert() GetConVar( "rat_xGapStart" ):Revert()
		GetConVar( "rat_yGapSpacing" ):Revert() GetConVar( "rat_yGapInterval" ):Revert() GetConVar( "rat_yGapStart" ):Revert()
		GetConVar( "rat_zGapSpacing" ):Revert() GetConVar( "rat_zGapInterval" ):Revert() GetConVar( "rat_zGapStart" ):Revert()
	end
	function groupTitle:OnCursorEntered()
		groupTitle:SetColor( Color( 200, 100, 0 ) )
	end
	function groupTitle:OnCursorExited()
		groupTitle:SetColor( Color( 50, 50, 50 ) )
	end

	MakeGapSliderWangCombo( collapsiblePoint, "#tool.rat.xAxis", Color( 230, 0, 0 ), "rat_xGapSpacing", "rat_xGapInterval", "rat_xGapStart" )
	MakeGapSliderWangCombo( collapsiblePoint, "#tool.rat.yAxis", Color( 0, 230, 0 ), "rat_yGapSpacing", "rat_yGapInterval", "rat_yGapStart" )
	MakeGapSliderWangCombo( collapsiblePoint, "#tool.rat.zAxis", Color( 0, 0, 230 ), "rat_zGapSpacing", "rat_zGapInterval", "rat_zGapStart" )

	-- [[----------------------------------------------------------------]] -- ARRAY OFFSETS
	local collapsibleArray = MakeCollapsible( cpanel, "#tool.rat.arrayTransforms", "rat_arrayTransformsExpanded" )


	MakeAxisSliderGroup( collapsibleArray, "#tool.rat.arrayPivot", "#tool.rat.arrayPivotDescription", 0, 1, 2,
	"rat_xArrayPivot", "rat_yArrayPivot", "rat_zArrayPivot" )

	MakeText( collapsibleArray, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( collapsibleArray, "#tool.rat.arrayRotation", "#tool.rat.arrayRotationDescription", -180, 180, 0,
	"rat_xArrayRotation", "rat_yArrayRotation", "rat_zArrayRotation" )


	-- [[----------------------------------------------------------------]] -- RANDOM SPAWN OFFSETS
	local collapsibleRandom = MakeCollapsible( cpanel, "#tool.rat.randomPointTransforms", "rat_randomPointTransformsExpanded" )


	MakeAxisSliderGroup( collapsibleRandom, "#tool.rat.randomPointSpacing", "#tool.rat.randomPointSpacingDescription", 0, 1000, 0,
	"rat_xOffsetRandom", "rat_yOffsetRandom", "rat_zOffsetRandom" )

	MakeText( collapsibleRandom, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( collapsibleRandom, "#tool.rat.randomPointRotation", "#tool.rat.randomPointRotationDescription", -180, 180, 0,
	"rat_xRotationRandom", "rat_yRotationRandom", "rat_zRotationRandom" )

	MakeText( collapsibleRandom, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( collapsibleRandom, "#tool.rat.randomPointRotationStepped", "#tool.rat.randomRotationSteppedDescription", 0, 180, 0,
	"rat_xRotationRandomStepped", "rat_yRotationRandomStepped", "rat_zRotationRandomStepped" )


	-- Just a ui spacer at the bottom
	local div = vgui.Create( "DVerticalDivider" )
	div:SetPaintBackground( false )
	cpanel:AddItem( div )

	-------------------------------------------------
	-- CHECKBOX INITIAL STATES AND STATE CALLBACKS --
	-------------------------------------------------

	-- Initial enabled states for checkboxes
	SetCheckboxState( checkboxRootBoneOnly, GetConVar( "rat_spawnFrozen" ):GetBool() )
	SetCheckboxState( checkboxRandomRagdollPose, GetConVar( "rat_spawnFrozen" ):GetBool() && !GetConVar( "rat_freezeRootBoneOnly" ):GetBool() )
	SetCheckboxState( checkboxFacePlayer, GetConVar( "rat_ignoreSurfaceAngle" ):GetBool() )

	cvars.AddChangeCallback( "rat_spawnFrozen", function( convarName, valueOld, valueNew )
		SetCheckboxState( checkboxRootBoneOnly, tobool( valueNew ) )
		SetCheckboxState( checkboxRandomRagdollPose, !GetConVar( "rat_freezeRootBoneOnly" ):GetBool() && tobool( valueNew ) )
	end, "rat_spawnFrozen_callback" )

	cvars.AddChangeCallback( "rat_freezeRootBoneOnly", function( convarName, valueOld, valueNew )
		SetCheckboxState( checkboxRandomRagdollPose, GetConVar( "rat_spawnFrozen" ):GetBool() && !tobool( valueNew ) )
	end, "rat_freezeRootBoneOnly_callback" )

	cvars.AddChangeCallback( "rat_ignoreSurfaceAngle", function( convarName, valueOld, valueNew )
		SetCheckboxState( checkboxFacePlayer, tobool( valueNew ) )
	end, "rat_ignoreSurfaceAngle_callback" )
end

-- Debug tool ui rebuild
function TOOL:RebuildCPanel()
	local panel = controlpanel.Get( "rat" )
	if ( !panel ) then MsgN( "Rat panel not found." ) return end

	modelPathTable = {}
	UpdateServerTable()

	panel:Clear()
	self.BuildCPanel( panel )

	print( "Rebuilt rat panel" )
end

if CLIENT then
	-- Console command to rebuild the tool ui
	concommand.Add( "rat_rebuildCPanel", function( ply, cmd, args )
		ply:GetTool( "rat" ):RebuildCPanel()
	end )
end
