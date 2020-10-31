-- Tool made by func_Mathias

TOOL.Name = "#tool.rat.name"
TOOL.Description = "#tool.rat.desc"
TOOL.Category = "func_Mathias"

local entToRandom = NULL
local toolActive = false
local stringSpacing = "   "

local xArrayRotation = 0
local yArrayRotation = 0
local zArrayRotation = 0

local xAmount = 1
local xOffsetBase = 0
local xOffsetRandom = 0
local xRotationBase = 0
local xRotationRandom = 0

local yAmount = 1
local yOffsetBase = 0
local yOffsetRandom = 0
local yRotationBase = 0
local yRotationRandom = 0

local zAmount = 1
local zOffsetBase = 0
local zOffsetRandom = 0
local zRotationBase = 0
local zRotationRandom = 0

local transformTable = {} -- Base Position, Base Rotation

local modelPathTable = {} -- Model sting paths

TOOL.ClientConVar["spawnFrozen"] = "1"
TOOL.ClientConVar["randomSkin"] = "1"
TOOL.ClientConVar["randomBG"] = "1"
TOOL.ClientConVar["randomSkip"] = "0"

TOOL.ClientConVar["previewAxis"] = "1"
TOOL.ClientConVar["previewBox"] = "1"
TOOL.ClientConVar["sphereRadius"] = "0"

TOOL.ClientConVar["mdlName"] = ""

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
	language.Add( "tool.rat.randomSkin", "Randomize skins" )
	language.Add( "tool.rat.randomBG", "Randomize bodygroups" )
	language.Add( "tool.rat.randomSkip", "Skip this many bodygroups" )
	language.Add( "tool.rat.sphereRadius", "Sphere radius" )

	language.Add( "tool.rat.listHelpTitle", "Object list help - Click for info" )
	language.Add( "tool.rat.listHelp1", "With the panel below you can keep track of the models you want to randomly spawn." )
	language.Add( "tool.rat.listHelp2", "- You can drag and drop any model from the default spawnlist into the grey panel below to add them. You can select and drag multiple at once!" )
	language.Add( "tool.rat.listHelp3", "- You can also add models by using a path, if it's a path to a folder it will add every model in the folder. Be careful with folders containing a big amount of models." )
	language.Add( "tool.rat.listHelp4", "- Right click on one of the model icons to remove it from the list." )
	language.Add( "tool.rat.listHelp5", "- Tip: Adding multiple copies of the same model will increase it's chance of being spawned." )
	language.Add( "tool.rat.listHelp6", "- Tip: There is no option for saving your list but you can create a custom spawnlist to keep all the desired models in one place for easy adding to this list." )

	language.Add( "tool.rat.previewPosition", "Show position preview" )
	language.Add( "tool.rat.previewOffset", "Show random position offset" )

	language.Add( "tool.rat.mdlAdd", "Add model by path" )
	language.Add( "tool.rat.mdlAddButton", "Add to list from path" )
	language.Add( "tool.rat.mdlClearButton", "Clear model list" )

	language.Add( "tool.rat.numOfObjects", "Number of objects: " )
	language.Add( "tool.rat.copiesIn", "Copies in " )

	language.Add( "tool.rat.spawnTransform", "Spawn transforms" )
	language.Add( "tool.rat.spacing", "Spacing" )
	language.Add( "tool.rat.rotation", "Rotation" )
	language.Add( "tool.rat.randomSpawnOffsets", "Random spawn offsets" )
	language.Add( "tool.rat.randomSpacing", "Random spacing" )
	language.Add( "tool.rat.randomRotation", "Random rotation" )
	language.Add( "tool.rat.xAxis", "X axis" )
	language.Add( "tool.rat.yAxis", "Y axis" )
	language.Add( "tool.rat.zAxis", "Z axis" )

	language.Add( "tool.rat.undo", "Undone random array" )

end

