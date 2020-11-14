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
TOOL.ClientConVar["randomColor"] = "0"
TOOL.ClientConVar["randomSkin"] = "1"
TOOL.ClientConVar["randomBodygroup"] = "1"
TOOL.ClientConVar["randomSkip"] = "0"

TOOL.ClientConVar["spawnChance"] = "100"

TOOL.ClientConVar["ignoreSurfaceAngle"] = "0"
TOOL.ClientConVar["facePlayerZ"] = "0"
TOOL.ClientConVar["previewAxis"] = "1"
TOOL.ClientConVar["previewBox"] = "1"
TOOL.ClientConVar["sphereRadius"] = "0"

TOOL.ClientConVar["mdlName"] = ""

-- UI foldout states
TOOL.ClientConVar["pointTransformExpanded"] = "1"
TOOL.ClientConVar["arrayTransformsExpanded"] = "0"
TOOL.ClientConVar["randomPointTransformsExpanded"] = "0"

-- X axis ConVars
TOOL.ClientConVar["xAmount"] = "1"
TOOL.ClientConVar["xOffsetBase"] = "0"
TOOL.ClientConVar["xOffsetRandom"] = "0"
TOOL.ClientConVar["xArrayOffset"] = "0"
TOOL.ClientConVar["xRotationBase"] = "0"
TOOL.ClientConVar["xRotationRandom"] = "0"
TOOL.ClientConVar["xRotationRandomStepped"] = "0"
TOOL.ClientConVar["xArrayRotation"] = "0"

-- Y axis ConVars
TOOL.ClientConVar["yAmount"] = "1"
TOOL.ClientConVar["yOffsetBase"] = "0"
TOOL.ClientConVar["yOffsetRandom"] = "0"
TOOL.ClientConVar["yArrayOffset"] = "0"
TOOL.ClientConVar["yRotationBase"] = "0"
TOOL.ClientConVar["yRotationRandom"] = "0"
TOOL.ClientConVar["yRotationRandomStepped"] = "0"
TOOL.ClientConVar["yArrayRotation"] = "0"

-- Z axis ConVars
TOOL.ClientConVar["zAmount"] = "1"
TOOL.ClientConVar["zOffsetBase"] = "0"
TOOL.ClientConVar["zOffsetRandom"] = "0"
TOOL.ClientConVar["zArrayOffset"] = "0"
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
	language.Add( "tool.rat.left", "Spawn random object array" )
	language.Add( "tool.rat.right", "Randomize object under cursor" )
	language.Add( "tool.rat.reload", "Randomize object(s) within sphere volume" )
	language.Add( "tool.rat.desc", "This tool lets you spawn objects in a randomized array, or randomize already spawned objects in various ways." )

	language.Add( "tool.rat.spawnFrozen", "Spawn frozen" )
	language.Add( "tool.rat.freezeRootBoneOnly", "Freeze only root bone of ragdolls" )
	language.Add( "tool.rat.randomColor", "Apply random colors" )
	language.Add( "tool.rat.randomSkin", "Randomize skins" )
	language.Add( "tool.rat.randomBodygroup", "Randomize bodygroups" )
	language.Add( "tool.rat.randomSkip", "Skip this many bodygroups" )

	language.Add( "tool.rat.spawnChance", "Spawn chance (0 - 100)" )

	language.Add( "tool.rat.listHelpTitle", "Object list help - Click for info" )
	language.Add( "tool.rat.listHelp1", "With the panel below you can keep track of the models you want to randomly spawn." )
	language.Add( "tool.rat.listHelp2", "- You can drag and drop any model from the default spawnlist into the grey panel below to add them. You can select and drag multiple at once!" )
	language.Add( "tool.rat.listHelp3", "- You can also add models by using a path, if it's a path to a folder it will add every model in the folder. Be careful with folders containing a large amount of models." )
	language.Add( "tool.rat.listHelp4", "- Right click on one of the model icons to remove it from the list." )
	language.Add( "tool.rat.listHelp5", "- Tip: Adding multiple copies of the same model will increase it's chance of being spawned." )
	language.Add( "tool.rat.listHelp6", "- Tip: There is no option for saving your list but you can create a custom spawnlist to keep all the desired models in one place for easy adding to this list." )

	language.Add( "tool.rat.ignoreSurfaceAngle", "Ignore surface angle" )
	language.Add( "tool.rat.facePlayerZ", "Face player on Z axis" )
	language.Add( "tool.rat.previewPosition", "Show position previews" )
	language.Add( "tool.rat.previewOffset", "Show random position offset" )
	language.Add( "tool.rat.sphereRadius", "Editing sphere radius" )

	language.Add( "tool.rat.mdlAdd", "Add model by path" )
	language.Add( "tool.rat.mdlAddButton", "Add to list from path" )
	language.Add( "tool.rat.mdlClearButton", "Clear model list" )

	language.Add( "tool.rat.numOfObjects", "Number of objects: " )
	language.Add( "tool.rat.numberIn", "Number in " )

	language.Add( "tool.rat.pointTransforms", "Array point transforms" )
	language.Add( "tool.rat.pointSpacing", "Spacing" )
	language.Add( "tool.rat.pointSpacingDescription", "Space between each array point." .. string.char(10) .. "Click text to reset!" )
	language.Add( "tool.rat.pointRotation", "Rotation" )
	language.Add( "tool.rat.pointRotationDescription", "Rotation of all array points." .. string.char(10) .. "Click text to reset!" )

	language.Add( "tool.rat.arrayTransforms", "Array origin transforms" )
	language.Add( "tool.rat.arrayOffset", "Offset" )
	language.Add( "tool.rat.arrayOffsetDescription", "Position offset of the array origin." .. string.char(10) .. "Click text to reset!" )
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

