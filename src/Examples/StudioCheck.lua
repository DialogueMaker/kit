--!strict

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local dialogueMakerKit = script.Parent.Parent; -- Replace with your own path to the DialogueMakerKit folder.
local Client = require(dialogueMakerKit.Packages.Client);
local Conversation = require(dialogueMakerKit.Packages.Conversation);
local Message = require(dialogueMakerKit.Packages.Message);

local StandardTheme = require(dialogueMakerKit.Packages.StandardTheme);

-- Create a new conversation.
local player = Players.LocalPlayer;
local conversation = Conversation.new({}, {
  [1] = Message.new(`Hey, {player.Name}. Did you save today?`, {
    verifyCondition = function()

      return RunService:IsStudio();
      
    end
  });
  [2] = Message.new(`Hey, {player.Name}. Remember to like and subscribe.`);
});

-- Start the conversation.
Client.new({
  dialogue = conversation:getNextVerifiedDialogue();
  settings = {
    theme = {
      component = StandardTheme
    };
  };
});

return {};