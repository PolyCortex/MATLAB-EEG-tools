function ColorM = ColorM_assigment(Num, para)

if Num == 0
    %default
    ColorM = flipud(summer(para+1));
elseif Num == 1
    ColorM = flipud(autumn(para+1));    
elseif Num == 2
    ColorM = flipud(bone(para+1));    
elseif Num == 3
    ColorM = flipud(colorcube(para+1));    
elseif Num == 4
    ColorM = flipud(cool(para+1));    
elseif Num == 5
    ColorM = flipud(copper(para+1));    
elseif Num == 6
    ColorM = flipud(flag(para+1));   
elseif Num == 7
    ColorM = flipud(gray(para+1));    
elseif Num == 8
    ColorM = flipud(hot(para+1));    
elseif Num == 9
    ColorM = flipud(hsv(para+1));    
elseif Num == 10
    ColorM = flipud(jet(para+1));    
elseif Num == 11
    ColorM = flipud(lines(para+1));    
elseif Num == 12
    ColorM = flipud(pink(para+1));    
elseif Num == 13
    ColorM = flipud(prism(para+1));    
elseif Num == 14
    ColorM = flipud(spring(para+1));
elseif Num == 15
    ColorM = flipud(summer(para+1));    
elseif Num == 16
    ColorM = flipud(white(para+1));    
elseif Num == 17
    ColorM = flipud(winter(para+1));    
end

end