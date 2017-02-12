function [ dmg_mult ] = getEff(t1, t2 )
%getEff, dmg_mult = s damage multiplier of various pokemon types
%   Taken straight for /u/Morning_Fresh's code and ported to matlab
if (t1 == 0) % normal
    if (t2 == 13)
        dmg_mult = 0;
        return
    end
elseif (t1 == 1) % fire
    if (t2 == 4 || t2 == 5 || t2 == 11 || t2 == 16)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 2 || t2 == 12 || t2 == 14)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 2) %water
    if (t2 == 1 || t2 == 8 || t2 == 12)
        dmg_mult =  2;
        return
    elseif (t2 == 2 || t2 == 4 || t2 == 14)
        dmg_mult =  1/2;
        return
    end
end


if (t1 == 3) %electric
    if (t2 == 2 || t2 == 9)
        dmg_mult =  2;
        return
    elseif (t2 == 8)
        dmg_mult =  0;
        return
    end
elseif (t1 == 4) %grass
    if (t2 == 2 || t2 == 8 || t2 == 12)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 4 || t2 == 7 || t2 == 9 || t2 == 11 ...
            || t2 == 14 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 5) %ice
    if (t2 == 4 || t2 == 8 || t2 == 9 || t2 == 14)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 2 || t2 == 5 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 6) %fighting
    if (t2 == 0 || t2 == 5 || t2 == 12 || t2 == 15 || t2 == 16)
        dmg_mult =  2;
        return
    elseif (t2 == 7 || t2 == 9 || t2 == 10 || t2 == 11 || t2 == 17)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 7) %poison
    if (t2 == 4 || t2 == 17)
        dmg_mult =  2;
        return
    elseif (t2 == 7 || t2 == 8 || t2 == 12 || t2 == 13)
        dmg_mult =  1/2;
        return
    elseif (t2 == 16)
        dmg_mult =  0;
        return
    end
elseif (t1 == 8) %ground
    if (t2 == 1 || t2 == 3 || t2 == 7 || t2 == 12 || t2 == 16)
        dmg_mult =  2;
        return
    elseif (t2 == 4 || t2 == 11)
        dmg_mult =  1/2;
        return
    elseif (t2 == 9)
        dmg_mult =  0;
        return
    end
elseif (t1 == 9) %flying
    if (t2 == 4 || t2 == 6 || t2 == 11)
        dmg_mult =  2;
        return
    elseif (t2 == 3 || t2 == 12 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 10) %psychic
    if (t2 == 6 || t2 == 7)
        dmg_mult =  2;
        return
    elseif (t2 == 10 || t2 == 16)
        dmg_mult =  1/2;
        return
    elseif (t2 == 15)
        dmg_mult =  0;
        return
    end
elseif (t1 == 11) %bug
    if (t2 == 4 || t2 == 10 || t2 == 15)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 6 || t2 == 7 || t2 == 9 || t2 == 13 || ...
            t2 == 16 || t2 == 17)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 12) %rock
    if (t2 == 1 || t2 == 5 || t2 == 9 || t2 == 11)
        dmg_mult =  2;
        return
    elseif (t2 == 6 || t2 == 8 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 13) %ghost
    if (t2 == 10 || t2 == 13)
        dmg_mult =  2;
        return
    elseif (t2 == 15)
        dmg_mult =  1/2;
        return
    elseif (t2 == 0)
        dmg_mult =  0;
        return
    end
elseif (t1 == 14) %dragon
    if (t2 == 14)
        dmg_mult =  2;
        return
    elseif (t2 == 16)
        dmg_mult =  1/2;
        return
    elseif (t2 == 17)
        dmg_mult =  0;
        return
    end
elseif (t1 == 15) %dark
    if (t2 == 10 || t2 == 13)
        dmg_mult =  2;
        return
    elseif (t2 == 6 || t2 == 15 || t2 == 17)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 16) %steel
    if (t2 == 5 || t2 == 12 || t2 == 17)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 2 || t2 == 3 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
elseif (t1 == 17) %fairy
    if (t2 == 6 || t2 == 14 || t2 == 15)
        dmg_mult =  2;
        return
    elseif (t2 == 1 || t2 == 7 || t2 == 16)
        dmg_mult =  1/2;
        return
    end
end

dmg_mult =  1;

end

