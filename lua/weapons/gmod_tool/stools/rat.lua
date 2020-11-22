-- Random Array Tool [R.A.T] made by func_Mathias 🐀

TOOL.Name = "#tool.rat.name"
TOOL.Description = "#tool.rat.desc"
TOOL.Category = "func_Mathias"

local toolActive = false
local stringSpacing = "   "

-- Model sting paths table
local modelPathTable = {}

TOOL.ClientConVar["spawnFrozen"] = "1"
TOOL.ClientConVar["freezeRootBoneOnly"] = "1"
TOOL.ClientConVar["noCollide"] = "0"
TOOL.ClientConVar["randomColor"] = "0"
TOOL.ClientConVar["randomSkin"] = "1"
TOOL.ClientConVar["randomBodygroup"] = "1"
TOOL.ClientConVar["randomSkip"] = "0"

TOOL.ClientConVar["spawnChance"] = "100"

TOOL.ClientConVar["ignoreSurfaceAngle"] = "0"
TOOL.ClientConVar["facePlayerZ"] = "0"
TOOL.ClientConVar["localGroundPlane"] = "0"
TOOL.ClientConVar["previewAxis"] = "1"
TOOL.ClientConVar["previewBox"] = "0"
TOOL.ClientConVar["pushAwayFromSurface"] = "0"
TOOL.ClientConVar["sphereRadius"] = "0"

TOOL.ClientConVar["mdlName"] = ""

-- UI foldout states
TOOL.ClientConVar["pointTransformExpanded"] = "1"
TOOL.ClientConVar["arrayTransformsExpanded"] = "0"
TOOL.ClientConVar["randomPointTransformsExpanded"] = "0"

-- X axis ConVars
TOOL.ClientConVar["xAmount"] = "3"
TOOL.ClientConVar["xSpacingBase"] = "50"
TOOL.ClientConVar["xOffsetRandom"] = "0"
TOOL.ClientConVar["xArrayPivot"] = "0.50"
TOOL.ClientConVar["xRotationBase"] = "0"
TOOL.ClientConVar["xRotationRandom"] = "0"
TOOL.ClientConVar["xRotationRandomStepped"] = "0"
TOOL.ClientConVar["xArrayRotation"] = "0"

-- Y axis ConVars
TOOL.ClientConVar["yAmount"] = "3"
TOOL.ClientConVar["ySpacingBase"] = "50"
TOOL.ClientConVar["yOffsetRandom"] = "0"
TOOL.ClientConVar["yArrayPivot"] = "0.50"
TOOL.ClientConVar["yRotationBase"] = "0"
TOOL.ClientConVar["yRotationRandom"] = "0"
TOOL.ClientConVar["yRotationRandomStepped"] = "0"
TOOL.ClientConVar["yArrayRotation"] = "0"

