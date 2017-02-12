%% Grain simulation of fighting Pokemon
% Code layout:
%   - Set up constants
%   - Set up the pokemon type list and colormap accordingly
%   - Pre-allocate arrays
%   - Distribute pokemon stats in an array
%   - Loop over arrays, making logic decisions and drawing

%% Current flaws/things to work on: 
% 
%   - The fastest pokemon hits the other, that is the end of the round
%       quite possible some pokemon will just get whaled on and never
%       get a chance to attack anyone, no 'call and response' battling
%   - ATK and DEF are constant always right now
%   - How do we deal with pokemon becoming large blobs?
%       Currently the large blobs never get BETTER stats, they just get
%       multiple clones of themselves over the course of ages
%   - Types are not used in battle apart from "friend or foe"
%   - In simulation there are small island dots that never change
%       Need to debug this area of code
%

%% Code
width = 600;
height = 600;
tw = 3;

%{
types = ['Normal'; 'Fire'; 'Water'; 'Electric'; 'Grass'; 'Ice'; ...
    'Fighting'; 'Poison'; 'Ground'; 'Flying'; 'Psychic'; 'Bug'; 'Rock'; ...
    'Ghost'; 'Dragon'; 'Dark'; 'Steel'; 'Fairy';];
%}

cmap = 1/255.*[200,200,200;     % Normal
    255,0,0;                    % Fire
    0,0,255;                    % Water
    255,255,0;                  % Electric
    0,255,0;                    % Grass
    100,100,255;                % Ice
    153,37,33;                  % Fighting
    100,0,200;                  % Poison
    216,170,91;                 % Ground
    154,212,237;                % Flying
    255,0,255;                  % Psychic
    100,255,0;                  % Bug
    142,110,142;                % Rock
    41,26,79;                   % Ghost
    98,157,209;                 % Dragon
    20,20,20;                   % Dark
    100,100,100                 % Steel
    255,0,100;                  % Fairy
    ];


% Take advantage of Matlabs array support, don't use classes
% Each pixel will have stats and this multitude of arrays
% can be viewed to be the 'class'

attack = zeros(width/tw, height/tw);
defense = zeros(width/tw, height/tw);
health = zeros(width/tw, height/tw);
speed = zeros(width/tw, height/tw);
type1 = zeros(width/tw, height/tw);
type2 = zeros(width/tw, height/tw);
micromon = zeros(width/tw, height/tw);

% This is then split between HP, SPD, DEF and ATK
max_stat = 255;
totstat = ones(width/tw, height/tw)*max_stat; 

% Construct the micromon's stats
health = 100 + floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - health + 100;
attack = floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - attack;
defense = floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - defense;
speed = totstat;

clear totstat max_stat 
% Construct the type system, using /u/Morning_Fresh logic
% Type 2 is non zero every 25%
% Type 1 is one of 18 types: [0, 17]
type1 = floor(rand(width/tw, height/tw)*18);
type2 = floor(rand(width/tw, height/tw)*18).*(rand(width/tw, height/tw)<=0.25);

for iter = 1:2000
    image(1:width/tw, 1:height/tw, type1)
    colormap(cmap)
    
    % Lengthy comparisons coming up...
    
    %% Fighting
    % Iterate through grid and compare to neighbours as we go
    % There are neighbours above, below, left and right. No diagonals
    % To minimise bias we randomly select which SINGULAR pokemon to fight
    fight = floor(rand(width/tw, height/tw)*4);
    for i = 1:width/tw
        for j = 1:height/tw
            % Map the directions clockwise:
            % 0 = above, 1 = right, 2 = below, 3 = left
            if (fight(i,j) == 0)||(fight(i,j) == 2)
                % Subtract 1 from fight[i,j] to get above/below modifier
                movement = j + fight(i,j) - 1;
                if (1 <= movement && movement <= height/tw)
                   % Pokemon has a neighbour to fight?
                   if type1(i,j) == type1(i,movement)
                       continue
                   % Quickest pokemon attacks IF they can
                   elseif speed(i,j) > speed(i, movement) && ...
                           defense(i, movement) < attack(i,j)
                       health(i, movement) = health(i, movement) - attack(i,j);
                   elseif speed(i,j) < speed(i, movement) && ...
                           defense(i, j) < attack(i,movement)
                       health(i, j) = health(i, j) - attack(i,movement);
                   end
                   
                   % Absorb the opponents stats if opponent died
                   % Stats are the same between two pixels, like pokemon
                   % 'grew' from this battle
                   if health(i,j) < 0
                      speed(i,j) = speed(i, movement);
                      health(i,j) = health(i, movement);
                      attack(i,j) = attack(i, movement);
                      defense(i,j) = defense(i,movement);
                      type1(i,j) = type1(i, movement);
                      type2(i,j) = type2(i, movement);
                   elseif health(i, movement) < 0
                      speed(i, movement) = speed(i,j);
                      health(i, movement) = health(i,j);
                      attack(i, movement) = attack(i,j); 
                      defense(i,movement) = defense(i,j);
                      type1(i, movement) = type1(i,j); 
                      type2(i, movement) = type2(i,j);
                   end
                   
                end
            else
                % Subtract 2 from fight[i,j] to get L/R modifier
                movement = i + fight(i,j) - 2;
                if (1 <= movement && movement <= width/tw)
                   % Pokemon has a neighbour to fight?
                   if type1(i,j) == type1(movement,j)
                       continue
                   % Quickest pokemon attacks IF they can
                   elseif speed(i,j) > speed(movement, j) && ...
                           defense(movement, j) < attack(i,j)
                       health(movement, j) = health(movement, j) - attack(i,j);
                   elseif speed(i,j) < speed(movement, j) && ...
                           defense(i, j) < attack(movement,j)
                       health(i, j) = health(i, j) - attack(movement,j);
                   end
                   
                   % Absorb the opponents stats if opponent died
                   % Stats are the same between two pixels, like pokemon
                   % 'grew' from this battle
                   if health(i,j) < 0
                      speed(i,j) = speed(movement, j);
                      health(i,j) = health(movement, j);
                      attack(i,j) = attack(movement, j);
                      defense(i,j) = defense(movement,j);
                      type1(i,j) = type1(movement, j);
                      type2(i,j) = type2(movement, j);
                   elseif health(movement, j) < 0
                      speed(movement, j) = speed(i,j);
                      health(movement, j) = health(i,j);
                      attack(movement, j) = attack(i,j); 
                      defense(movement,j) = defense(i,j);
                      type1(movement, j) = type1(i,j); 
                      type2(movement, j) = type2(i,j);
                   end
                   
                end
            end
            
        end
    end
    
    %% Consuming the dead and making them our own
    % Could add an array of co-ordinates to keep track of where pokemon
    % are actively fighting, thus avoiding the middles of large pokemon
    
    %% Screen delay so progression is visible
    pause(0.0001)
    
end


% If neighbouring pixels are the same colour then leave the
% Expand through the arrays from there

%image([1:200], [1:200], stat])
%colormap([regional definitions])