if (SERVER) then

	util.AddNetworkString( "sendTables" ) -- Register the Network String

	net.Receive( "sendTables", function( len, player ) -- When the server receives the clients Network information

		local sid = player:SteamID()
		modelPathTable[sid] = net.ReadTable()
		transformTable[sid] = net.ReadTable()

		print( "--- Model Table ---" )
		PrintTable( modelPathTable ) -- Print the return value of the function, with our defined parameters.
		print( "--- Model Table ---" )

	end)
end

local function CalcualteBaseTransforms() --Calculates the position for each spawnpoint, used for preview and spawning
	transformTable = {}
	local i = 0

	for x = 0, xAmount - 1 do
		transformTable[i] = {
			Vector( xOffsetBase * x, 0, 0 ), -- Position
			Angle( xRotationBase, yRotationBase, zRotationBase ), -- Rotation
		}
		i = i + 1

		for y = 0, yAmount - 1 do
			if (y != 0) then -- This for loop needs to skip the first cycle without affecting the next for loop
				transformTable[i] = {
					Vector( xOffsetBase * x, yOffsetBase * y, 0 ), -- Position
					Angle( xRotationBase, yRotationBase, zRotationBase ), -- Rotation
				}
				i = i + 1
			end

			for z = 1, zAmount - 1 do
				transformTable[i] = {
					Vector( xOffsetBase * x, yOffsetBase * y, zOffsetBase * z ), -- Position
					Angle( xRotationBase, yRotationBase, zRotationBase ), -- Rotation
				}
				i = i + 1
			end
		end
	end
end

CalcualteBaseTransforms()

function TOOL:RandomizeEntityModel( entity )
	if ( !IsValid( entity ) ) then return end
	if ( entity:GetClass() == "prop_effect" ) then entity = entity.AttachedEntity end -- Needed to change prop_effects when tracing directly

	-- print( "entity class " .. entity:GetClass() )
	-- print( "entity skin count " .. entity:SkinCount() )
	-- print( "entity number of bodygroup" .. entity:GetNumBodyGroups() )

	if ( tobool( self:GetClientNumber( "randomSkin" ) ) ) then
		entity:SetSkin( math.random( 0, entity:SkinCount() - 1 ) )
	end

	if ( tobool( self:GetClientNumber( "randomBG" ) ) ) then
		for i = 0, entity:GetNumBodyGroups() do
			if ( i <= self:GetClientNumber( "randomSkip" ) ) then continue end
			entity:SetBodygroup( i, math.random( 0, entity:GetBodygroupCount( i ) - 1 ) )
		end
	end
end