if (SERVER) then
	-- Register the Network String
	util.AddNetworkString( "sendTables" )

	-- When the server receives the clients Network information
	net.Receive( "sendTables", function( len, player )
		local sid = player:SteamID()
		modelPathTable[sid] = net.ReadTable()

		print( "--- Model Path Table Start ---" )
		PrintTable( modelPathTable )
		print( "--- Model Path Table End ---" )

	end)
end

-- Calculates the position array for both preview and spawning
function TOOL:CreateLocalTransformArray()
	local xAmount = self:GetClientNumber( "xAmount" )
	local yAmount = self:GetClientNumber( "yAmount" )
	local zAmount = self:GetClientNumber( "zAmount" )

	local xOffsetBase = self:GetClientNumber( "xOffsetBase" )
	local yOffsetBase = self:GetClientNumber( "yOffsetBase" )
	local zOffsetBase = self:GetClientNumber( "zOffsetBase" )


	local tempTable = {}
	local i = 0

	-- Calculate the array positions
	for x = 0, xAmount - 1 do
		tempTable[i] = Vector( xOffsetBase * x, 0, 0 )
		i = i + 1

		for y = 0, yAmount - 1 do
			if (y != 0) then -- This for loop needs to skip the first cycle without affecting the next for loop
				tempTable[i] = Vector( xOffsetBase * x, yOffsetBase * y, 0 )
				i = i + 1
			end

			for z = 1, zAmount - 1 do
				tempTable[i] = Vector( xOffsetBase * x, yOffsetBase * y, zOffsetBase * z )
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

	if ( xOffsetRandom == 0 && yOffsetRandom == 0 && zOffsetRandom == 0 ) then
		return
	end

	-- Offset each position in array
	for i, transform in pairs( transformArray ) do
		local xOffset = math.random( xOffsetRandom * -1, xOffsetRandom )
		local yOffset = math.random( yOffsetRandom * -1, yOffsetRandom )
		local zOffset = math.random( zOffsetRandom * -1, zOffsetRandom )
		local offset = Vector( xOffset, yOffset, zOffset )
		transform:Add( offset )
	end
end

