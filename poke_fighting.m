
width = 600;
height = 600;
tw = 3;

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


% If neighbouring pixels are the same colour then leave the
% Expand through the arrays from there





