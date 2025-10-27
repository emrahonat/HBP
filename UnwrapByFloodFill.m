%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article below
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 

function GUN = UnwrapByFloodFill(G,BC,x0,y0)
	
	[Y,X]=size(G);
	M=1-BC; % the inverse of branch cuts is the pixels that are allowed to be floodfilled
	I=-BC;  % pixels that should not be unwrapped (branch-cuts) are marked as -1 in an indicator matrix
	GUN=G;zeros(Y,X);

	[my,mx]=find(M);Y1=min(my);Y2=max(my);X1=min(mx);X2=max(mx);% find the index of pixels which are unwrapable
	x=x0;y=y0;% starting point for unwrapping. This can be either user provided or any unwrapable point as selected below.
	k=round(length(mx)/2);x=mx(k);y=my(k);% select the mid point of matrix ,which is not branch cut, as the starting point

	GUN(y,x)=G(y,x);I(y,x)=1;%starting point is assummed to be unwrapped. Any other proper point can be selected
		
	nh=[];ind=Y*(x-1)+y;
	  
	if x-1 >=X1 
		nh=[nh ;ind-Y];
	end
	if x+1 <=X2 
		nh=[nh ;ind+Y];
	end
	if y-1 >=Y1 
		nh=[nh ;ind-1];
	end
	if y+1 <=Y2 
		nh=[nh ;ind+1];
	end

	NLI=zeros(Y,X);% the indicator matrix for next samples to be processed 
	NLI(nh)=1-abs(I(nh));% the neighbourhood of initial point x,y to be unwrapped. The absolute operation is needed to take care of -1 values in I.
	nextlist=find(NLI);  % next list of pixels wich can be unwrapped by using the neighborhing unwrapped pixels   
	L=length(nextlist);

	while(L)
		NLI=zeros(Y,X);% the indicator matrix for next samples to be processed 
		for k=1:L
			ind=nextlist(k);
			[y,x]=ind2sub([Y X],ind);%get a point from next list to be unwrapped   
			
			% determine neighbourhood 
			nh=[];
			if x-1 >=X1 
				nh=[nh ;ind-Y];
			end
			if x+1 <=X2 
				nh=[nh ;ind+Y];
			end
			if y-1 >=Y1 
				nh=[nh ;ind-1];
			end
			if y+1 <=Y2 
				nh=[nh ;ind+1];
			end
			
			In=I(nh); % Neighbourhood 
			GUNn=GUN(nh); % Unwrapped samples in Neighbourhood Matrix  
			Q=GUNn(In==1);% construct a vector containing only the unwrapped samples within neighbourhood.
			GUN(y,x)=Q(1) + wrap_phase(G(y,x)-Q(1));%Unwrap using the first previously unwrapped sample. For noise removel average of more than one prviously unwrapped  samples can be used
			I(y,x)=1;% mark the current phase sample as processed (unwrapped)   
			% determine de next list of points to be unwarpped (region growing) by marking the wrapped (I(ry,rx)=0) points in neighbourhood
			NLI(nh)=1-abs(I(nh));%absolute operation is needed to exclude -1 values in I. Becuse they are branch cut areas that should not be unwrapped
		end
		nextlist=find(NLI);
		L=length(nextlist);
	end 

	% finally process the brunch cuts which are  actually border samples next to branch cuts and can be unwrapable 

	[Iy,Jx]=find(BC);L=length(Iy);%locate all brunch cut pixels
	for k=1:L
		y=Iy(k);x=Jx(k);
		rngy=max(Y1,y-1):min(Y2,y+1);
		rngx=max(X1,x-1):min(X2,x+1);
		In=I(rngy,rngx); % Neighbourhood 
		GUNn=GUN(rngy,rngx); % Unwrapped samples in Neighbourhood Matrix  
		Q=GUNn(In==1);% construct a vector containing only the unwrapped samples within neighbourhood.
		if ~isempty(Q) % if a unwrapped sample in neighborhood is available
			GUN(y,x)=Q(1) + wrap_phase(G(y,x)-Q(1));%Unwrap using the first previously unwrapped sample.
			I(y,x)=2;% mark the post proccessed branch cuts pixels as 2 so as not to be used for further unwrapping 
		end
	 
	end
	
	post_pxu=sum(sum(I==2));%number of post processed brunch cut pixels

	% find isolated areas
	px=Y*X;pxbc=sum(sum(BC));pxu=sum(sum(I==1))+ post_pxu;
	display(['Size of phase map             :' num2str(Y) ' x ' num2str(X)])
	display(['Number of pixels              :' num2str(px)])
	display(['Number of unwrapped pixels    :' num2str(pxu)])
	display(['Number of branch cut pixels   :' num2str(pxbc)])
	display(['Number of isolated pixels     :' num2str(px-pxu)])

end
