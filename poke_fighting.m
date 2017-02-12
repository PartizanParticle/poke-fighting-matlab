%% Grain simulation of fighting Pokemon
% Code layout:
%   - Set up constants
%   - Set up the pokemon type list and colormap accordingly
%   - Pre-allocate arrays
%   - Distribute pokemon stats in an array
%   - Loop over arrays, making logic decisions and drawing

%% Current flaws/things to work on:
%   - None
%% Code

% Variables
width = 600;
height = 600;
tw = 1;
HP_buff = 20;
ATK_buff = 10;
DEF_buff = 5;

file_nm = 'simulation.gif';

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

ATK = zeros(width/tw, height/tw);
DEF = zeros(width/tw, height/tw);
HP = zeros(width/tw, height/tw);
SPD = zeros(width/tw, height/tw);
type1 = zeros(width/tw, height/tw);
type2 = zeros(width/tw, height/tw);

% This is then split between HP, SPD, DEF and ATK
max_stat = 255;
totstat = ones(width/tw, height/tw)*max_stat;

% Construct the micromon's stats
HP = 100 + floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - HP + 100;
ATK = floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - ATK;
DEF = floor(rand(width/tw, height/tw).*totstat);
totstat = totstat - DEF;
SPD = totstat;

clear totstat max_stat
% Construct the type system, using /u/Morning_Fresh logic
% Type 2 is non zero every 25%
% Type 1 is one of 18 types: [0, 17]
type1 = floor(rand(width/tw, height/tw)*18);
type2 = floor(rand(width/tw, height/tw)*18).*(rand(width/tw, height/tw)<=0.25);