-- A bit unconventional, but this function modifies the original array and returns the angle of the array plus object rotation
function TOOL:ModifyTransformArray( trace, transformArray ) -- Calculates the position array for both preview and spawning
	local xRotationBase = self:GetClientNumber( "xRotationBase" )
	local yRotationBase = self:GetClientNumber( "yRotationBase" )
	local zRotationBase = self:GetClientNumber( "zRotationBase" )

	local xArrayOffset = self:GetClientNumber( "xArrayOffset" )
	local yArrayOffset = self:GetClientNumber( "yArrayOffset" )
	local zArrayOffset = self:GetClientNumber( "zArrayOffset" )
	local arrayOffset = Vector( xArrayOffset, yArrayOffset, zArrayOffset )

	local xArrayRotation = self:GetClientNumber( "xArrayRotation" )
	local yArrayRotation = self:GetClientNumber( "yArrayRotation" )
	local zArrayRotation = self:GetClientNumber( "zArrayRotation" )

	local ignoreSurfaceAngle = self:GetClientNumber( "ignoreSurfaceAngle" )
	local facePlayerZ = self:GetClientNumber( "facePlayerZ" )

	-- Correct the hit angle
	local correctedHitAngle = trace.HitNormal:Angle()
	correctedHitAngle.x = correctedHitAngle.x + 90
	local tempAngle = correctedHitAngle

	-- Ignore surface angle and set it do a default world angle, or face player on z axis
	if ( tobool( ignoreSurfaceAngle ) ) then
		if ( tobool( facePlayerZ ) ) then
			tempAngle = Angle( 0, self:GetOwner():EyeAngles().Y, 0 )
		else
			tempAngle = Angle()
		end
	end

	-- Angle for the array
	tempAngle:RotateAroundAxis( tempAngle:Forward(), xArrayRotation) -- X
	tempAngle:RotateAroundAxis( tempAngle:Right(), yArrayRotation) -- Y
	tempAngle:RotateAroundAxis( tempAngle:Up(), zArrayRotation) -- Z

	-- Offset and rotate the array positions
	for i, transform in pairs( transformArray ) do
		transform:Add( arrayOffset )
		transform:Rotate( tempAngle )
	end

	-- Angle for each element on top of the array rotation
	tempAngle:RotateAroundAxis( tempAngle:Forward(), xRotationBase) -- X
	tempAngle:RotateAroundAxis( tempAngle:Right(), yRotationBase) -- Y
	tempAngle:RotateAroundAxis( tempAngle:Up(), zRotationBase) -- Z

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

		tempAngle:RotateAroundAxis( tempAngle:Forward(), xRotationRandom) -- X
		tempAngle:RotateAroundAxis( tempAngle:Right(), yRotationRandom) -- Y
		tempAngle:RotateAroundAxis( tempAngle:Up(), zRotationRandom) -- Z
	end

	return tempAngle
end

-- Randomizes input entity in multiple ways
function TOOL:RandomizeEntityModel( entity )
	if ( !IsValid( entity ) ) then return end
	local entityClass = entity:GetClass()
	if ( entityClass == "player" ) then return end
	if ( entityClass == "prop_effect" ) then entity = entity.AttachedEntity end -- Needed to change prop_effects when tracing directly

	-- print( "entity class " .. entity:GetClass() )
	-- print( "entity skin count " .. entity:SkinCount() )
	-- print( "entity number of bodygroup" .. entity:GetNumBodyGroups() )

	-- Randomize skin
	if ( tobool( self:GetClientNumber( "randomSkin" ) ) && entity:SkinCount() != nil ) then
		entity:SetSkin( math.random( 0, entity:SkinCount() - 1 ) )
	end

	-- Randomize body groups
	if ( tobool( self:GetClientNumber( "randomBodygroup" ) ) && entity:GetNumBodyGroups() != nil ) then
		for i = 0, entity:GetNumBodyGroups() do
			if ( i <= self:GetClientNumber( "randomSkip" ) ) then continue end
			entity:SetBodygroup( i, math.random( 0, entity:GetBodygroupCount( i ) - 1 ) )
		end
	end

	-- Randomize color
	if ( tobool( self:GetClientNumber( "randomColor" ) ) ) then
		entity:SetColor( ColorRand() )
	end
end

