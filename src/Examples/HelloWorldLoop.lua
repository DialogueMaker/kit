--!strict

local dialogueMakerKit = script.Parent.Parent; -- Replace with your own path to the DialogueMakerKit folder.
local Client = require(dialogueMakerKit.Packages.Client);
local Conversation = require(dialogueMakerKit.Packages.Conversation);
local Message = require(dialogueMakerKit.Packages.Message);
local Response = require(dialogueMakerKit.Packages.Response);
local Redirect = require(dialogueMakerKit.Packages.Redirect);
local DialogueMakerTypes = require(dialogueMakerKit.Packages.DialogueMakerTypes);

local StandardTheme = require(dialogueMakerKit.Packages.StandardTheme);

type Dialogue = DialogueMakerTypes.Dialogue;

-- Create a new conversation.
local conversation = Conversation.new({
  children = {
    [1] = Message.new({
      content = "Hello, world!";
      runInitializationAction = function()

        print("NPC: Hello, world!");

      end;
      children = {
        [1] = Response.new({
          content = "Goodbye, world!";
          runInitializationAction = function()

            print("Player: Goodbye, world!");

          end;
        });
        [2] = Response.new({
          content = "Hello again, world!";
          runInitializationAction = function(self, client)

            print("Player: Hello again, world!");

          end;
          children = {
            [1] = Redirect.new({
              getChildren = function(self)

                -- This is a redirect to the first message.
                return {(self:getParent() :: Dialogue):getParent() :: Dialogue};

              end;
            })
          }
        });
      }
    });
  };
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