for iter = 1:2000
    
    
    % Lengthy comparisons coming up...
    
    %% Fighting
    % Iterate through all pokemon in rand order and compare to neighbours
    % There are neighbours above, below, left and right. No diagonals
    % To minimise bias we randomly select which SINGULAR pokemon to fight
    fight = floor(rand(width/tw, height/tw)*4);
    for i = randperm(width/tw)
        for j = randperm(height/tw)
            % Map the directions clockwise:
            % 0 = above, 1 = right, 2 = below, 3 = left
            if (fight(i,j) == 0) || (fight(i,j) == 2)
                % Subtract 1 from fight[i,j] to get above/below modifier
                enmy = j + fight(i,j) - 1;
                if (1 <= enmy && enmy <= height/tw)
                    % Pokemon has a neighbour to fight?
                    if type1(i,j) == type1(i,enmy)
                        continue
                        % Quickest pokemon ATKs first
                    elseif SPD(i,j) > SPD(i, enmy)
                        dmg_mult = max(getEff(type1(i,j), type1(i, enmy)), ...
                            getEff(type2(i,j), type1(i, enmy)));
                        
                        dmg_enmy = (ATK(i,j) - DEF(i, enmy)).*dmg_mult;
                        HP(i, enmy) = HP(i, enmy) - dmg_enmy.*(dmg_enmy>0);
                        
                        % Retaliate if possible
                        if HP(i,enmy) > 0
                            dmg_mult = max(getEff(type1(i,enmy), type1(i, j)), ...
                                getEff(type2(i,enmy), type1(i, j)));
                            
                            dmg_acc = (ATK(i,enmy) - DEF(i, j)).*dmg_mult;
                            HP(i, j) = HP(i, j) - dmg_acc.*(dmg_acc>0);
                        end
                    else
                        dmg_mult = max(getEff(type1(i,enmy), type1(i, j)), ...
                            getEff(type2(i,enmy), type1(i, j)));
                        
                        dmg_acc = (ATK(i,enmy) - DEF(i, j)).*dmg_mult;
                        HP(i, j) = HP(i, j) - dmg_acc.*(dmg_acc>0);
                        
                        % Retaliate if possible
                        if HP(i,j) > 0
                            dmg_mult = max(getEff(type1(i,j), type1(i, enmy)), ...
                                getEff(type2(i,j), type1(i, enmy)));
                            
                            dmg_enmy = (ATK(i,j) - DEF(i, enmy)).*dmg_mult;
                            HP(i, enmy) = HP(i, enmy) - dmg_enmy.*(dmg_enmy>0);
                        end
                    end
                    
                    % Absorb the opponents stats if opponent died
                    % Stats are the same between two pixels, no growth yet
                    if HP(i,j) < 0
                        % Buff up the winner
                        HP(i, enmy) = HP(i, enmy) + HP_buff;
                        ATK(i, enmy) = ATK(i, enmy) + ATK_buff;
                        DEF(i, enmy) = DEF(i, enmy) + DEF_buff;
                        
                        SPD(i,j) = SPD(i, enmy);
                        HP(i,j) = HP(i, enmy);
                        ATK(i,j) = ATK(i, enmy);
                        DEF(i,j) = DEF(i,enmy);
                        type1(i,j) = type1(i, enmy);
                        type2(i,j) = type2(i, enmy);
                    elseif HP(i, enmy) < 0
                        HP(i, j) = HP(i, j) + HP_buff;
                        ATK(i, j) = ATK(i, j) + ATK_buff;
                        DEF(i, j) = DEF(i, j) + DEF_buff;
                        
                        SPD(i, enmy) = SPD(i,j);
                        HP(i, enmy) = HP(i,j);
                        ATK(i, enmy) = ATK(i,j);
                        DEF(i,enmy) = DEF(i,j);
                        type1(i, enmy) = type1(i,j);
                        type2(i, enmy) = type2(i,j);
                    end
                    
                end
            else
                % Subtract 2 from fight[i,j] to get L/R modifier
                enmy = i + fight(i,j) - 2;
                if (1 <= enmy && enmy <= width/tw)
                    % Pokemon has a neighbour to fight?
                    if type1(i,j) == type1(enmy,j)
                        continue
                        % Quickest pokemon ATKs first
                    elseif SPD(i,j) > SPD(enmy,j)
                        dmg_mult = max(getEff(type1(i,j), type1(enmy, j)), ...
                            getEff(type2(i,j), type1(enmy, j)));
                        
                        dmg_enmy = (ATK(i,j) - DEF(i, enmy)).*dmg_mult;
                        HP(enmy,j) = HP(enmy,j) - dmg_enmy.*(dmg_enmy>0);
                        
                        % Retaliate if possible
                        if HP(enmy,j) > 0
                            dmg_mult = max(getEff(type1(enmy,j), type1(i, j)), ...
                                getEff(type2(enmy,j), type1(i, j)));
                            
                            dmg_acc = (ATK(enmy,j) - DEF(i, j)).*dmg_mult;
                            HP(i,j) = HP(i,j) - dmg_acc.*(dmg_acc>0);
                        end
                    else
                        dmg_mult = max(getEff(type1(enmy,j), type1(i, j)), ...
                            getEff(type2(enmy,j), type1(i, j)));
                        
                        dmg_acc = (ATK(enmy,j) - DEF(i, j)).*dmg_mult;
                        HP(i,j) = HP(i,j) - dmg_acc.*(dmg_acc>0);
                        
                        % Retaliate if possible
                        if HP(i,j) > 0
                            dmg_mult = max(getEff(type1(i,j), type1(enmy, j)), ...
                                getEff(type2(i,j), type1(enmy, j)));
                            
                            dmg_enmy = (ATK(i,j) - DEF(i, enmy)).*dmg_mult;
                            HP(enmy,j) = HP(enmy,j) - dmg_enmy.*(dmg_enmy>0);
                        end
                    end
                    
                    % Absorb the opponents stats if opponent died
                    % Stats are the same between two pixels, like pokemon
                    % 'grew' from this battle
                    if HP(i,j) < 0
                        HP(enmy, j) = HP(enmy, j) + HP_buff;
                        ATK(enmy, j) = ATK(enmy, j) + ATK_buff;
                        DEF(enmy, j) = DEF(enmy, j) + DEF_buff;
                        
                        SPD(i,j) = SPD(enmy, j);
                        HP(i,j) = HP(enmy, j);
                        ATK(i,j) = ATK(enmy, j);
                        DEF(i,j) = DEF(enmy,j);
                        type1(i,j) = type1(enmy, j);
                        type2(i,j) = type2(enmy, j);
                    elseif HP(enmy, j) < 0
                        HP(i, j) = HP(i, j) + HP_buff;
                        ATK(i, j) = ATK(i, j) + ATK_buff;
                        DEF(i, j) = DEF(i, j) + DEF_buff;
                        
                        SPD(enmy, j) = SPD(i,j);
                        HP(enmy, j) = HP(i,j);
                        ATK(enmy, j) = ATK(i,j);
                        DEF(enmy,j) = DEF(i,j);
                        type1(enmy, j) = type1(i,j);
                        type2(enmy, j) = type2(i,j);
                    end
                    
                end
            end
            
        end
    end
    
    %% Extensions
    % Could add an array of co-ordinates to keep track of where pokemon
    % are actively fighting, thus avoiding the middles of large pokemon
    
    %% Write out to gif and draw
    % frame rate is set to 60fps currently
    
    % Draw graph
    figure(1)
    clf(figure(1))
    
    subplot(1,2,1)
    image(1:width/tw, 1:height/tw, type1)
    colormap(cmap)
    set(gca,'visible','off');
    
    [data, edges] = histcounts(type1(:), 1:19);
    subplot(1,2,2)
    hold on
    for d = 1:length(data)
        bar(d, data(d), 'FaceColor', cmap(d,:))
    end
    hold off
    
    truesize(figure(1), [height width])
    axis([0.5, 18.5, 0, width.*height./(tw.*tw)])
    drawnow()
    
    % gif writing
    % straight outta documentation
   
    frame = getframe(1);
    im = frame2im(frame);
    [A, map] = rgb2ind(im, cmap);
    if iter == 1
        imwrite(A, map, file_nm, 'gif', 'LoopCount', Inf, 'DelayTime', 1/60);
    else
        imwrite(A,map,file_nm,'gif','WriteMode','append','DelayTime',1/60);
    end
    
    
end