-- Spawns props from positions in a table
function TOOL:SpawnPropTable( player, trace, sid )
	if ( next( modelPathTable ) == nil ) then return end
	if ( next( modelPathTable[sid] ) == nil ) then return end
	local transformTable = self:CreateLocalTransformArray();
	if ( next( transformTable ) == nil ) then return end

	-- Adds random offsets to the whole array
	self:RandomizeTransformArrayPosition( transformTable )
	-- Offsets and rotates the array as a whole, and returns the array ralative rotation for objects
	local elementAngleStatic = self:ModifyTransformArray( trace, transformTable )
	local elementAngle = Angle()

	local spawnChance = self:GetClientNumber( "spawnChance" )

	undo.Create( "rat_array_object" )
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
		if ( util.IsValidProp( modelPath ) ) then entityType = "prop_physics" end
		if ( util.IsValidRagdoll( modelPath ) ) then entityType = "prop_ragdoll" end

		local entity = ents.Create( entityType )
		print( modelPath .. " is le path for de modul" )
		entity:SetModel( modelPath ) -------------
		entity:SetPos( trace.HitPos + transform )
		entity:SetAngles( elementAngle )
		entity:Spawn()

		self:RandomizeEntityModel( entity )

		-- Freeze prop
		if ( tobool( self:GetClientNumber( "spawnFrozen" ) ) ) then
			local phys = entity:GetPhysicsObject()
			if ( phys:IsValid() ) then
				phys:EnableMotion( false )
				player:AddFrozenPhysicsObject( entity, phys )
			end
			if ( entity:IsRagdoll() && !tobool( self:GetClientNumber( "freezeRootBoneOnly" ) ) ) then
				local boneCount = entity:GetPhysicsObjectCount()

				for bone = 1, boneCount - 1 do
					local physBone = entity:GetPhysicsObjectNum( bone )
					physBone:EnableMotion( false )
					-- Causes severe lag because of the halo effect, but can be a bit confusing/annoying to unfreeze a ragdoll without..
					player:AddFrozenPhysicsObject( entity, physBone )
				end
			end
		end

		-- Add entity to undo and cleanup
		undo.AddEntity( entity )
		self:GetOwner():AddCleanup( "rat_arrays", entity )
	end

	undo.Finish()
end



function TOOL:LeftClick( trace )
	if ( CLIENT ) then
		print( "Left got clicked" )
	end

	if ( SERVER ) then
		local player = self:GetOwner()
		local sid = player:SteamID()

		-- Spawns the props
		self:SpawnPropTable( player, trace, sid )
	end
	return true
end

function TOOL:RightClick( trace )
	if ( SERVER ) then
		-- Randomize entity under crosshair
		self:RandomizeEntityModel( trace.Entity )
	end
	return true
end

function TOOL:Reload( trace )
	if ( SERVER ) then
		local foundEnts = ents.FindInSphere( trace.HitPos, self:GetClientNumber( "sphereRadius" ) )
		-- Randomize entities within sphere volume
		for i, entity in pairs( foundEnts ) do
			self:RandomizeEntityModel( entity )
		end
	end
	return true
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
		print ( "The word .mdl was found in path: " .. inputDirectory )
		local tempTable = { inputDirectory }
		return tempTable
	else
		local tempMdlTable = {}
		print( "==[LOADING " .. inputDirectory .. "]===========================================" )
		local fileList = file.Find( inputDirectory .. "/*.mdl", "GAME" )
		PrintTable( fileList )
		for i, fileName in pairs( fileList ) do
			local directory = inputDirectory .. "/" .. fileName
			-- resource.AddFile( directory )
			table.insert( tempMdlTable, directory )
			print( "    >Loaded " .. directory )
		end
		print( "    >Loaded the directory " .. inputDirectory )

		return tempMdlTable
	end
end

