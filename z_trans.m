file_read   =   load("Vcap_1.matlab")               ;   %   loading file where 1st column is time (x data) and 2nd column is output (y data)
Filedata    =   file_read                           ;
yp          =   Filedata(:,2)                       ;   %   y values loaded from file
xp          =   Filedata(:,1)                       ;   %   x values loaded from file

x           =   [-5:0.01:5]                         ;   %   -5 to 5 is the range over which the z plane is calculated.
                                                        %   0.01 determines the number of values taken in between to calculate. 
                                                        %   Has an extreme effect on processing speed
                                                        
y           =   [-pi/2:(pi/8):pi/2]                ;    %   Angles for which the Z transform is calculated.
                                                        %   0 to pi is for the whole circle (as each of the axii covers both sides of origin), and calculation is done 
                                                        %   for 8 axii at pi/8 angle from each other. Has linear effect on speed.
                                                        
z           =   zeros(length(x),length(y))         ;    %   pre allocation of size for speed
xa          =   zeros(length(x),length(y))         ;    %   pre allocation of size for speed
ya          =   zeros(length(x),length(y))         ;    %   pre allocation of size for speed


for theta = 1:length(y)                 %   loop for calculation of all axii
    for point = 1:length(x)             %   loop for calculation at each point on the axis
        for k = 0:(length(yp)-1)        %   loop for the term no. currently being calculated (for the exponent term)
            z(point,theta) = z(point) + (yp(k+1)*((x(point)*exp(1i*y(theta)))^(-k)))    ; 
        end
        xa(point,theta) = x(point)*cos(y(theta))  ;     %   corresponding x axis value for the cartesian plane
        ya(point,theta) = x(point)*sin(y(theta))  ;     %   corresponding y axis value for the cartesian plane

    end
end


zlog        =   log10(abs(z))/log10(20)             ;   %   conversion of magnitude to decibels

zlc         =   zlog+abs(min(zlog))                 ;   %   moving the scale to positive for graph coloring
max_zlc     =   max(max(zlc(~isinf(zlc))))          ;   %   maximum of the shifted magnitude scale excluding infinity
color_zlc   =   log((zlc/max_zlc)+1)/log(2)         ;   %   coloring matrix scaling from 0-1
color_zlc(isinf(color_zlc)|isnan(color_zlc)) = 1    ;   %   changing the color of nan and infinity to maximum color value (1)

[xcyl,ycyl,zcyl] = cylinder (1,200)                 ;   %   coordinates for unit cylinder for stability determination


figure;
hold on
for theta = 1:(length(y) - 1)
    for point = 1:(length(x) - 1)
        fill3([xa(point,theta) xa(point,theta+1) xa(point+1,theta+1) xa(point+1,theta)],[ya(point,theta) ya(point,theta+1) ya(point+1,theta+1) ya(point+1,theta)],[zlog(point,theta) zlog(point,theta+1) zlog(point+1,theta+1) zlog(point+1,theta)],[color_zlc(point+(0<x(point)),theta) 0 (1-color_zlc(point+(0<x(point)),theta))],'LineStyle','none');
        %   plotting small segments with 2 x values, 2 y values and 2 z values (8 points) with corresponding color  
    end
end
%h1 = surf(xcyl,ycyl,zcyl*max_zlc,'EdgeColor','y','FaceColor','y')   ;    %  plotting of cylinder with unit radius for stability determination   
hold off