-- Z axis ConVars
TOOL.ClientConVar["zAmount"] = "2"
TOOL.ClientConVar["zSpacingBase"] = "50"
TOOL.ClientConVar["zOffsetRandom"] = "0"
TOOL.ClientConVar["zArrayPivot"] = "0.00"
TOOL.ClientConVar["zRotationBase"] = "0"
TOOL.ClientConVar["zRotationRandom"] = "0"
TOOL.ClientConVar["zRotationRandomStepped"] = "0"
TOOL.ClientConVar["zArrayRotation"] = "0"

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

	language.Add( "tool.rat.spawnFrozen", "Spawn frozen" )
	language.Add( "tool.rat.freezeRootBoneOnly", "Freeze only root bone of ragdolls" )
	language.Add( "tool.rat.noCollide", "No collide (world only)" )
	language.Add( "tool.rat.randomColor", "Apply random colors" )
	language.Add( "tool.rat.randomSkin", "Randomize skins" )
	language.Add( "tool.rat.randomBodygroup", "Randomize bodygroups" )
	language.Add( "tool.rat.randomSkip", "Skip this many bodygroups" )

	language.Add( "tool.rat.spawnChance", "Spawn chance (0 - 100)" )

	language.Add( "tool.rat.listHelpTitle", "Prop list help - Click for info" )
	language.Add( "tool.rat.listHelp1", "With the panel below you can keep track of the props you want to randomly spawn." )
	language.Add( "tool.rat.listHelp2", "- You can drag and drop any prop from the default spawnlist into the grey panel below to add them. You can select and drag multiple at once!" )
	language.Add( "tool.rat.listHelp3", "- You can also add props by using a path, if it's a path to a folder it will add every model in the folder as a prop. Be careful with folders containing a large amount of models." )
	language.Add( "tool.rat.listHelp4", "- Right click on one of the icons to remove it from the list." )
	language.Add( "tool.rat.listHelp5", "- Tip: Adding multiple copies of the same prop will increase it's chance of being spawned." )
	language.Add( "tool.rat.listHelp6", "- Tip: There is no option for saving your list but you can create a custom spawnlist to keep all the desired props in one place for easy adding to this list." )

	language.Add( "tool.rat.ignoreSurfaceAngle", "Ignore surface angle" )
	language.Add( "tool.rat.facePlayerZ", "Face player on Z axis" )
	language.Add( "tool.rat.localGroundPlane", "Local player ground plane" )
	language.Add( "tool.rat.previewPosition", "Show position previews" )
	language.Add( "tool.rat.previewOffset", "Show random position offset" )
	language.Add( "tool.rat.sphereRadius", "Editing sphere radius" )

	language.Add( "tool.rat.mdlAdd", "Add prop by path" )
	language.Add( "tool.rat.mdlAddButton", "Add to list from path" )
	language.Add( "tool.rat.mdlClearButton", "Clear prop list" )

	language.Add( "tool.rat.numOfProps", "Number of props: " )
	language.Add( "tool.rat.numberIn", "Number in " )

	language.Add( "tool.rat.pointTransforms", "Array point transforms" )
	language.Add( "tool.rat.pointSpacing", "Spacing" )
	language.Add( "tool.rat.pointSpacingDescription", "Space between each array point." .. string.char(10) .. "Click text to reset!" )
	language.Add( "tool.rat.pointRotation", "Rotation" )
	language.Add( "tool.rat.pointRotationDescription", "Rotation of all array points." .. string.char(10) .. "Click text to reset!" )

	language.Add( "tool.rat.arrayTransforms", "Array origin transforms" )
	language.Add( "tool.rat.arrayPivot", "Pivot" )
	language.Add( "tool.rat.arrayPivotDescription", "Pivot of the array. 0.5 in all axes will center it to cursor." .. string.char(10) .. "Click text to reset!" )
	language.Add( "tool.rat.arrayRotation", "Rotation" )
	language.Add( "tool.rat.arrayRotationDescription", "Rotation of the array origin." .. string.char(10) .. "Click text to reset!" )

	language.Add( "tool.rat.randomPointTransforms", "Randomized array point transforms" )
	language.Add( "tool.rat.randomPointSpacing", "Random offset" )
	language.Add( "tool.rat.randomPointSpacingDescription", "Random position offset per array point." .. string.char(10) .. "Click text to reset!" )
	language.Add( "tool.rat.randomPointRotation", "Random rotation" )
	language.Add( "tool.rat.randomPointRotationDescription", "Random rotation offset per array point." .. string.char(10) .. "Click text to reset!" )
	language.Add( "tool.rat.randomPointRotationStepped", "Random stepped rotation" )
	language.Add( "tool.rat.randomRotationSteppedDescription", "Random stepped rotation offset per array point." .. string.char(10) ..
	"If you use 90 degrees for example, each point will be rotated any of 0, 90, 180 or 270 degrees." .. string.char(10) .. "Click text to reset!" )

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
	net.Receive( "sendTables", function( len, player )
		local sid = player:SteamID()
		modelPathTable[sid] = net.ReadTable()

		-- print( "--- Model Path Table Start ---" )
		-- PrintTable( modelPathTable )
		-- print( "--- Model Path Table End ---" )
	end)
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

