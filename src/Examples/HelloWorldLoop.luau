--!strict

local dialogueMakerKit = script.Parent.Parent; -- Replace with your own path to the DialogueMakerKit folder.
local Client = require(dialogueMakerKit.Packages.Client);
local Conversation = require(dialogueMakerKit.Packages.Conversation);
local Message = require(dialogueMakerKit.Packages.Message);
local Response = require(dialogueMakerKit.Packages.Response);
local Redirect = require(dialogueMakerKit.Packages.Redirect);

local StandardTheme = require(dialogueMakerKit.Packages.StandardTheme);

-- Create a new conversation.
local conversation = Conversation.new({}, {
  [1] = Message.new("Hello, world!", {}, {
    [1] = Response.new("Hello, world!", {}, {
      [1] = Redirect.new({}, function(self)

        return {self:getConversation():getNextVerifiedDialogue()}

      end);
    });
    [2] = Response.new("Goodbye, world!", {}, {
      [1] = Message.new("H-huh!? You weren't supposed to do that! You gotta get outta here before they find out!");
    })
  });
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