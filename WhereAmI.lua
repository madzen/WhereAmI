--[[


	WhereAmI: Lets a player know where you are when they send you a tell with a certain trigger.
		Copyright (C) 2006-2012 Madzen


]]

-- Initialise the Addon
WhereAmI_Enabled = 1;

----------------------------------------------------------------------------
-- Function to handle initialisation.
-- Registers events, commands and informs the user that the addon is loaded.
----------------------------------------------------------------------------
function WhereAmI_OnLoad()	
	-- Register slash command
	SlashCmdList["WHEREAMISLASH"] = WhereAmI_Cmd;
	SLASH_WHEREAMISLASH1 = "/whereami";
	SLASH_WHEREAMISLASH2 = "/wai"
	
	-- Register events for loading variables, guild roster updates, guild chat and system messages
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_WHISPER");

	-- Inform user that the addon has been successfully loaded
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("WhereAmI has been Loaded");
	end
	
	UIErrorsFrame:AddMessage("WhereAmI", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

------------------------------------------
-- Main event handler.
-- Describes functionality for each event.
------------------------------------------
function WhereAmI_OnEvent()
	-- Event triggered when all variables have been loaded.
	if (event == "VARIABLES_LOADED") then
		-- Nowt
	end
	
	-- Event triggered when a system message is received.
	if (event == "CHAT_MSG_WHISPER" and WhereAmI_Enabled == 1) then
		local myLoc = "X";
		-- Send the system message for processing.
		if (string.find(arg1, "!loc")) then
			-- Whisper Location
			local posX, posY = GetPlayerMapPosition("player");
			posX = math.floor(posX * 100);
			posY = math.floor(posY * 100);

			local mainZone = GetZoneText();
			local subZone = GetSubZoneText();
			
			if (subZone == nil or subZone == "") then
				myLoc = "My current location is " .. mainZone .. " (" .. posX .. "," .. posY .. ")";
			else
				myLoc = "My current location is " .. subZone .. ", " .. mainZone .. " (" .. posX .. "," .. posY .. ")";
			end
			-- DEFAULT_CHAT_FRAME:AddMessage(myLoc .. " WHISPER " .. arg2);
			SendChatMessage(myLoc, "WHISPER", nil, arg2);
		end
	end
end


----------------------------------
-- Handle any slash commands used.
----------------------------------
function WhereAmI_Cmd(msg)
	-- Convert the command to lowercase for the sake of convenience.
	msg = string.lower(msg);
	
	-- User enables the addon.
	if (msg == "on") then
		WhereAmI_Enabled = 1;
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> WhereAmI has been enabled for this character", 1.0, 0.0, 0.0, 1.0, 20);
	-- User disables the addon.
	elseif (msg == "off") then
		WhereAmI_Enabled = 0;
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> WhereAmI has been disabled for this character", 1.0, 0.0, 0.0, 1.0, 20);	
	-- User requests help or doesn't provide a parameter.
	elseif (msg == "help" or msg == "") then
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> WhereAmI Usage:", 1.0, 0.0, 0.0, 1.0, 20);
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> on - Enables WhereAmI for this character.", 1.0, 0.0, 0.0, 1.0, 20);
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> off - Disables WhereAmI for this character.", 1.0, 0.0, 0.0, 1.0, 20);
		--DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> trigger <X> - Changes trigger to be <X>, e.g. /wai trigger !location", 1.0, 0.0, 0.0, 1.0, 20);
		DEFAULT_CHAT_FRAME:AddMessage("<WhereAmI> help - Provides this command list.", 1.0, 0.0, 0.0, 1.0, 20);
	end	
end
