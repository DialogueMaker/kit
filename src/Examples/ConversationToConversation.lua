--!strict

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");

local dialogueMakerKit = script.Parent.Parent; -- Replace with your own path to the DialogueMakerKit folder.
local Client = require(dialogueMakerKit.Packages.Client);
local Conversation = require(dialogueMakerKit.Packages.Conversation);
local Message = require(dialogueMakerKit.Packages.Message);
local PauseEffect = require(dialogueMakerKit.Packages.PauseEffect);
local DialogueMakerTypes = require(dialogueMakerKit.Packages.DialogueMakerTypes);

local StandardTheme = require(dialogueMakerKit.Packages.StandardTheme);

type Page = DialogueMakerTypes.Page;

local timeoutTask: thread? = nil;

local nextConversation = Conversation.new({}, {
  [1] = Message.new("Let's battle!!", {
    settings = {
      speaker = {
        name = "Random Guy";
      };
    };
    runCompletionAction = function(self, client)

      timeoutTask = task.delay(3, function()
        
        self:runCleanupAction(client);

      end);

    end;
    runCleanupAction = function(self, client)

      if timeoutTask then

        if coroutine.status(timeoutTask) == "suspended" then

          task.cancel(timeoutTask);

        end

        timeoutTask = nil;

      end

      self:runDefaultCleanupAction(client);

      local screenGui = Instance.new("ScreenGui");
      screenGui.DisplayOrder = 1;
      screenGui.ScreenInsets = Enum.ScreenInsets.None;
      screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

      local sound = Instance.new("Sound");
      sound.SoundId = "rbxassetid://6573255933";
      sound.Parent = screenGui;
      sound:Play();

      local blurEffect = Instance.new("BlurEffect");
      blurEffect.Size = 24;
      blurEffect.Parent = Lighting;

      task.wait(1);

      local textLabel = Instance.new("TextLabel");
      textLabel.AnchorPoint = Vector2.new(0.5, 0.5);
      textLabel.Position = UDim2.fromScale(0.5, 0.5);
      textLabel.TextColor3 = Color3.new(1, 1, 1);
      textLabel.FontFace = Font.fromName("BuilderSans");
      textLabel.Text = "you lost the game.";
      textLabel.TextSize = 36;
      textLabel.TextTransparency = 1;
      textLabel.Parent = screenGui;

      TweenService:Create(textLabel, TweenInfo.new(3), {
        TextTransparency = 0
      }):Play();

    end;
  })
});

local pauseEffect = PauseEffect.new(1.5);
local conversation = Conversation.new({
  settings = {
    speaker = {
      name = "Bud";
    };
  };
}, {
  [1] = Message.new({"(sigh)", pauseEffect, " I'm glad that's finally over"} :: Page, {
    runCompletionAction = function(self, client)

      -- Instantly go to the next conversation.
      self:runCleanupAction(client);

    end;
    runCleanupAction = function(self, client)

      client:clone({
        dialogue = nextConversation:getNextVerifiedDialogue();
      });

    end;
  })
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