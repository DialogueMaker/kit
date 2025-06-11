--!strict

local dialogueMakerKit = script.Parent.Parent; -- Replace with your own path to the DialogueMakerKit folder.
local Client = require(dialogueMakerKit.Packages.Client);
local Conversation = require(dialogueMakerKit.Packages.Conversation);
local Message = require(dialogueMakerKit.Packages.Message);
local Redirect = require(dialogueMakerKit.Packages.Redirect);

local StandardTheme = require(dialogueMakerKit.Packages.StandardTheme);

-- Create a new conversation.
local function generateDynamicMessageContent()
      
  local words = {"mama", "mia", "hey", "oh", "my"}
  local wordCount = Random.new():NextInteger(4, 10);
  local content = "";
  for wordIndex = 1, wordCount do

    local selectedWord = words[Random.new():NextInteger(1, #words)];
    content = content .. (if content ~= "" then " " else "") .. selectedWord;
  
  end

  return {content};

end;

local conversation = Conversation.new({}, {
  Message.new(generateDynamicMessageContent, {
    runCompletionAction = function(self, client)

      self:runCleanupAction(client);
      
    end
  }, {
    Redirect.new({}, function(self)
      
      return {self:getConversation():getNextVerifiedDialogue()};
      
    end);
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