-- Creates icons for the model list
local function AddSpawnIcon( inputListPanel, inputModelPath ) --------------------------------------------------------------------
	for i, path in ipairs( CheckModelPath( inputModelPath ) ) do
		local ListItem = inputListPanel:Add( "SpawnIcon" )
		ListItem:SetSize( 64, 64 )
		print( "Model path for icon is " .. path )
		ListItem:SetModel( path )

		ListItem.DoRightClick = function()
			RemoveFirstMatchInTable( modelPathTable, path )
			updateServerTables()
			print( "Going to remove myself" )
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

		-- Render thicc axis at trace hit
		local correctedHitAngle = trace.HitNormal:Angle()
		correctedHitAngle.x = correctedHitAngle.x + 90
		local thicc = 0.05
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( 5, thicc, thicc ), Color( 255, 0, 0, 255 ) , false )
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, 5, thicc ), Color( 0, 255, 0, 255 ) , false )
		render.DrawWireframeBox( trace.HitPos, correctedHitAngle, Vector( 0, 0, 0 ), Vector( thicc, thicc, 5 ), Color( 0, 0, 255, 255 ) , false )

		-- Render single box that envelops the whole array
		-- if ( #transformTable > 1 ) then
		-- 	local startPos = transformTable[0]
		-- 	local endPos = transformTable[#transformTable]
		-- 	render.DrawWireframeBox( trace.HitPos, Angle(), startPos, endPos, Color( 0, 255, 255, 255 ), false )
		-- end

		-- Render sphere for sphere volume
		render.DrawWireframeSphere( trace.HitPos, LocalPlayer():GetTool():GetClientNumber( "sphereRadius" ), 10, 10, Color( 0, 255, 255, 255 ), true )
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

local function MakeText( panel, color, str )
	local Text = vgui.Create( "DLabel" )
	Text:SetText( str )
	Text:SetAutoStretchVertical( true )
	Text:SetColor( color )
	Text:SetWrap( true )
	panel:AddItem( Text )

	return Text
end

local function MakeCheckbox( panel, titleString, convar, convarEnabledState )
	local enabledState = true

	if ( convarEnabledState != nil ) then
		enabledState = cvars.Bool( convarEnabledState )
	end

	local control = vgui.Create( "DSizeToContents" )
	control:DockPadding( 0, -2, 0, -2 )
	control:Dock( TOP )
	panel:AddItem( control )

	local checkBox = vgui.Create( "DCheckBox", control )
	checkBox:DockMargin( 0, 3, 0, 2 )
	checkBox:SetConVar( convar )
	checkBox:SetEnabled( enabledState )
	checkBox:Dock( LEFT )

	local label = vgui.Create( "DLabel", control )
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

end

local function MakeNumberWang( panel, titleString, convar, min, max, leftSpacing, topSpacing )
	local control = vgui.Create( "DSizeToContents" )
	control:Dock( TOP )
	control:DockPadding( leftSpacing, topSpacing, 5, 0 )
	panel:AddItem( control )

	local numbox = vgui.Create( "DNumberWang", control )
	numbox:SetSize( 40, 20 )
	numbox:SetMinMax( min, max )
	numbox:Dock( LEFT )
	numbox:DockMargin( 0, 0, 0, 1 )
	numbox:SetConVar( convar )
	numbox:SetValue( cvars.Number( convar ) )

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( titleString ) )
	label:SetDark( true )
	label:Dock( TOP )
end

local function MakeAxisSlider( panel, color, titleString, min, max, conVar )
	local DermaNumSlider = vgui.Create( "DNumSlider" )
	DermaNumSlider:SetText( stringSpacing .. language.GetPhrase( titleString ) )
	DermaNumSlider:SetMinMax( min, max )
	DermaNumSlider:SetTall( 15 )
	DermaNumSlider:SetDecimals( 0 )
	DermaNumSlider:SetDark( true )
	DermaNumSlider:SetConVar( conVar )
	DermaNumSlider.Paint = function()
		surface.SetDrawColor( color )
		surface.DrawRect( 0, 3, 4, 10 )
	end
	panel:AddItem( DermaNumSlider )

	return DermaNumSlider
end

local function MakeAxisSliderGroup( panel, titleString, tooltipString, min, max, conVar1, conVar2, conVar3 )
	local Text = MakeText( panel, Color( 50, 50, 50 ), titleString )
	Text:SetTooltip( tooltipString )
	Text:SetMouseInputEnabled( true )
	function Text:DoClick()
		GetConVar( conVar1 ):Revert()
		GetConVar( conVar2 ):Revert()
		GetConVar( conVar3 ):Revert()
	end
	function Text:OnCursorEntered()
		Text:SetColor( Color( 200, 100, 0 ) )
	end
	function Text:OnCursorExited()
		Text:SetColor( Color( 50, 50, 50 ) )
	end

	MakeAxisSlider( panel, Color( 230, 0, 0 ), "#tool.rat.xAxis", min, max, conVar1 )
	MakeAxisSlider( panel, Color( 0, 230, 0 ), "#tool.rat.yAxis", min, max, conVar2 )
	MakeAxisSlider( panel, Color( 0, 0, 230 ), "#tool.rat.zAxis", min, max, conVar3 )
end

local function ChangeAndColorModelCount( panel )
	if ( GetConVar( "rat_xAmount" ) == nil || GetConVar( "rat_yAmount" ) == nil || GetConVar( "rat_zAmount" ) == nil ) then return end
	local xAmount = GetConVar( "rat_xAmount" ):GetInt()
	local yAmount = GetConVar( "rat_yAmount" ):GetInt()
	local zAmount = GetConVar( "rat_zAmount" ):GetInt()

	local totalAmount = xAmount * yAmount * zAmount

	panel:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.numOfObjects" ) .. totalAmount )

	if ( totalAmount < 750 ) then
		panel:SetColor( Color( 250, 250, 250 ) ) -- White
	elseif ( totalAmount < 1500 ) then
		panel:SetColor( Color( 255, 200, 90 ) ) -- Orange
	else
		panel:SetColor( Color( 255, 133, 127 ) ) -- Red
	end
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
	cvars.RemoveChangeCallback("rat_ignoreSurfaceAngle", "rat_ignoreSurfaceAngle_callback")

	panel:Clear()
	self.BuildCPanel( panel )
end

function TOOL.BuildCPanel( cpanel )
	MakeText( cpanel, Color( 50, 50, 50 ), "#tool.rat.desc" )

	MakeCheckbox( cpanel, "#tool.rat.spawnFrozen", "rat_spawnFrozen" )
	MakeCheckbox( cpanel, "#tool.rat.freezeRootBoneOnly", "rat_freezeRootBoneOnly" )
	MakeCheckbox( cpanel, "#tool.rat.randomColor", "rat_randomColor" )
	MakeCheckbox( cpanel, "#tool.rat.randomSkin", "rat_randomSkin" )
	MakeCheckbox( cpanel, "#tool.rat.randomBodygroup", "rat_randomBodygroup" )

	cpanel:ControlHelp( "" )

	MakeNumberWang( cpanel, "#tool.rat.randomSkip", "rat_randomSkip", 0, 100, 0, 0 )
	MakeNumberWang( cpanel, "#tool.rat.spawnChance", "rat_spawnChance", 0, 100, 0, 0 )

	cpanel:ControlHelp( "" )


	--[[----------------------------------------------------------------]] --Model List Description
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetExpanded( 0 )
	DCollapsible:SetLabel( "#tool.rat.listHelpTitle" )
	cpanel:AddItem( DCollapsible )

	local DermaList = vgui.Create( "DPanelList" )
	DermaList:SetAutoSize( true )
	DermaList:SetSpacing( 4 )
	DermaList:SetPadding( 8 )
	DermaList.Paint = function()
		surface.SetDrawColor( 235, 245, 255, 255 )
		surface.DrawRect( 0, 0, 1000, 500 )
	end
	DCollapsible:SetContents( DermaList )

	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp1" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp2" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp3" )
	-- MakeText( DermaList, Color( 50, 50, 50 ), "- Left click on one of the model icons to be able to configure and constrain the bodygroups and skins it will be spawned with." )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp4" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp5" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.listHelp6" )


	--[[----------------------------------------------------------------]] --Model Grid List
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
			print( "Trying to drop" )

			for i, panel in pairs( inputPanels ) do
				if ( panel:GetName() != "SpawnIcon" ) then continue end
				local currentMdlPath = panel:GetModelName()
				AddSpawnIcon( MdlView, currentMdlPath )
			end

			updateServerTables()

			if ( inputPanels[1]:GetName() != "SpawnIcon" ) then return end
			print( "You just dropped " .. inputPanels[1]:GetModelName() .. " on me." )
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
	-- The function needs to be made before it gets referenced, but also after the ui it is referencing, and the button needs to be added before the model list
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



	--[[----------------------------------------------------------------]] --Array visualization options
	MakeCheckbox( cpanel, "#tool.rat.ignoreSurfaceAngle", "rat_ignoreSurfaceAngle" )
	MakeCheckbox( cpanel, "#tool.rat.facePlayerZ", "rat_facePlayerZ", "rat_ignoreSurfaceAngle" )
	MakeCheckbox( cpanel, "#tool.rat.previewPosition", "rat_previewAxis" )
	MakeCheckbox( cpanel, "#tool.rat.previewOffset", "rat_previewBox" )

	MakeNumberWang( cpanel, "#tool.rat.sphereRadius", "rat_sphereRadius", 0, 9999, 0, 0 )

	--[[----------------------------------------------------------------]] --Model Counter
	local NumberOfModelsText = vgui.Create( "DLabel" )
	NumberOfModelsText:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.numOfObjects" ) .. "1" )
	NumberOfModelsText:SetFont( "DermaDefaultBold" )
	NumberOfModelsText:SetTall( 20 )
	NumberOfModelsText:SetColor( Color( 250, 250, 250 ) )
	NumberOfModelsText:SetWrap( true )
	NumberOfModelsText.Paint = function()
		draw.RoundedBoxEx( 4, 0, 0, 200, 19, Color( 127, 127, 127 ), true, true, false, false )
	end
	cpanel:AddItem( NumberOfModelsText )

	ChangeAndColorModelCount( NumberOfModelsText ) -- Make sure the text shows the correct count

	-- Only reliable way I found to update this value was a bunch of callbacks
	-- If using GetConVar within DNumberWang:OnValueChanged it would return the previous value
	cvars.AddChangeCallback("rat_xAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorModelCount( NumberOfModelsText )
	end, "rat_xAmount_callback")
	cvars.AddChangeCallback("rat_yAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorModelCount( NumberOfModelsText )
	end, "rat_yAmount_callback")
	cvars.AddChangeCallback("rat_zAmount", function( convarName, valueOld, valueNew )
		ChangeAndColorModelCount( NumberOfModelsText )
	end, "rat_zAmount_callback")


	local control = vgui.Create( "DPanelList" ) ----
	control:Dock( TOP )
	control:DockMargin( 0, -10, 0, 0 )
	control:SetAutoSize( true )
	control:SetPadding( 4 )
	control.Paint = function()
		surface.SetDrawColor( 230, 230, 230, 255 )
		surface.DrawRect( 0, 0, 200, 200 )
	end
	cpanel:AddItem( control )

	MakeNumberWang( control, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.xAxis" ), "rat_xAmount", 1, 999, 10, 10 )
	MakeNumberWang( control, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.yAxis" ), "rat_yAmount", 1, 999, 10, 5 )
	MakeNumberWang( control, language.GetPhrase( "#tool.rat.numberIn" ) .. language.GetPhrase( "#tool.rat.zAxis" ), "rat_zAmount", 1, 999, 10, 5 )


	--[[----------------------------------------------------------------]] --SPAWN TRANSFORMS
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetLabel( "#tool.rat.pointTransforms" )
	function DCollapsible:OnToggle( val )
		GetConVar( "rat_pointTransformExpanded" ):SetInt( val && 1 || 0 ) -- 1 if val is true, 0 if false
	end
	if ( GetConVar( "rat_pointTransformExpanded" ) != nil ) then
		DCollapsible:SetExpanded( GetConVar( "rat_pointTransformExpanded" ):GetInt() )
	end
	cpanel:AddItem( DCollapsible )

	local DermaList = vgui.Create( "DPanelList" )
	DermaList:SetAutoSize( true )
	DermaList:SetSpacing( 4 )
	DermaList:SetPadding( 8 )
	DermaList.Paint = function()
		surface.SetDrawColor( 235, 245, 255, 255 )
		surface.DrawRect( 0, 0, 1000, 500 )
	end
	DCollapsible:SetContents( DermaList )


	MakeAxisSliderGroup( DermaList, "#tool.rat.pointSpacing", "#tool.rat.pointSpacingDescription", -1000, 1000,
	"rat_xOffsetBase", "rat_yOffsetBase", "rat_zOffsetBase" )

	MakeText( DermaList, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( DermaList, "#tool.rat.pointRotation", "#tool.rat.pointRotationDescription", -180, 180,
	"rat_xRotationBase", "rat_yRotationBase", "rat_zRotationBase" )


	--[[----------------------------------------------------------------]] --ARRAY OFFSETS
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetLabel( "#tool.rat.arrayTransforms" )
	function DCollapsible:OnToggle( val )
		GetConVar( "rat_arrayTransformsExpanded" ):SetInt( val && 1 || 0 ) -- 1 if val is true, 0 if false
	end
	if ( GetConVar( "rat_arrayTransformsExpanded" ) != nil ) then
		DCollapsible:SetExpanded( GetConVar( "rat_arrayTransformsExpanded" ):GetInt() )
	end
	cpanel:AddItem( DCollapsible )

	local DermaList = vgui.Create( "DPanelList" )
	DermaList:SetAutoSize( true )
	DermaList:SetSpacing( 4 )
	DermaList:SetPadding( 8 )
	DermaList.Paint = function()
		surface.SetDrawColor( 235, 245, 255, 255 )
		surface.DrawRect( 0, 0, 1000, 500 )
	end
	DCollapsible:SetContents( DermaList )


	MakeAxisSliderGroup( DermaList, "#tool.rat.arrayOffset", "#tool.rat.arrayOffsetDescription", -1000, 1000,
	"rat_xArrayOffset", "rat_yArrayOffset", "rat_zArrayOffset" )

	MakeText( DermaList, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( DermaList, "#tool.rat.arrayRotation", "#tool.rat.arrayRotationDescription", -180, 180,
	"rat_xArrayRotation", "rat_yArrayRotation", "rat_zArrayRotation" )


	--[[----------------------------------------------------------------]] --RANDOM SPAWN OFFSETS
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetLabel( "#tool.rat.randomPointTransforms" )
	function DCollapsible:OnToggle( val )
		GetConVar( "rat_randomPointTransformsExpanded" ):SetInt( val && 1 || 0 ) -- 1 if val is true, 0 if false
	end
	if ( GetConVar( "rat_randomPointTransformsExpanded" ) != nil ) then
		DCollapsible:SetExpanded( GetConVar( "rat_randomPointTransformsExpanded" ):GetInt() )
	end
	cpanel:AddItem( DCollapsible )

	local DermaList = vgui.Create( "DPanelList" )
	DermaList:SetAutoSize( true )
	DermaList:SetSpacing( 4 )
	DermaList:SetPadding( 8 )
	DermaList.Paint = function()
		surface.SetDrawColor( 235, 245, 255, 255 )
		surface.DrawRect( 0, 0, 1000, 500 )
	end
	DCollapsible:SetContents( DermaList )


	MakeAxisSliderGroup( DermaList, "#tool.rat.randomPointSpacing", "#tool.rat.randomPointSpacingDescription", 0, 1000,
	"rat_xOffsetRandom", "rat_yOffsetRandom", "rat_zOffsetRandom" )

	MakeText( DermaList, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( DermaList, "#tool.rat.randomPointRotation", "#tool.rat.randomPointRotationDescription", 0, 180,
	"rat_xRotationRandom", "rat_yRotationRandom", "rat_zRotationRandom" )

	MakeText( DermaList, Color( 50, 50, 50 ), "" )

	MakeAxisSliderGroup( DermaList, "#tool.rat.randomPointRotationStepped", "#tool.rat.randomRotationSteppedDescription", 0, 180,
	"rat_xRotationRandomStepped", "rat_yRotationRandomStepped", "rat_zRotationRandomStepped" )


	--[[----------------------------------------------------------------]] --DEBUG

	local div = vgui.Create( "DVerticalDivider" )
	-- div:Dock( FILL ) -- Make the divider fill the space of the DFrame
	div:SetPaintBackground( false )
	cpanel:AddItem( div )

	local div2 = vgui.Create( "DVerticalDivider" )
	-- div:Dock( FILL ) -- Make the divider fill the space of the DFrame
	div2:SetPaintBackground( false )
	cpanel:AddItem( div2 )



	local CheckButton = vgui.Create( "DButton" )
	CheckButton:SetText( "Check List" )
	CheckButton.DoClick = function()
		if LocalPlayer():GetTool() && LocalPlayer():GetTool().CheckList then
			print( "passed check" )
			LocalPlayer():GetTool():CheckList()
		end
	end
	cpanel:AddItem( CheckButton )

	local UpdateButton = vgui.Create( "DButton" )
	UpdateButton:SetText( "Update Control Panel" )
	UpdateButton.DoClick = function()
		if LocalPlayer():GetTool() && LocalPlayer():GetTool().UpdateControlPanel then
			print( "passed check" )
			LocalPlayer():GetTool():UpdateControlPanel()
		end
	end
	cpanel:AddItem( UpdateButton )
end