-- Calculates the position array for both preview and spawning
function TOOL:CreateLocalTransformArray()
	local xAmount = self:GetClientNumber( "xAmount" )
	local yAmount = self:GetClientNumber( "yAmount" )
	local zAmount = self:GetClientNumber( "zAmount" )

	local xSpacingBase = self:GetClientNumber( "xSpacingBase" )
	local ySpacingBase = self:GetClientNumber( "ySpacingBase" )
	local zSpacingBase = self:GetClientNumber( "zSpacingBase" )

	-- Calculate the array positions for a single axis at a time
	local function CalculateSingleAxisPoints( pointAmount, pointSpacing )
		local pointTable = {}

		for i = 0, pointAmount - 1 do
			pointTable[i] = pointSpacing * i
		end

		return pointTable
	end

	local xTable = CalculateSingleAxisPoints( xAmount, xSpacingBase )
	local yTable = CalculateSingleAxisPoints( yAmount, ySpacingBase )
	local zTable = CalculateSingleAxisPoints( zAmount, zSpacingBase )

	local tempTable = {}
	local i = 0

	-- Calculate the full array from each axis table
	for x = 0, #xTable do
		for y = 0, #yTable do
			for z = 0, #zTable do
				tempTable[i] = Vector( xTable[x], yTable[y], zTable[z] )
				i = i + 1
			end
		end
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
	local arrayPivot = Vector( xArrayPivot, yArrayPivot, zArrayPivot ) * transformArray[#transformArray]

	-- Correct the hit angle
	local correctedHitAngle = trace.HitNormal:Angle()
	correctedHitAngle.X = correctedHitAngle.X + 90
	correctedHitAngle:Normalize()
	local tempAngle = correctedHitAngle

	-- Make an offset to push the array away from the hit surface in the angle of the surface
	local furfacePushOffset = Vector()
	if ( pushAwayFromSurface > 0 ) then
		furfacePushOffset:Add( correctedHitAngle:Up() * pushAwayFromSurface )
	end

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
		transform:Add( furfacePushOffset )
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

-- Randomizes input entity in multiple ways
function TOOL:RandomizeProp( entity )
	if ( !self:IsSupportedPropAndValid( entity ) ) then return false end

	local randomSkin = tobool( self:GetClientNumber( "randomSkin" ) )
	local randomBodygroup = tobool( self:GetClientNumber( "randomBodygroup" ) )
	local randomColor = tobool( self:GetClientNumber( "randomColor" ) )
	local randomSkip = self:GetClientNumber( "randomSkip" )

	local entityClass = entity:GetClass()
	if ( entityClass == "prop_effect" ) then entity = entity.AttachedEntity end -- Needed to change prop_effects when tracing directly

	-- print( "entity class " .. entity:GetClass() )
	-- print( "entity skin count " .. entity:SkinCount() )
	-- print( "entity number of bodygroup" .. entity:GetNumBodyGroups() )

	-- Randomize skin
	if ( randomSkin ) then
		entity:SetSkin( math.random( 0, entity:SkinCount() - 1 ) )
	end

	-- Randomize body groups
	if ( randomBodygroup ) then
		for i = 0, entity:GetNumBodyGroups() do
			if ( i <= randomSkip ) then continue end
			entity:SetBodygroup( i, math.random( 0, entity:GetBodygroupCount( i ) - 1 ) )
		end
	end

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
	self:GetOwner():GetTool():CheckPlaneTrace( trace )

	-- Adds random offsets to the whole array
	self:RandomizeTransformArrayPosition( transformTable )
	-- Offsets and rotates the array as a whole, and returns the array ralative rotation for props
	local elementAngleStatic = self:ModifyTransformArray( trace, transformTable )
	local elementAngle = Angle()

	local spawnChance = self:GetClientNumber( "spawnChance" )
	local spawnFrozen = tobool( self:GetClientNumber( "spawnFrozen" ) )
	local freezeRootBoneOnly = tobool( self:GetClientNumber( "freezeRootBoneOnly" ) )
	local noCollide = tobool( self:GetClientNumber( "noCollide" ) )

	undo.Create( "rat_array_prop" )
	undo.SetCustomUndoText( "#tool.rat.undo" )
	undo.SetPlayer( player )

	-- Loop per position in the table
	for i, transform in pairs( transformTable ) do
		-- Check spawn chance
		if ( spawnChance < math.random( 1, 100 ) ) then continue end

		-- Adds random rotation to input angle
		elementAngle = self:RandomizeRotation( elementAngleStatic )

		local modelPath = modelPathTable[sid][math.random( #modelPathTable[sid] )]
		local entityType = "prop_effect"
		if ( util.IsValidProp( modelPath ) ) then entityType = "prop_physics" end -- Think the valid check includes checking for collision, so a model without collision will be a prop_effect
		if ( util.IsValidRagdoll( modelPath ) ) then entityType = "prop_ragdoll" end

		local entity = ents.Create( entityType )
		-- print( modelPath .. " is le path for de modul" )
		entity:SetModel( modelPath ) -------------
		entity:SetPos( trace.HitPos + transform )
		entity:SetAngles( elementAngle )
		entity:Spawn()

		self:RandomizeProp( entity )

		-- Freeze prop (prop_effect doesn't move so don't freeze them)
		if ( spawnFrozen && entityType != "prop_effect" ) then
			local phys = entity:GetPhysicsObject()
			if ( phys:IsValid() ) then
				phys:EnableMotion( false )
				player:AddFrozenPhysicsObject( entity, phys )
			end
			if ( entity:IsRagdoll() && !freezeRootBoneOnly ) then
				local boneCount = entity:GetPhysicsObjectCount()

				for bone = 1, boneCount - 1 do
					local physBone = entity:GetPhysicsObjectNum( bone )
					physBone:EnableMotion( false )
					-- Causes severe lag because of the halo effect, but can be a bit confusing/annoying to unfreeze a ragdoll without..
					player:AddFrozenPhysicsObject( entity, physBone )
				end
			end
		end

		if ( noCollide && entityType != "prop_effect" ) then
			entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		-- Add entity to undo and cleanup
		undo.AddEntity( entity )
		self:GetOwner():AddCleanup( "rat_arrays", entity )

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

-- Checks if input entity is a kind of prop that is supported by this tool
function TOOL:IsSupportedPropAndValid( entity )
	if ( !IsValid( entity ) ) then return false end
	local entityClass = entity:GetClass()

	if ( entityClass == "prop_physics" || entityClass == "prop_effect" || entityClass == "prop_dynamic" || entity:IsRagdoll() ) then
		return true
	else
		return false
	end
end



function TOOL:LeftClick( trace )
	if ( SERVER ) then
		local player = self:GetOwner()
		local sid = player:SteamID()

		-- Spawns the props
		return self:SpawnPropTable( player, trace, sid )
	end
end

function TOOL:RightClick( trace )
	if ( SERVER ) then
		local randomizedAnyProps = false
		local sphereRadius = self:GetClientNumber( "sphereRadius" )

		if ( sphereRadius == 0 ) then
			-- Randomize prop under crosshair
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
end

function TOOL:Reload( trace )
	if ( SERVER ) then
		local removedAnyProps = false
		local sphereRadius = self:GetClientNumber( "sphereRadius" )

		if ( sphereRadius == 0 ) then
			-- Remove prop under crosshair
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
end



-- Debug print
function TOOL:CheckList()
	print( "--- Model Path Table Start ---" )
	PrintTable( modelPathTable )
	print( "--- Model Path Table End ---" )
end

-- Find an remove first result in table that matches input string
local function RemoveFirstMatchInTable( inputTable, inputString )
	for i, str in ipairs( inputTable ) do
		if str == inputString then
			table.remove( inputTable, i )
			return
		end
	end
end

-- Send the local model path table to the server
local function updateServerTables()
	net.Start( "sendTables" )
	net.WriteTable( modelPathTable )
	net.SendToServer()
end

-- Checks if path is for a model or a folder, if a folder then it returns a table of models in that folder
local function CheckModelPath( inputDirectory )
	if string.find( inputDirectory, "%.mdl" ) then
		-- print ( "The word .mdl was found in path: " .. inputDirectory )
		local tempTable = { inputDirectory }
		return tempTable
	else
		local tempMdlTable = {}
		-- print( "==[LOADING " .. inputDirectory .. "]===========================================" )
		local fileList = file.Find( inputDirectory .. "/*.mdl", "GAME" )
		-- PrintTable( fileList )
		for i, fileName in pairs( fileList ) do
			local directory = inputDirectory .. "/" .. fileName
			-- resource.AddFile( directory )
			table.insert( tempMdlTable, directory )
			-- print( "    >Loaded " .. directory )
		end
		-- print( "    >Loaded the directory " .. inputDirectory )

		return tempMdlTable
	end
end

-- Creates icons for the prop list
local function AddSpawnIcon( inputListPanel, inputModelPath ) --------------------------------------------------------------------
	for i, path in ipairs( CheckModelPath( inputModelPath ) ) do
		local ListItem = inputListPanel:Add( "SpawnIcon" )
		ListItem:SetSize( 64, 64 )
		-- print( "Model path for icon is " .. path )
		ListItem:SetModel( path )

		ListItem.DoRightClick = function()
			RemoveFirstMatchInTable( modelPathTable, path )
			updateServerTables()
			-- print( "Going to remove myself" )
			ListItem:Remove()
		end

		table.insert( modelPathTable, path )
	end
end

-- Render axis gizmo for visualization
local function RenderAxis( pos, ang )
	--Rotate only changes the original vector and doesn't return anything, so need to waste some space sadly
	local linePosX = Vector( 3, 0, 0 )
	local linePosY = Vector( 0, 3, 0 )
	local linePosZ = Vector( 0, 0, 3 )
	linePosX:Rotate( ang )
	linePosY:Rotate( ang )
	linePosZ:Rotate( ang )

	-- Render blue last to make sure it's always on top and visible
	render.DrawLine( pos, pos + linePosX, Color( 255, 0, 0, 255 ), false ) -- Red
	render.DrawLine( pos, pos + linePosY, Color( 0, 255, 0, 255 ), false ) -- Green
	render.DrawLine( pos, pos + linePosZ, Color( 0, 0, 255, 255 ), false ) -- Blue

	-- To compare and make sure my axis directions are correct, "developer 1" needed in console
	-- debugoverlay.Axis( pos + Vector( -10, 0, 0 ), ang, 5, 5, true )
end

-- Render hook for drawing visualizations for array positions and some more
hook.Add( "PostDrawTranslucentRenderables", "rat_ArrayPreviewRender", function( bDrawingDepth, bDrawingSkybox )
	if ( toolActive && LocalPlayer():GetTool() && !bDrawingSkybox ) then
		local previewAxis = tobool( LocalPlayer():GetTool():GetClientNumber( "previewAxis" ) )
		local previewBox = tobool( LocalPlayer():GetTool():GetClientNumber( "previewBox" ) )

		local trace = LocalPlayer():GetEyeTrace()
		-- Check if we should use normal or plane trace, modifies original trace data
		LocalPlayer():GetTool():CheckPlaneTrace( trace )

		-- Render per position visualization
		if ( previewAxis || previewBox ) then
			local transformTable = LocalPlayer():GetTool():CreateLocalTransformArray()
			if ( next( transformTable ) == nil ) then return end

			-- LocalPlayer():GetTool():RandomizeTransformArrayPosition( transformTable ) -- For easy debugging of random positions
			local elementAngle = LocalPlayer():GetTool():ModifyTransformArray( trace, transformTable )
			-- elementAngle = LocalPlayer():GetTool():RandomizeRotation( elementAngle ) -- For easy debugging of random rotations

			for i, transform in pairs( transformTable ) do
				if ( previewBox ) then
					-- render.DrawWireframeBox( trace.HitPos + transform, elementAngle, Vector( 2.5, 2.5, 0.5 ), Vector( -2.5, -2.5, -0.5 ), Color( 0, 255, 255, 255 ), false )
					render.DrawWireframeBox( trace.HitPos + transform, elementAngle, Vector( 2.5, 1.0, 0.25 ), Vector( -2.5, -1.0, -0.25 ), Color( 0, 255, 255, 255 ), false )
				end
				if ( previewAxis ) then
					RenderAxis( trace.HitPos + transform, elementAngle )
				end
			end
		end

		-- Calculate a position X units in front of the player, this is to place the main axis visalization at a set distance so it always looks the same size
		local mainAxisPosition = LocalPlayer():EyePos()
		mainAxisPosition:Add( LocalPlayer():EyeAngles():Forward() * 200 )

		-- Render thicc axis at trace hit
		local correctedHitAngle = trace.HitNormal:Angle()
		correctedHitAngle.x = correctedHitAngle.x + 90
		local thicc = 0.05
		render.DrawWireframeBox( mainAxisPosition, correctedHitAngle, Vector( 0, 0, 0 ), Vector( 5, thicc, thicc ), Color( 255, 0, 0, 255 ) , false )
		render.DrawWireframeBox( mainAxisPosition, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, 5, thicc ), Color( 0, 255, 0, 255 ) , false )
		render.DrawWireframeBox( mainAxisPosition, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, thicc, 5 ), Color( 0, 0, 255, 255 ) , false )

		-- Render single box that envelops the whole array
		-- if ( #transformTable > 1 ) then
		-- 	local startPos = transformTable[0]
		-- 	local endPos = transformTable[#transformTable]
		-- 	render.DrawWireframeBox( trace.HitPos, Angle(), startPos, endPos, Color( 0, 255, 255, 255 ), false )
		-- end

		-- Render sphere for sphere volume
		local sphereRadius = LocalPlayer():GetTool():GetClientNumber( "sphereRadius" )

		if ( sphereRadius > 0 ) then
			render.DrawWireframeSphere( trace.HitPos, sphereRadius, 10, 10, Color( 0, 255, 255, 255 ), true )
		end
	end
end)

function TOOL:Think()
	if ( CLIENT ) then
		-- print( "tool deployed" )
		toolActive = true
	end
end

function TOOL:Holster()
	if ( CLIENT ) then
		-- print( "tool holstered" )
		toolActive = false
	end
end

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
local toolScreenRatMaterial = Material( "rat_assets/rat_head.png", "noclamp ignorez mips" )

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

-- [[----------------------------------------------------------------]] -- CONTROL PANEL

local function MakeText( panel, color, str )
	local label = vgui.Create( "DLabel" )
	label:SetText( str )
	label:SetAutoStretchVertical( true )
	label:SetColor( color )
	label:SetWrap( true )
	panel:AddItem( label )

	return label
end

local function MakeCheckbox( panel, titleString, convar, convarEnabledState )
	local enabledState = true

	if ( convarEnabledState != nil ) then
		enabledState = cvars.Bool( convarEnabledState )
	end

	local contentHolder = vgui.Create( "DSizeToContents" )
	contentHolder:DockPadding( 0, -2, 0, -2 )
	contentHolder:Dock( TOP )
	panel:AddItem( contentHolder )

	local checkBox = vgui.Create( "DCheckBox", contentHolder )
	checkBox:DockMargin( 0, 3, 0, 2 )
	checkBox:SetConVar( convar )
	checkBox:SetEnabled( enabledState )
	checkBox:Dock( LEFT )

	local label = vgui.Create( "DLabel", contentHolder )
	label:SetText( stringSpacing .. language.GetPhrase( titleString ) )
	label:SetDark( enabledState )
	label:SetEnabled( enabledState )
	label:Dock( TOP )
	label:SetMouseInputEnabled( true )
	function label:DoClick()
		GetConVar( convar ):SetBool( !cvars.Bool( convar ) )
	end

	-- Callback to enable/disable the checkbox and label when the specified convar is changed
	if ( convarEnabledState != nil ) then
		cvars.AddChangeCallback( convarEnabledState, function( convarName, valueOld, valueNew )
			local cvar = cvars.Bool( convarName )
			checkBox:SetEnabled( cvar )
			label:SetEnabled( cvar )
			label:SetDark( cvar )
		end, convarEnabledState .. "_callback")
	end

	return contentHolder
end

local function MakeNumberWang( panel, titleString, convar, min, max, leftSpacing )
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

	return dList
end

local function MakeAxisSlider( panel, color, titleString, min, max, decimals, conVar )
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( stringSpacing .. language.GetPhrase( titleString ) )
	slider:SetMinMax( min, max )
	slider:SetTall( 15 )
	slider:SetDecimals( decimals )
	slider:SetDark( true )
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

local function ChangeAndColorPropCount( panel )
	if ( GetConVar( "rat_xAmount" ) == nil || GetConVar( "rat_yAmount" ) == nil || GetConVar( "rat_zAmount" ) == nil ) then return end
	local xAmount = GetConVar( "rat_xAmount" ):GetInt()
	local yAmount = GetConVar( "rat_yAmount" ):GetInt()
	local zAmount = GetConVar( "rat_zAmount" ):GetInt()

	local totalAmount = xAmount * yAmount * zAmount

	panel:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.numOfProps" ) .. totalAmount )

	if ( totalAmount < 750 ) then
		panel:SetColor( Color( 250, 250, 250 ) ) -- White
	elseif ( totalAmount < 1500 ) then
		panel:SetColor( Color( 255, 200, 90 ) ) -- Orange
	else
		panel:SetColor( Color( 255, 133, 127 ) ) -- Red
	end
end

if CLIENT then
	-- Console command to rebuild the tool ui
	concommand.Add("rat_rebuildCPanel", function( ply, cmd, args )
		if ply:GetTool() then
			for i, toolData in pairs( ply:GetTool() ) do
				-- Checking if the current tool has the word rat in the tool table so it won't try to run the function when another tool is active
				if ( toolData == "rat" ) then
					ply:GetTool():RebuildCPanel()
				end
			end
		end
	end)
end

-- Debug tool ui rebuild
function TOOL:RebuildCPanel()
	local panel = controlpanel.Get( "rat" )
	if ( !panel ) then MsgN( "Rat panel not found." ) return end

	modelPathTable = {}
	updateServerTables()

	-- May not be needed now that the callbacks have identifiers which means they'll override the old ones, but keeping it just in case
	cvars.RemoveChangeCallback("rat_xAmount", "rat_xAmount_callback")
	cvars.RemoveChangeCallback("rat_yAmount", "rat_yAmount_callback")
	cvars.RemoveChangeCallback("rat_zAmount", "rat_zAmount_callback")
	cvars.RemoveChangeCallback("rat_spawnFrozen", "rat_spawnFrozen_callback")
	cvars.RemoveChangeCallback("rat_ignoreSurfaceAngle", "rat_ignoreSurfaceAngle_callback")

	panel:Clear()
	self.BuildCPanel( panel )

	print("Rebuilt rat panel")
end

function TOOL.BuildCPanel( cpanel )
	MakeText( cpanel, Color( 50, 50, 50 ), "#tool.rat.desc" )

	MakeCheckbox( cpanel, "#tool.rat.spawnFrozen", "rat_spawnFrozen" )
	MakeCheckbox( cpanel, "#tool.rat.freezeRootBoneOnly", "rat_freezeRootBoneOnly", "rat_spawnFrozen" )
	MakeCheckbox( cpanel, "#tool.rat.noCollide", "rat_noCollide" )
	MakeCheckbox( cpanel, "#tool.rat.randomColor", "rat_randomColor" )
	MakeCheckbox( cpanel, "#tool.rat.randomSkin", "rat_randomSkin" )
	MakeCheckbox( cpanel, "#tool.rat.randomBodygroup", "rat_randomBodygroup" )

	cpanel:ControlHelp( "" )

	MakeNumberWang( cpanel, "#tool.rat.randomSkip", "rat_randomSkip", 0, 100, 0 )
	MakeNumberWang( cpanel, "#tool.rat.spawnChance", "rat_spawnChance", 0, 100, 0 )

	cpanel:ControlHelp( "" )


	-- [[----------------------------------------------------------------]] -- Prop List Description
	local collapsible = MakeCollapsible( cpanel, "#tool.rat.listHelpTitle" )

	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp1" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp2" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp3" )
	-- MakeText( collapsible, Color( 50, 50, 50 ), "- Left click on one of the icons to be able to configure and constrain the bodygroups and skins it will be spawned with." )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp4" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp5" )
	MakeText( collapsible, Color( 50, 50, 50 ), "#tool.rat.listHelp6" )


	-- [[----------------------------------------------------------------]] -- Prop Grid List
	cpanel:TextEntry( "#tool.rat.mdlAdd", "rat_mdlName" )


	local Scroll = vgui.Create( "DScrollPanel" ) -- Create the Scroll panel ---------------------------------------------------
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

			updateServerTables()

			if ( inputPanels[1]:GetName() != "SpawnIcon" ) then return end
			-- print( "You just dropped " .. inputPanels[1]:GetModelName() .. " on me." )
		end
	end)


	local AddButton = vgui.Create( "DButton" )
	AddButton:SetText( "#tool.rat.mdlAddButton" )
	AddButton:SetTooltip( "#tool.rat.mdlAddButton" )
	AddButton.DoClick = function()
		AddSpawnIcon( MdlView, GetConVar( "rat_mdlName" ):GetString() )
		updateServerTables()
	end

	-- Some weird positioning here for everything to be able to reference what it needs to but still be in the right order in the ui
	-- The function needs to be made before it gets referenced, but also after the ui it is referencing, and the button needs to be added before the prop list
	cpanel:AddItem( AddButton )
	cpanel:AddItem( Scroll )


	local ClearButton = vgui.Create( "DButton" )
	ClearButton:SetText( "#tool.rat.mdlClearButton" )
	ClearButton:DockMargin( 0, -8, 0, 0 )
	-- ClearButton:SetTooltip( "#tool.rat.mdlAddButton" )
	ClearButton.DoClick = function()
		for i, Icon in pairs( MdlView:GetChildren() ) do
			Icon:Remove()
		end
		modelPathTable = {}
		updateServerTables()
	end
	cpanel:AddItem( ClearButton )



	-- [[----------------------------------------------------------------]] -- Array visualization options
	MakeCheckbox( cpanel, "#tool.rat.ignoreSurfaceAngle", "rat_ignoreSurfaceAngle" )
	MakeCheckbox( cpanel, "#tool.rat.facePlayerZ", "rat_facePlayerZ", "rat_ignoreSurfaceAngle" )
	MakeCheckbox( cpanel, "#tool.rat.localGroundPlane", "rat_localGroundPlane" )
	MakeCheckbox( cpanel, "#tool.rat.previewPosition", "rat_previewAxis" )
	MakeCheckbox( cpanel, "#tool.rat.previewOffset", "rat_previewBox" )

	MakeNumberWang( cpanel, "#tool.rat.sphereRadius", "rat_sphereRadius", 0, 9999, 0 )
	MakeNumberWang( cpanel, "Push array away from surface", "rat_pushAwayFromSurface", 0, 9999, 0 )

	-- [[----------------------------------------------------------------]] -- Prop Counter
	local NumberOfPropsText = vgui.Create( "DLabel" )
	NumberOfPropsText:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.numOfProps" ) .. "1" )
	NumberOfPropsText:SetFont( "DermaDefaultBold" )
	NumberOfPropsText:SetTall( 20 )
	NumberOfPropsText:SetColor( Color( 250, 250, 250 ) )
	NumberOfPropsText:SetWrap( true )
	NumberOfPropsText.Paint = function()
		draw.RoundedBoxEx( 4, 0, 0, 200, 19, Color( 127, 127, 127 ), true, true, false, false )
	end
	cpanel:AddItem( NumberOfPropsText )

	ChangeAndColorPropCount( NumberOfPropsText ) -- Make sure the text shows the correct count

	-- Only reliable way I found to update this value was a bunch of callbacks
	-- If using GetConVar within DNumberWang:OnValueChanged it would return the previous value
	cvars.AddChangeCallback("rat_xAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorPropCount( NumberOfPropsText )
	end, "rat_xAmount_callback")
	cvars.AddChangeCallback("rat_yAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorPropCount( NumberOfPropsText )
	end, "rat_yAmount_callback")
	cvars.AddChangeCallback("rat_zAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorPropCount( NumberOfPropsText )
	end, "rat_zAmount_callback")

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

	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.xAxis" ), "rat_xAmount", 1, 999, 10 )
	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.yAxis" ), "rat_yAmount", 1, 999, 10 )
	MakeNumberWang( dListNumber, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.zAxis" ), "rat_zAmount", 1, 999, 10 )


	-- [[----------------------------------------------------------------]] -- SPAWN TRANSFORMS
	local collapsiblePoint = MakeCollapsible( cpanel, "#tool.rat.pointTransforms", "rat_pointTransformExpanded" )


	MakeAxisSliderGroup( collapsiblePoint, "#tool.rat.pointSpacing", "#tool.rat.pointSpacingDescription", 0, 1000, 0,
	"rat_xSpacingBase", "rat_ySpacingBase", "rat_zSpacingBase" )

	MakeText( collapsiblePoint, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( collapsiblePoint, "#tool.rat.pointRotation", "#tool.rat.pointRotationDescription", -180, 180, 0,
	"rat_xRotationBase", "rat_yRotationBase", "rat_zRotationBase" )


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


	-- [[----------------------------------------------------------------]] -- DEBUG

	local div = vgui.Create( "DVerticalDivider" )
	-- div:Dock( FILL ) -- Make the divider fill the space of the DFrame
	div:SetPaintBackground( false )
	cpanel:AddItem( div )

	local div2 = vgui.Create( "DVerticalDivider" )
	-- div:Dock( FILL ) -- Make the divider fill the space of the DFrame
	div2:SetPaintBackground( false )
	cpanel:AddItem( div2 )



	-- Debug buttons
	local CheckButton = vgui.Create( "DButton" )
	CheckButton:SetText( "Check List" )
	CheckButton.DoClick = function()
		if LocalPlayer():GetTool() then
			LocalPlayer():GetTool():CheckList()
		end
	end
	cpanel:AddItem( CheckButton )

	local UpdateButton = vgui.Create( "DButton" )
	UpdateButton:SetText( "Update Control Panel" )
	UpdateButton.DoClick = function()
		if LocalPlayer():GetTool() then
			LocalPlayer():GetTool():RebuildCPanel()
		end
	end
	cpanel:AddItem( UpdateButton )
end