function TOOL:SpawnPropTable( player, trace, sid )
	if ( next( transformTable ) == nil || next( modelPathTable ) == nil ) then return end
	undo.Create( "prop" )
	undo.SetCustomUndoText( "#tool.rat.undo" )
	undo.SetPlayer( player )

	for i, v in pairs( transformTable[sid] ) do

		-- if trace.HitNonWorld then return end -- If the player is not looking at the ground then return

		local rotatedRelPos = Vector() + transformTable[sid][i][1]
		rotatedRelPos:Rotate( trace.HitNormal:Angle() )

		local entity = ents.Create( "prop_physics" )
		print( modelPathTable[sid][math.random( #modelPathTable[sid] )] .. " is le path for de modul" )
		entity:SetModel( modelPathTable[sid][math.random( #modelPathTable[sid] )] ) -------------
		entity:SetPos( trace.HitPos + rotatedRelPos )
		entity:SetAngles( transformTable[sid][i][2] + trace.HitNormal:Angle() )
		entity:Spawn()
		entToRandom = entity

		self:RandomizeEntityModel( entity )

		local phys = entity:GetPhysicsObject()
		if ( phys:IsValid() ) then
			frozen = !tobool( self:GetClientNumber( "spawnFrozen" ) )
			phys:EnableMotion( frozen ) --Freeze prop
		end

		entity:EmitSound( "npc/scanner/combat_scan5.wav" )

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
		if ( next( transformTable ) == nil || next( modelPathTable ) == nil ) then return end
		local player = self:GetOwner()
		local sid = player:SteamID()
		print( #transformTable[sid] .. " is a number" )
		print( #modelPathTable[sid] .. " is another number" )
		PrintTable( transformTable[sid] )

		self:SpawnPropTable( player, trace, sid ) --Spawns the props
	end
	return true
end

function TOOL:RightClick( trace )
	if ( SERVER ) then
		self:RandomizeEntityModel( trace.Entity )
	end
	return true
end

function TOOL:Reload( trace )
	if ( SERVER ) then
		-- self.Ready = 0
		local foundEnts = ents.FindInSphere( trace.HitPos, self:GetClientNumber( "sphereRadius" ) )
		for i, f in pairs( foundEnts ) do
			if ( IsValid( foundEnts[i] ) ) then
				self:RandomizeEntityModel( foundEnts[i] )
			end
		end
	end
	return true
end



function TOOL:CheckList()
	print( "--- Model Table ---" )
	PrintTable( modelPathTable )
	print( "--- Model Table ---" )
end

local function RemoveFirstMatchInTable( tbl, val )
	for i, v in ipairs( tbl ) do
		if v == val then
			table.remove( tbl, i )
			return
		end
	end
end

local function updateServerTables()
	net.Start( "sendTables" )
	net.WriteTable( modelPathTable )
	net.WriteTable( transformTable )
	net.SendToServer()
end

local function CheckModelPath( dir )
	if string.find( dir, "%.mdl" ) then
		print ( "The word .mdl was found." )
		local tampTable = { dir }
		return tampTable
	else
		local tempMdlTable = {} -- models/ocdev/cars/truck           test string
		print( "==[LOADING " .. dir .. "]===========================================" )
		local list = file.Find( dir .. "/*.mdl", "GAME" ) -- Change *.lua to what file format you want to load for example .mdl
		PrintTable( list )
			for i, f in pairs( list ) do
				local directory = dir .. "/" .. f
				-- resource.AddFile(directory)
				table.insert( tempMdlTable, directory )
				print( "    >Loaded " .. directory )
			end
			print( "    >Loaded the directory " .. dir )
		return tempMdlTable
	end
end

local function AddSpawnIcon( mdlPanel, mdlPath ) --------------------------------------------------------------------
	local modelList = CheckModelPath( mdlPath )

	for i, v in ipairs( modelList ) do
		local ListItem = mdlPanel:Add( "SpawnIcon" )
		ListItem:SetSize( 64, 64 )
		print( "Model path for icon is " .. modelList[i] )
		ListItem:SetModel( modelList[i] )

		ListItem.DoRightClick = function()
			RemoveFirstMatchInTable( modelPathTable, modelList[i] )
			updateServerTables()
			print( "Going to remove myself" )
			ListItem:Remove()
		end

		table.insert( modelPathTable, modelList[i] )
	end

	updateServerTables()
end

local function RenderAxis( pos, ang )
	--Rotate only changes the original vector and doesn't return anything, so need to waste some space sadly
	local linePosZ = Vector( 0, 0, 5 )
	local linePosY = Vector( 0, 5, 0 )
	local linePosX = Vector( 5, 0, 0 )
	linePosZ:Rotate( ang )
	linePosY:Rotate( ang )
	linePosX:Rotate( ang )

	render.DrawLine( pos, pos + linePosZ, Color( 0, 0, 255, 255 ), false ) -- Blue
	render.DrawLine( pos, pos + linePosY, Color( 0, 255, 0, 255 ), false ) -- Green
	render.DrawLine( pos, pos + linePosX, Color( 255, 0, 0, 255 ), false ) -- Red

	-- debugoverlay.Axis( pos + Vector( -10, 0, 0 ), ang, 5, 5, true ) --To compare and make sure my axis directions are correct, "developer 1" needed in console
	--Render red last to make sure it's always on top and visible
end


hook.Add( "PostDrawTranslucentRenderables", "spawnPreviewPositionRender", function( ) --Draws an axis and wireframe box per position
	if ( toolActive && LocalPlayer():GetTool() ) then
		local trace = LocalPlayer():GetEyeTrace()

		local prevAxis = LocalPlayer():GetTool():GetClientNumber( "previewAxis" )
		local prevBox = LocalPlayer():GetTool():GetClientNumber( "previewBox" )

		for i = 0, #transformTable do
			local rotatedRelPos = Vector() + transformTable[i][1]
			rotatedRelPos:Rotate( trace.HitNormal:Angle() + Angle( xArrayRotation, yArrayRotation, zArrayRotation ) )

			-- local rotatedRelRot = Angle() + transformTable[i][2]
			-- rotatedRelRot:Rotate( trace.HitNormal:Angle() )

			if ( tobool( prevAxis ) ) then
				RenderAxis( trace.HitPos + rotatedRelPos, trace.HitNormal:Angle() )
			end

			if ( tobool( prevBox ) ) then
				render.DrawWireframeBox( trace.HitPos + rotatedRelPos, trace.HitNormal:Angle(), Vector( 0.5, 2.5, 2.5 ), Vector( -0.5, -2.5, -2.5 ), Color( 0, 255, 255, 255 ), false )
			end
		end

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
end

local function MakeAxisSlider( panel, color, str, min, max, valueToChange )
	local DermaNumSlider = vgui.Create( "DNumSlider" )
	DermaNumSlider:SetText( stringSpacing .. language.GetPhrase( str ) )
	DermaNumSlider:SetMinMax( min, max )
	DermaNumSlider:SetTall( 15 )
	DermaNumSlider:SetDecimals( 0 )
	DermaNumSlider:SetDark( true )
	DermaNumSlider.Paint = function()
		surface.SetDrawColor( color )
		surface.DrawRect( 0, 3, 4, 10 )
	end
	panel:AddItem( DermaNumSlider )

	function DermaNumSlider:OnValueChanged( val )
		-- valueToChange = val
		print( val )
		CalcualteBaseTransforms()
		updateServerTables()
		-- return val
	end

	return DermaNumSlider
end

local function ChangeAndColorModelCount( panel )
	panel:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.numOfObjects" ) .. #transformTable + 1 )

	if ( #transformTable + 1 < 750 ) then
		panel:SetColor( Color( 250, 250, 250 ) ) -- White
	elseif ( #transformTable + 1 < 1500 ) then
		panel:SetColor( Color( 255, 200, 90 ) ) -- Orange
	else
		panel:SetColor( Color( 255, 133, 127 ) ) -- Red
	end
end

-- Delete this later
function TOOL:UpdateControlPanel( index )
	local panel = controlpanel.Get( "rat" )
	if ( !panel ) then MsgN( "No panel found for Random Array Tool!" ) return end

	panel:ClearControls()
	self.BuildCPanel( panel )
	CalcualteBaseTransforms()
	updateServerTables()
end

function TOOL.BuildCPanel( cpanel )
	MakeText( cpanel, Color( 50, 50, 50 ), "#tool.rat.desc" )

	cpanel:CheckBox( "#tool.rat.spawnFrozen", "rat_spawnFrozen" )
	cpanel:CheckBox( "#tool.rat.randomSkin", "rat_randomSkin" )
	cpanel:CheckBox( "#tool.rat.randomBG", "rat_randomBG" )

	-- cpanel:ControlHelp( "" )
	-- cpanel:ControlHelp( "#tool.rat.randomSkipdesc" )

	local control = vgui.Create( "DSizeToContents" )
	control:Dock( TOP )
	control:DockPadding( 5, 5, 5, 0 )
	cpanel:AddItem(control)

	local textbox = vgui.Create( "DNumberWang", control )
	textbox:SetSize( 40, 20 )
	textbox:SetConVar( "rat_randomSkip" )
	textbox:Dock( LEFT )

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.randomSkip" ) )
	label:SetDark( true )
	label:Dock( TOP )



	local control = vgui.Create( "DSizeToContents" )
	control:Dock( TOP )
	control:DockPadding( 5, 5, 5, 0 )
	cpanel:AddItem(control)

	local textbox = vgui.Create( "DNumberWang", control )
	textbox:SetSize( 40, 20 )
	textbox:SetMax( 9999 )
	textbox:SetConVar( "rat_sphereRadius" )
	textbox:Dock( LEFT )

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.sphereRadius" ) )
	label:SetDark( true )
	label:Dock( TOP )

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

	Scroll:Receiver( "SandboxContentPanel", function(self, panels, dropped)
		if ( dropped ) then
			print( "Trying to drop" )

			-- AddSpawnIcon( MdlView, panels[1]:GetModelName() )

			for i, v in pairs( panels ) do
				if ( panels[i]:GetName() != "SpawnIcon" ) then continue end
				local currentMdlPath = panels[i]:GetModelName()
				AddSpawnIcon( MdlView, currentMdlPath )
				updateServerTables()
			end

			if ( panels[1]:GetName() != "SpawnIcon" ) then return end
			print( "You just dropped " .. panels[1]:GetModelName() .. " on me." )
		end
	end)


	local AddButton = vgui.Create( "DButton" )
	AddButton:SetText( "#tool.rat.mdlAddButton" )
	AddButton:SetTooltip( "#tool.rat.mdlAddButton" )
	AddButton.DoClick = function()
		AddSpawnIcon( MdlView, GetConVar( "rat_mdlName" ):GetString() )
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
		local MdlIcons = MdlView:GetChildren()
		for i, v in pairs( MdlIcons ) do
			MdlIcons[i]:Remove()
		end
		modelPathTable = {}
		updateServerTables()
	end
	cpanel:AddItem( ClearButton )



	--[[----------------------------------------------------------------]] --Spawnpoint settings
	cpanel:CheckBox( "#tool.rat.previewPosition", "rat_previewAxis" )
	cpanel:CheckBox( "#tool.rat.previewOffset", "rat_previewBox" )


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

	local control = vgui.Create( "DSizeToContents" ) ----
	control:Dock( TOP )
	control:DockPadding( 50, 10, 0, 10 )
	control:DockMargin( 0, -10, 0, 0 )
	control.Paint = function()
		surface.SetDrawColor( 230, 230, 230, 255 )
		surface.DrawRect( 0, 0, 200, 200 )
	end
	cpanel:AddItem( control )


	----------------------------------------------------
	local numbox = vgui.Create( "DNumberWang", control )
	numbox:SetSize( 40, 20 )
	numbox:SetPos( 10, 10 )
	numbox:SetValue( 1 )
	numbox:SetMinMax( 1, 999 )
	-- numbox:SetConVar( "rat_randomSkip" )
	-- numbox:Dock( LEFT )

	function numbox:OnValueChanged( val )
		xAmount = val
		CalcualteBaseTransforms()
		ChangeAndColorModelCount( NumberOfModelsText )
		updateServerTables()
	end

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.copiesIn" ) .. language.GetPhrase( "#tool.rat.xAxis" ) )
	label:SetDark( true )
	-- label:DockMargin( 0, 10, 0, 0 )
	label:Dock( TOP )


	----------------------------------------------------
	local numbox = vgui.Create( "DNumberWang", control )
	numbox:SetSize( 40, 20 )
	numbox:SetPos( 10, 35 )
	numbox:SetValue( 1 )
	numbox:SetMinMax( 1, 999 )
	-- numbox:SetConVar( "rat_randomSkip" )
	-- numbox:Dock( LEFT )

	function numbox:OnValueChanged( val )
		yAmount = val
		CalcualteBaseTransforms()
		ChangeAndColorModelCount( NumberOfModelsText )
		updateServerTables()
	end

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.copiesIn" ) .. language.GetPhrase( "#tool.rat.yAxis" ) )
	label:SetDark( true )
	label:DockMargin( 0, 5, 0, 0 )
	label:Dock( TOP )


	----------------------------------------------------
	local numbox = vgui.Create( "DNumberWang", control )
	numbox:SetSize( 40, 20 )
	numbox:SetPos( 10, 60 )
	numbox:SetValue( 1 )
	numbox:SetMinMax( 1, 999 )
	-- numbox:SetConVar( "rat_randomSkip" )
	-- numbox:Dock( LEFT )

	function numbox:OnValueChanged( val )
		zAmount = val
		CalcualteBaseTransforms()
		ChangeAndColorModelCount( NumberOfModelsText )
		updateServerTables()
	end

	local label = vgui.Create( "DLabel", control )
	label:SetText( stringSpacing .. language.GetPhrase( "#tool.rat.copiesIn" ) .. language.GetPhrase( "#tool.rat.zAxis" ) )
	label:SetDark( true )
	label:DockMargin( 0, 5, 0, 0 )
	label:Dock( TOP )


	--[[----------------------------------------------------------------]] --SPAWN TRANSFORMS
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetExpanded( 1 )
	DCollapsible:SetLabel( "#tool.rat.spawnTransform" )
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

	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.spacing" )

	Slider = MakeAxisSlider( DermaList, Color( 230, 0, 0 ), "#tool.rat.xAxis", -1000, 1000, xOffsetBase )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 230, 0 ), "#tool.rat.yAxis", -1000, 1000, yOffsetBase )
	function Slider:OnValueChanged( val )
		yOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 0, 230 ), "#tool.rat.zAxis", -1000, 1000, zOffsetBase )
	function Slider:OnValueChanged( val )
		zOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end


	MakeText( DermaList, Color( 50, 50, 50 ), "" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.rotation" )

	Slider = MakeAxisSlider( DermaList, Color( 230, 0, 0 ), "#tool.rat.xAxis", -180, 180, xRotationBase )
	function Slider:OnValueChanged( val )
		xRotationBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 230, 0 ), "#tool.rat.yAxis", -180, 180, yRotationBase )
	function Slider:OnValueChanged( val )
		yRotationBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 0, 230 ), "#tool.rat.zAxis", -180, 180, zRotationBase )
	function Slider:OnValueChanged( val )
		zRotationBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end


	--[[----------------------------------------------------------------]] --RANDOM SPAWN OFFSETS
	local DCollapsible = vgui.Create( "DCollapsibleCategory" )
	DCollapsible:SetExpanded( 1 )
	DCollapsible:SetLabel( "#tool.rat.randomSpawnOffsets" )
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

	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.randomSpacing" )

	Slider = MakeAxisSlider( DermaList, Color( 230, 0, 0 ), "#tool.rat.xAxis", 0, 1000, xArrayRotation )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 230, 0 ), "#tool.rat.yAxis", 0, 1000, yArrayRotation )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 0, 230 ), "#tool.rat.zAxis", 0, 1000, zArrayRotation )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end


	MakeText( DermaList, Color( 50, 50, 50 ), "" )
	MakeText( DermaList, Color( 50, 50, 50 ), "#tool.rat.randomRotation" )

	Slider = MakeAxisSlider( DermaList, Color( 230, 0, 0 ), "#tool.rat.xAxis", -180, 180, xRotationBase )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 230, 0 ), "#tool.rat.yAxis", -180, 180, yRotationBase )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end
	Slider = MakeAxisSlider( DermaList, Color( 0, 0, 230 ), "#tool.rat.zAxis", -180, 180, zRotationBase )
	function Slider:OnValueChanged( val )
		xOffsetBase = val
		CalcualteBaseTransforms()
		updateServerTables()
	end


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
