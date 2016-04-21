function [ xy ] = make_object_xy(objecttype, objectcolour, mid_coords)
%MAKE_OBJECT_XY This is more or less a copy of display_object
%   Outputs a 2x4 matrix with startx, starty, endx and endy for the TWO
%   lines that are part of each object


fixCrossDimPix = 10;

if objecttype == 9

	xCoords = [0 0 0 0];
	yCoords = [0 0 0 0];


elseif objecttype == 8

	xCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 7

	xCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 6

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix fixCrossDimPix fixCrossDimPix];

elseif objecttype == 5

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];

elseif objecttype == 4

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 3

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 2

	xCoords = [-(fixCrossDimPix+2) fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 1

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 -fixCrossDimPix -fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

else

	error('Object type not defined!');

end

            if objectcolour == 0

            objectcolourcode = [0 0 255];


            else

            objectcolourcode = [255 0 0];

            end

xy = [xCoords+mid_coords(1); yCoords+mid_coords(2)];
end